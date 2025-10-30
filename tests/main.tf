provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  name   = basename(path.cwd)
  region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  karpenter_tag_key = "karpenter.sh/discovery/${local.name}"

  tags = {
    Example    = local.name
    GithubRepo = "aws-blueprints/terraform-aws-eks-blueprints-addon"
  }
}

################################################################################
# EKS Blueprints Addon
################################################################################

module "helm_release_pod_identity" {
  source = "../"

  # Only one can be enabled at a time
  create = true

  chart         = "cni-metrics-helper"
  chart_version = "1.20.4"
  repository    = "https://aws.github.io/eks-charts"
  description   = "A Helm chart for CNI metrics helper"
  namespace     = "kube-system"

  values = [
    <<-EOT
      image:
        region: ${local.region}
      env:
        AWS_CLUSTER_ID: ${module.eks.cluster_name}
      serviceAccount:
        name: cni-metrics-helper
    EOT
  ]

  # IAM role
  role_name = "cni-metrics-helper"
  policy_statements = {
    CloudWatchWrite = {
      actions = [
        "cloudwatch:PutMetricData"
      ]
      resources = ["*"]
    }
  }

  # EKS Pod Identity
  enable_pod_identity = true
  pod_identity_associations = {
    this = {
      cluster_name = module.eks.cluster_name
      # namespace is inherited from chart
      service_account = "cni-metrics-helper"
    }
  }

  tags = local.tags
}

module "helm_release_irsa" {
  source = "../"

  # Only one can be enabled at a time
  create = false

  chart         = "cni-metrics-helper"
  chart_version = "1.20.4"
  repository    = "https://aws.github.io/eks-charts"
  description   = "A Helm chart for CNI metrics helper"
  namespace     = "kube-system"

  values = [
    <<-EOT
      image:
        region: ${local.region}
      env:
        AWS_CLUSTER_ID: ${module.eks.cluster_name}
      serviceAccount:
        name: cni-metrics-helper
    EOT
  ]

  set = [
    {
      # Set the annotation for IRSA using the role created in this module
      name                  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value_is_iam_role_arn = true
    }
  ]

  # IAM role
  role_name = "cni-metrics-helper"
  policy_statements = {
    CloudWatchWrite = {
      actions = [
        "cloudwatch:PutMetricData"
      ]
      resources = ["*"]
    }
  }

  # Trust policy for IRSA
  irsa_oidc_providers = {
    this = {
      provider_arn = module.eks.oidc_provider_arn
      # namespace is inherited from chart
      service_account = "cni-metrics-helpere"
    }
  }

  tags = local.tags
}

module "irsa_only" {
  source = "../"

  # Disable helm release
  create_release = false

  # IAM role for service account (IRSA)
  role_name = "aws-vpc-cni-ipv4"
  role_policies = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  irsa_oidc_providers = {
    this = {
      provider_arn    = module.eks.oidc_provider_arn
      namespace       = "kube-system"
      service_account = "aws-node"
    }
  }

  tags = local.tags
}

module "disabled" {
  source = "../"

  create = false
}

################################################################################
# Supporting resources
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name
  kubernetes_version = "1.34"

  # Access for Helm to deploy via Terraform
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    (local.karpenter_tag_key) = local.name
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    (local.karpenter_tag_key) = local.name
  }

  tags = local.tags
}
