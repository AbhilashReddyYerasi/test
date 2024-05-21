<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | 0.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_snowflake.account_admin"></a> [snowflake.account\_admin](#provider\_snowflake.account\_admin) | 0.89.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.user_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [snowflake_account_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_account_grant.grant_execute_managed_task](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_account_grant.grant_execute_task](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_account_grant.grant_integration](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_role.roles](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role) | resource |
| [snowflake_role_grants.ci_dev_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.ci_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.mx_ci_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.role_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.scheduler_loader_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.transformer_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_role_ownership_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_ownership_grant) | resource |
| [snowflake_user.users](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/user) | resource |
| [snowflake_warehouse.warehouses](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/warehouse) | resource |
| [snowflake_warehouse_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/warehouse_grant) | resource |
| [snowflake_warehouse_grant.grant_wh_usage](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/warehouse_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_owner_role_grants"></a> [owner\_role\_grants](#input\_owner\_role\_grants) | A list of role ownership grants. | <pre>list(object({<br>    on_role_name   = string<br>    to_role_name   = string<br>    current_grants = string<br>  }))</pre> | `[]` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | n/a | <pre>list(object({<br>    name    = string<br>    comment = string<br>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | n/a | <pre>list(object({<br>    name         = string<br>    login_name   = string<br>    comment      = optional(string)<br>    disabled     = optional(bool, false)<br>    display_name = string<br>    email        = optional(string)<br>    first_name   = optional(string)<br>    last_name    = optional(string)<br><br>    default_warehouse       = string<br>    default_secondary_roles = optional(list(string))<br>    default_role            = string<br><br>    must_change_password = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_warehouse_grants"></a> [warehouse\_grants](#input\_warehouse\_grants) | n/a | <pre>list(object({<br>    warehouse_name = string<br>    privilege      = string<br>    roles          = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_warehouses"></a> [warehouses](#input\_warehouses) | n/a | <pre>list(object({<br>    name                                = string<br>    comment                             = string<br>    warehouse_size                      = string<br>    auto_resume                         = bool<br>    auto_suspend                        = number<br>    enable_query_acceleration           = optional(bool, false)<br>    query_acceleration_max_scale_factor = optional(number, 0)<br>    roles                               = set(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_roles"></a> [roles](#output\_roles) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |
| <a name="output_warehouses"></a> [warehouses](#output\_warehouses) | n/a |

<!-- END_TF_DOCS -->