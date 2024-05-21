<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.26.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | 0.89.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core"></a> [core](#module\_core) | ./modules/core | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_integration"></a> [integration](#module\_integration) | ./modules/integration | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_API_INTEGRATION_API_KEY"></a> [API\_INTEGRATION\_API\_KEY](#input\_API\_INTEGRATION\_API\_KEY) | n/a | `string` | n/a | yes |
| <a name="input_SAML2_X509_CERT"></a> [SAML2\_X509\_CERT](#input\_SAML2\_X509\_CERT) | n/a | `string` | n/a | yes |
| <a name="input_api_integration_ad_app_id"></a> [api\_integration\_ad\_app\_id](#input\_api\_integration\_ad\_app\_id) | n/a | `string` | n/a | yes |
| <a name="input_api_management_url"></a> [api\_management\_url](#input\_api\_management\_url) | n/a | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | n/a | `string` | n/a | yes |
| <a name="input_core_enabled"></a> [core\_enabled](#input\_core\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_database_enabled"></a> [database\_enabled](#input\_database\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_event_hub_filename"></a> [event\_hub\_filename](#input\_event\_hub\_filename) | n/a | `string` | n/a | yes |
| <a name="input_integration_enabled"></a> [integration\_enabled](#input\_integration\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_storage_account_url"></a> [storage\_account\_url](#input\_storage\_account\_url) | n/a | `string` | n/a | yes |
| <a name="input_storage_queue_url"></a> [storage\_queue\_url](#input\_storage\_queue\_url) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for resources | `string` | `"DEV"` | no |
| <a name="input_environment_prefix"></a> [environment\_prefix](#input\_environment\_prefix) | Environment prefix for resources | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databases"></a> [databases](#output\_databases) | n/a |
| <a name="output_notification_integration"></a> [notification\_integration](#output\_notification\_integration) | n/a |
| <a name="output_resource_monitors"></a> [resource\_monitors](#output\_resource\_monitors) | n/a |
| <a name="output_roles"></a> [roles](#output\_roles) | n/a |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | n/a |
| <a name="output_storage_integration"></a> [storage\_integration](#output\_storage\_integration) | n/a |
| <a name="output_warehouses"></a> [warehouses](#output\_warehouses) | n/a |

<!-- END_TF_DOCS -->