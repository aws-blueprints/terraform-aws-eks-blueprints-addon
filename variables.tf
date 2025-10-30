variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Helm Release
################################################################################

variable "create_release" {
  description = "Determines whether the Helm release is created"
  type        = bool
  default     = true
}

variable "atomic" {
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to `false`"
  type        = bool
  default     = null
}

variable "chart" {
  description = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if `repository` is specified"
  type        = string
  default     = ""
}

variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to `false`"
  type        = bool
  default     = null
}

variable "create_namespace" {
  description = "Create the namespace if it does not yet exist. Defaults to `false`"
  type        = bool
  default     = null
}

variable "dependency_update" {
  description = "Runs helm dependency update before installing the chart. Defaults to `false`"
  type        = bool
  default     = null
}

variable "description" {
  description = "Set release description attribute (visible in the history)"
  type        = string
  default     = null
}

variable "devel" {
  description = "Use chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored"
  type        = bool
  default     = null
}

variable "disable_crd_hooks" {
  description = "Prevent CRD hooks from, running, but run other hooks. See `helm install --no-crd-hook`"
  type        = bool
  default     = null
}

variable "disable_openapi_validation" {
  description = "If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to `false`"
  type        = bool
  default     = null
}

variable "disable_webhooks" {
  description = "Prevent hooks from running. Defaults to `false`"
  type        = bool
  default     = null
}

variable "force_update" {
  description = "Force resource update through delete/recreate if needed. Defaults to `false`"
  type        = bool
  default     = null
}

variable "keyring" {
  description = "Location of public keys used for verification. Used only if verify is true. Defaults to `/.gnupg/pubring.gpg` in the location set by `home`"
  type        = string
  default     = null
}

variable "lint" {
  description = "Run the helm chart linter during the plan. Defaults to `false`"
  type        = bool
  default     = null
}

variable "max_history" {
  description = "Maximum number of release versions stored per release. Defaults to `0` (no limit)"
  type        = number
  default     = null
}

variable "name" {
  description = "Name of the Helm release"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to install the release into. Defaults to `default`"
  type        = string
  default     = null
}

variable "pass_credentials" {
  description = "Pass credentials to all domains. Defaults to `true`"
  type        = bool
  default     = true
}

variable "postrender" {
  description = "Configure a command to run after helm renders the manifest which can alter the manifest contents"
  type = object({
    args        = optional(list(string))
    binary_path = string
  })
  default = null
}

variable "recreate_pods" {
  description = "Perform pods restart during upgrade/rollback. Defaults to `false`"
  type        = bool
  default     = null
}

variable "render_subchart_notes" {
  description = "If set, render subchart notes along with the parent. Defaults to `true`"
  type        = bool
  default     = null
}

variable "replace" {
  description = "Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to `false`"
  type        = bool
  default     = null
}

variable "repository" {
  description = "Repository URL where to locate the requested chart"
  type        = string
  default     = null
}

variable "repository_ca_file" {
  description = "The Repositories CA File"
  type        = string
  default     = null
}

variable "repository_cert_file" {
  description = "The repositories cert file"
  type        = string
  default     = null
}

variable "repository_key_file" {
  description = "The repositories cert key file"
  type        = string
  default     = null
}

variable "repository_password" {
  description = "Password for HTTP basic authentication against the repository"
  type        = string
  default     = null
}

variable "repository_username" {
  description = "Username for HTTP basic authentication against the repository"
  type        = string
  default     = null
}

variable "reset_values" {
  description = "When upgrading, reset the values to the ones built into the chart. Defaults to `false`"
  type        = bool
  default     = null
}

variable "reuse_values" {
  description = "When upgrading, reuse the last release's values and merge in any overrides. If `reset_values` is specified, this is ignored. Defaults to `false`"
  type        = bool
  default     = null
}

variable "set" {
  description = "Value block with custom values to be merged with the values yaml"
  type = list(object({
    name                  = string
    type                  = optional(string)
    value_is_iam_role_arn = optional(bool, false)
    value                 = optional(string) # optional for case where `value_is_iam_role_arn = true`
  }))
  default = null
}

variable "set_list" {
  description = "Value block with custom list values to be merged with the values yaml"
  type = list(object({
    name  = string
    value = list(string)
  }))
  default = null
}

variable "set_sensitive" {
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff"
  type = list(object({
    name  = string
    type  = optional(string)
    value = string
  }))
  default = null
}

variable "set_wo" {
  description = "Custom values to be merged with the values. This is the same as `set` but write-only"
  type = list(object({
    name  = string
    type  = optional(string)
    value = string
  }))
  default = null
}

variable "set_wo_revision" {
  description = "The current revision of the write-only `set_wo` attribute. Incrementing this integer value will cause Terraform to update the write-only value"
  type        = number
  default     = null
}

variable "skip_crds" {
  description = "If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to `false`"
  type        = bool
  default     = null
}

variable "take_ownership" {
  description = "If set, allows Helm to adopt existing resources not marked as managed by the release. Defaults to `false`"
  type        = bool
  default     = null
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to `300` seconds"
  type        = number
  default     = null
}

variable "upgrade_install" {
  description = " If true, the provider will install the release at the specified version even if a release not controlled by the provider is present: this is equivalent to running 'helm upgrade --install' with the Helm CLI. Defaults to `true`"
  type        = bool
  default     = true
}

variable "values" {
  description = "List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple `-f` options"
  type        = list(string)
  default     = null
}

variable "verify" {
  description = "Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to `false`"
  type        = bool
  default     = null
}

variable "chart_version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed"
  type        = string
  default     = null
}

variable "wait" {
  description = "Will wait until all resources are in a ready state before marking the release as successful. If set to `true`, it will wait for as long as `timeout`. If set to `null` fallback on `300s` timeout.  Defaults to `false`"
  type        = bool
  default     = false
}

variable "wait_for_jobs" {
  description = "If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as `timeout`. Defaults to `false`"
  type        = bool
  default     = null
}

variable "release_timeouts" {
  description = "Customize the `helm_release` resource timeouts for create, read, update, and delete operations"
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

################################################################################
# IAM Role for Service Account(s) (IRSA)
################################################################################

variable "create_role" {
  description = "Determines whether to create an IAM role"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "role_name_use_prefix" {
  description = "Determines whether the IAM role name (`role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "role_policies" {
  description = "Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format"
  type        = map(string)
  default     = {}
}

variable "oidc_providers" {
  description = "Map of OIDC providers where each provider map should contain the `provider_arn`, and `service_accounts`"
  type = map(object({
    provider_arn    = string
    service_account = string
    namespace       = optional(string)
  }))
  default = null
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

################################################################################
# IAM Policy
################################################################################

variable "create_policy" {
  description = "Whether to create an IAM policy that is attached to the IAM role created"
  type        = bool
  default     = true
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string, "Allow")
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = null
}

variable "policy_name" {
  description = "Name of IAM policy"
  type        = string
  default     = null
}

variable "policy_name_use_prefix" {
  description = "Determines whether the IAM policy name (`policy_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "policy_path" {
  description = "Path of IAM policy"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "IAM policy description"
  type        = string
  default     = null
}
