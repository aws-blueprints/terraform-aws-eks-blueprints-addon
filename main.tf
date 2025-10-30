locals {
  namespace = try(coalesce(var.namespace, "default")) # Need to explicitly set default for use with IRSA

  set = var.set != null ? [
    for s in var.set : merge(
      s,
      {
        value = s.value_is_iam_role_arn ? try(aws_iam_role.this[0].arn, "") : s.value
      }
    )
  ] : null
}

################################################################################
# Helm Release
################################################################################

resource "helm_release" "this" {
  count = var.create && var.create_release ? 1 : 0

  atomic                     = var.atomic
  chart                      = var.chart
  cleanup_on_fail            = var.cleanup_on_fail
  create_namespace           = var.create_namespace
  dependency_update          = var.dependency_update
  description                = var.description
  devel                      = var.devel
  disable_crd_hooks          = var.disable_crd_hooks
  disable_openapi_validation = var.disable_openapi_validation
  disable_webhooks           = var.disable_webhooks
  force_update               = var.force_update
  keyring                    = var.keyring
  lint                       = var.lint
  max_history                = var.max_history
  name                       = try(coalesce(var.name, var.chart), "")
  namespace                  = local.namespace
  pass_credentials           = var.pass_credentials
  postrender                 = var.postrender
  recreate_pods              = var.recreate_pods
  render_subchart_notes      = var.render_subchart_notes
  replace                    = var.replace
  repository                 = var.repository
  repository_ca_file         = var.repository_ca_file
  repository_cert_file       = var.repository_cert_file
  repository_key_file        = var.repository_key_file
  repository_password        = var.repository_password
  repository_username        = var.repository_username
  reset_values               = var.reset_values
  reuse_values               = var.reuse_values
  set                        = local.set
  set_list                   = var.set_list
  set_sensitive              = var.set_sensitive
  set_wo                     = var.set_wo
  set_wo_revision            = var.set_wo_revision
  skip_crds                  = var.skip_crds
  take_ownership             = var.take_ownership
  timeout                    = var.timeout
  timeouts                   = var.release_timeouts
  upgrade_install            = var.upgrade_install
  values                     = var.values
  verify                     = var.verify
  version                    = var.chart_version # conflicts with reserved keyword
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs
}

################################################################################
# IAM Role for Service Account(s) (IRSA)
################################################################################

locals {
  create_role = var.create && var.create_role

  role_name = try(coalesce(var.role_name, var.name), "")
}

data "aws_iam_policy_document" "assume" {
  count = local.create_role ? 1 : 0

  # IRSA
  dynamic "statement" {
    for_each = var.irsa_oidc_providers != null ? var.irsa_oidc_providers : {}

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = [statement.value.provider_arn]
      }

      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:sub"
        values   = ["system:serviceaccount:${try(coalesce(statement.value.namespace, local.namespace))}:${statement.value.service_account}"]
      }

      # https://aws.amazon.com/premiumsupport/knowledge-center/eks-troubleshoot-oidc-and-irsa/?nc1=h_ls
      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:aud"
        values   = ["sts.amazonaws.com"]
      }

      dynamic "condition" {
        for_each = var.trust_policy_conditions

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }

  # EKS Pod Identity
  dynamic "statement" {
    for_each = var.enable_pod_identity ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }

      dynamic "condition" {
        for_each = var.trust_policy_conditions

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.create_role ? 1 : 0

  name        = var.role_name_use_prefix ? null : local.role_name
  name_prefix = var.role_name_use_prefix ? "${local.role_name}-" : null
  path        = var.role_path
  description = var.role_description

  assume_role_policy    = data.aws_iam_policy_document.assume[0].json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.role_permissions_boundary_arn
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.role_policies : k => v if local.create_role }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

################################################################################
# IAM Policy
################################################################################

locals {
  create_policy = local.create_role && var.create_policy

  policy_name     = try(coalesce(var.policy_name, local.role_name), "")
  has_permissions = length(concat(var.source_policy_documents, var.override_policy_documents)) > 0 || var.policy_statements != null
}

data "aws_iam_policy_document" "this" {
  count = local.create_policy && local.has_permissions ? 1 : 0

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.policy_statements != null ? var.policy_statements : {}

    content {
      sid           = try(coalesce(statement.value.sid, statement.key))
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  count = local.create_policy && local.has_permissions ? 1 : 0

  name        = var.policy_name_use_prefix ? null : local.policy_name
  name_prefix = var.policy_name_use_prefix ? "${local.policy_name}-" : null
  path        = coalesce(var.policy_path, var.role_path)
  description = try(coalesce(var.policy_description, var.role_description), null)
  policy      = data.aws_iam_policy_document.this[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_policy && local.has_permissions ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

################################################################################
# Pod Identity Association
################################################################################

resource "aws_eks_pod_identity_association" "this" {
  for_each = { for k, v in var.pod_identity_associations : k => v if var.create && var.enable_pod_identity }

  region = try(coalesce(each.value.region, var.region), null)

  cluster_name         = try(coalesce(each.value.cluster_name, var.pod_identity_association_defaults.cluster_name))
  disable_session_tags = try(coalesce(each.value.disable_session_tags, var.pod_identity_association_defaults.disable_session_tags), null)
  namespace            = try(coalesce(each.value.namespace, var.pod_identity_association_defaults.namespace, local.namespace))
  role_arn             = aws_iam_role.this[0].arn
  service_account      = try(coalesce(each.value.service_account, var.pod_identity_association_defaults.service_account))
  target_role_arn      = try(coalesce(each.value.target_role_arn, var.pod_identity_association_defaults.target_role_arn), null)

  tags = merge(
    var.tags,
    each.value.tags,
    var.pod_identity_association_defaults.tags,
  )
}
