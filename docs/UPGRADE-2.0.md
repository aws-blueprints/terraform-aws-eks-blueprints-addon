# Upgrade from v1.x to v2.x

Please consult the `tests` directory for reference configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported version of Terraform AWS provider updated to `v6.0` to support the latest resources and configurations
- Minimum supported version of Terraform Helm provider updated to `v3.1` to support the latest resources and configurations
- Minimum supported version of Terraform updated to `v1.11` due to new write only (`*_wo`) attributes used in the module (via `helm_release` resource)
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

-

### Modified

-

### Removed

-

### Variable and output changes

1. Removed variables:

    - `set_irsa_names`

2. Renamed variables:

    -

3. Added variables:

    - `value_is_iam_role_arn`
    - `disable_crd_hooks`
    - `set_wo`
    - `set_wo_revision`
    - `take_ownership`
    - `release_timeouts`
    - `upgrade_install`
    - `set_list`

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
