<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | 0.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake.account_admin"></a> [snowflake.account\_admin](#provider\_snowflake.account\_admin) | 0.89.0 |
| <a name="provider_snowflake.loader"></a> [snowflake.loader](#provider\_snowflake.loader) | 0.89.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_account_grant.create_role_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_account_grant.create_user_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/account_grant) | resource |
| [snowflake_api_integration.api_integration](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/api_integration) | resource |
| [snowflake_integration_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/integration_grant) | resource |
| [snowflake_notification_integration.integration](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/notification_integration) | resource |
| [snowflake_resource_monitor.monitor](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/resource_monitor) | resource |
| [snowflake_resource_monitor_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/resource_monitor_grant) | resource |
| [snowflake_role.scim_role](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role) | resource |
| [snowflake_role_grants.add_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/role_grants) | resource |
| [snowflake_saml_integration.saml_integration](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/saml_integration) | resource |
| [snowflake_scim_integration.aad](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/scim_integration) | resource |
| [snowflake_storage_integration.integration](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/storage_integration) | resource |
| [snowflake_tag.tag](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/tag) | resource |
| [snowflake_tag_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/tag_grant) | resource |
| [time_offset.monitor_default_offset](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_saml_integration"></a> [saml\_integration](#input\_saml\_integration) | n/a | <pre>object({<br>    enabled                   = bool<br>    name                      = string<br>    saml2_provider            = string<br>    saml2_issuer              = string<br>    saml2_sso_url             = string<br>    saml2_x509_cert           = string<br>    saml2_enable_sp_initiated = bool<br>    saml2_force_authn         = bool<br>  })</pre> | n/a | yes |
| <a name="input_scim_integration"></a> [scim\_integration](#input\_scim\_integration) | n/a | <pre>object({<br>    enabled          = bool<br>    name             = string<br>    provisioner_role = string<br>    scim_client      = string<br>    network_policy   = string<br>  })</pre> | n/a | yes |
| <a name="input_api_integration"></a> [api\_integration](#input\_api\_integration) | n/a | <pre>object({<br>    name                    = string<br>    enabled                 = bool<br>    api_provider            = string<br>    api_key                 = string<br>    api_allowed_prefixes    = list(string)<br>    azure_tenant_id         = string<br>    azure_ad_application_id = string<br>  })</pre> | `null` | no |
| <a name="input_database_grants"></a> [database\_grants](#input\_database\_grants) | n/a | <pre>list(object({<br>    database_name = string<br>    privilege     = string<br>    roles         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_file_format_grants"></a> [file\_format\_grants](#input\_file\_format\_grants) | n/a | <pre>list(object({<br>    file_format_name = string<br>    database_name    = string<br>    schema_name      = string<br>    privilege        = string<br>    roles            = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_notification_integrations"></a> [notification\_integrations](#input\_notification\_integrations) | n/a | <pre>list(object({<br>    name    = string<br>    comment = optional(string)<br><br>    enabled = bool<br>    type    = string<br><br>    azure_tenant_id                 = string<br>    azure_storage_queue_primary_uri = string<br>  }))</pre> | `[]` | no |
| <a name="input_resource_monitor_grants"></a> [resource\_monitor\_grants](#input\_resource\_monitor\_grants) | n/a | <pre>list(object({<br>    monitor_name      = string<br>    privilege         = string<br>    roles             = list(string)<br>    with_grant_option = bool<br>  }))</pre> | `[]` | no |
| <a name="input_resource_monitors"></a> [resource\_monitors](#input\_resource\_monitors) | n/a | <pre>list(object({<br>    name            = string<br>    credit_quota    = optional(number)<br>    set_for_account = optional(bool)<br><br>    frequency       = optional(string)<br>    start_timestamp = optional(string)<br>    end_timestamp   = optional(string)<br><br>    notify_triggers            = optional(list(number))<br>    suspend_triggers           = optional(list(number))<br>    suspend_immediate_triggers = optional(list(number))<br><br>    warehouses = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_schema_grants"></a> [schema\_grants](#input\_schema\_grants) | n/a | <pre>list(object({<br>    schema_name   = string<br>    database_name = string<br>    privilege     = string<br>    roles         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_stage_grants"></a> [stage\_grants](#input\_stage\_grants) | n/a | <pre>list(object({<br>    stage_name    = string<br>    database_name = string<br>    schema_name   = string<br>    privilege     = string<br>    roles         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_stages"></a> [stages](#input\_stages) | n/a | <pre>list(object({<br>    name                = string<br>    url                 = string<br>    database            = string<br>    schema              = string<br>    storage_integration = string<br>    file_format         = string<br>  }))</pre> | `[]` | no |
| <a name="input_storage_integrations"></a> [storage\_integrations](#input\_storage\_integrations) | n/a | <pre>list(object({<br>    name                      = string<br>    storage_provider          = string<br>    type                      = string<br>    azure_tenant_id           = string<br>    storage_allowed_locations = list(string)<br>    comment                   = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_table_grants"></a> [table\_grants](#input\_table\_grants) | n/a | <pre>list(object({<br>    table_name    = string<br>    schema_name   = string<br>    database_name = string<br>    privilege     = string<br>    roles         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tag_grants"></a> [tag\_grants](#input\_tag\_grants) | n/a | <pre>list(object({<br>    tag_name      = string<br>    database_name = string<br>    schema_name   = string<br>    privilege     = string<br>    roles         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | <pre>list(object({<br>    name           = string<br>    database       = string<br>    schema         = string<br>    allowed_values = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_integration"></a> [api\_integration](#output\_api\_integration) | n/a |
| <a name="output_notification_integration"></a> [notification\_integration](#output\_notification\_integration) | n/a |
| <a name="output_resource_monitors"></a> [resource\_monitors](#output\_resource\_monitors) | n/a |
| <a name="output_storage_integration"></a> [storage\_integration](#output\_storage\_integration) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |

<!-- END_TF_DOCS -->