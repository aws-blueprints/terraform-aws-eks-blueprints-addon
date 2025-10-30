# Amazon EKS Blueprints Addon Tests

Configuration in this directory provisions:

- An EKS cluster and VPC used to support the example
- An addon (Helm release) for [`metrics-server`](https://github.com/kubernetes-sigs/metrics-server) without an IAM role for service account (IRSA)
- An addon (Helm release) for [`karpenter`](https://github.com/aws/karpenter) with an IAM role for service account (IRSA)
- An IAM role for service account (IRSA) suitable for use by the [AWS VPC-CNI](https://github.com/aws/amazon-vpc-cni-k8s)

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_disabled"></a> [disabled](#module\_disabled) | ../ | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.0 |
| <a name="module_helm_release_irsa"></a> [helm\_release\_irsa](#module\_helm\_release\_irsa) | ../ | n/a |
| <a name="module_helm_release_pod_identity"></a> [helm\_release\_pod\_identity](#module\_helm\_release\_pod\_identity) | ../ | n/a |
| <a name="module_irsa_only"></a> [irsa\_only](#module\_irsa\_only) | ../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_irsa_app_version"></a> [helm\_release\_irsa\_app\_version](#output\_helm\_release\_irsa\_app\_version) | The version number of the application being deployed |
| <a name="output_helm_release_irsa_chart"></a> [helm\_release\_irsa\_chart](#output\_helm\_release\_irsa\_chart) | The name of the chart |
| <a name="output_helm_release_irsa_iam_role_arn"></a> [helm\_release\_irsa\_iam\_role\_arn](#output\_helm\_release\_irsa\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_helm_release_irsa_iam_role_name"></a> [helm\_release\_irsa\_iam\_role\_name](#output\_helm\_release\_irsa\_iam\_role\_name) | Name of IAM role |
| <a name="output_helm_release_irsa_iam_role_path"></a> [helm\_release\_irsa\_iam\_role\_path](#output\_helm\_release\_irsa\_iam\_role\_path) | Path of IAM role |
| <a name="output_helm_release_irsa_iam_role_unique_id"></a> [helm\_release\_irsa\_iam\_role\_unique\_id](#output\_helm\_release\_irsa\_iam\_role\_unique\_id) | Unique ID of IAM role |
| <a name="output_helm_release_irsa_name"></a> [helm\_release\_irsa\_name](#output\_helm\_release\_irsa\_name) | Name is the name of the release |
| <a name="output_helm_release_irsa_namespace"></a> [helm\_release\_irsa\_namespace](#output\_helm\_release\_irsa\_namespace) | Name of Kubernetes namespace |
| <a name="output_helm_release_irsa_pod_identity_associations"></a> [helm\_release\_irsa\_pod\_identity\_associations](#output\_helm\_release\_irsa\_pod\_identity\_associations) | Map of Pod Identity associations created |
| <a name="output_helm_release_irsa_revision"></a> [helm\_release\_irsa\_revision](#output\_helm\_release\_irsa\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_helm_release_irsa_values"></a> [helm\_release\_irsa\_values](#output\_helm\_release\_irsa\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_helm_release_irsa_version"></a> [helm\_release\_irsa\_version](#output\_helm\_release\_irsa\_version) | A SemVer 2 conformant version string of the chart |
| <a name="output_helm_release_pod_identity_app_version"></a> [helm\_release\_pod\_identity\_app\_version](#output\_helm\_release\_pod\_identity\_app\_version) | The version number of the application being deployed |
| <a name="output_helm_release_pod_identity_associations"></a> [helm\_release\_pod\_identity\_associations](#output\_helm\_release\_pod\_identity\_associations) | Map of Pod Identity associations created |
| <a name="output_helm_release_pod_identity_chart"></a> [helm\_release\_pod\_identity\_chart](#output\_helm\_release\_pod\_identity\_chart) | The name of the chart |
| <a name="output_helm_release_pod_identity_iam_role_arn"></a> [helm\_release\_pod\_identity\_iam\_role\_arn](#output\_helm\_release\_pod\_identity\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_helm_release_pod_identity_iam_role_name"></a> [helm\_release\_pod\_identity\_iam\_role\_name](#output\_helm\_release\_pod\_identity\_iam\_role\_name) | Name of IAM role |
| <a name="output_helm_release_pod_identity_iam_role_path"></a> [helm\_release\_pod\_identity\_iam\_role\_path](#output\_helm\_release\_pod\_identity\_iam\_role\_path) | Path of IAM role |
| <a name="output_helm_release_pod_identity_iam_role_unique_id"></a> [helm\_release\_pod\_identity\_iam\_role\_unique\_id](#output\_helm\_release\_pod\_identity\_iam\_role\_unique\_id) | Unique ID of IAM role |
| <a name="output_helm_release_pod_identity_name"></a> [helm\_release\_pod\_identity\_name](#output\_helm\_release\_pod\_identity\_name) | Name is the name of the release |
| <a name="output_helm_release_pod_identity_namespace"></a> [helm\_release\_pod\_identity\_namespace](#output\_helm\_release\_pod\_identity\_namespace) | Name of Kubernetes namespace |
| <a name="output_helm_release_pod_identity_revision"></a> [helm\_release\_pod\_identity\_revision](#output\_helm\_release\_pod\_identity\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_helm_release_pod_identity_values"></a> [helm\_release\_pod\_identity\_values](#output\_helm\_release\_pod\_identity\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_helm_release_pod_identity_version"></a> [helm\_release\_pod\_identity\_version](#output\_helm\_release\_pod\_identity\_version) | A SemVer 2 conformant version string of the chart |
| <a name="output_irsa_only_app_version"></a> [irsa\_only\_app\_version](#output\_irsa\_only\_app\_version) | The version number of the application being deployed |
| <a name="output_irsa_only_chart"></a> [irsa\_only\_chart](#output\_irsa\_only\_chart) | The name of the chart |
| <a name="output_irsa_only_iam_role_arn"></a> [irsa\_only\_iam\_role\_arn](#output\_irsa\_only\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_irsa_only_iam_role_name"></a> [irsa\_only\_iam\_role\_name](#output\_irsa\_only\_iam\_role\_name) | Name of IAM role |
| <a name="output_irsa_only_iam_role_path"></a> [irsa\_only\_iam\_role\_path](#output\_irsa\_only\_iam\_role\_path) | Path of IAM role |
| <a name="output_irsa_only_iam_role_unique_id"></a> [irsa\_only\_iam\_role\_unique\_id](#output\_irsa\_only\_iam\_role\_unique\_id) | Unique ID of IAM role |
| <a name="output_irsa_only_name"></a> [irsa\_only\_name](#output\_irsa\_only\_name) | Name is the name of the release |
| <a name="output_irsa_only_namespace"></a> [irsa\_only\_namespace](#output\_irsa\_only\_namespace) | Name of Kubernetes namespace |
| <a name="output_irsa_only_pod_identity_associations"></a> [irsa\_only\_pod\_identity\_associations](#output\_irsa\_only\_pod\_identity\_associations) | Map of Pod Identity associations created |
| <a name="output_irsa_only_revision"></a> [irsa\_only\_revision](#output\_irsa\_only\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_irsa_only_values"></a> [irsa\_only\_values](#output\_irsa\_only\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_irsa_only_version"></a> [irsa\_only\_version](#output\_irsa\_only\_version) | A SemVer 2 conformant version string of the chart |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/aws-blueprints/terraform-aws-eks-blueprints-addon/blob/main/LICENSE).
