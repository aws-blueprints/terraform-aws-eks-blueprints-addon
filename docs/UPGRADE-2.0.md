# Upgrade from v1.x to v2.x

Please consult the `tests` directory for reference configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported version of Terraform AWS provider updated to `v6.0` to support the latest resources and configurations
- Minimum supported version of Terraform Helm provider updated to `v3.1` to support the latest resources and configurations
- Minimum supported version of Terraform updated to `v1.11` due to new write only (`*_wo`) attributes used in the module (via `helm_release` resource)
- The `create_role` variable has been removed and the module now always creates an IAM role. It doesn't make a lot of sense for an addon module to not create the role since all that is left is simply the `helm_release` resource. In that scenario, users are encouraged to use the `helm_release` resource directly.
- The `allow_self_assume_role` variable and associated trust policy statement has been removed; the addon should not need to assume its own role.
- The `set_irsa_names` variable has been removed. To set the IRSA annotation for the service account, use the `set` variable to provide the annotation `name` and then set `value_is_iam_role_arn = true` to refer to the IAM role created by the module. For example:

  ```hcl
  set = [
    {
      name                  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value_is_iam_role_arn = true
    }
  ]
  ```

## Additional changes

### Added

- Added support for utilizing EKS Pod Identity with or without IRSA

### Modified

- Variable definitions now contain detailed object types in place of the previously used `any` type.

### Removed

-

### Variable and output changes

1. Removed variables:

    - `set_irsa_names`
    - `allow_self_assume_role`
    - `create_role`

2. Renamed variables:

    - `oidc_providers` -> `irsa_oidc_providers` to be more explicit about its purpose

3. Added variables:

    - `value_is_iam_role_arn` - for referencing the module created IAM role for IRSA annotation
    - `disable_crd_hooks` - new Helm release argument
    - `set_wo` - new Helm release argument
    - `set_wo_revision` - new Helm release argument
    - `take_ownership` - new Helm release argument
    - `release_timeouts` - new Helm release argument
    - `upgrade_install` - new Helm release argument
    - `set_list` - new Helm release argument
    - `pass_credentials` - new Helm release argument
    - `trust_policy_conditions` - allow for additional conditions in the IAM role trust policy
    - `enable_pod_identity` - to enable or disable the  use of EKS Pod Identity
    - `pod_identity_associations` - map of EKS Pod Identity association configurations
    - `pod_identity_association_defaults` - default values for EKS Pod Identity associations

4. Removed outputs:

    -

5. Renamed outputs:

    -

6. Added outputs:

    -

## Upgrade Migrations

### Diff of Before vs After

```diff
 module "eks_blueprints_addon" {
  source  = "aws-blueprints/eks-blueprints-addon/aws"
-  version = "1.2"
+  version = "2.0"

  # Truncated for brevity, only the changed parts are shown

-  set_irsa_names = ["serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"]
+  set = [
+    {
+      name                  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
+      value_is_iam_role_arn = true
+    }
+  ]
}
```

### State Move Commands

TBD
