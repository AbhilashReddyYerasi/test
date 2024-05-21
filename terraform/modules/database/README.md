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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database.db](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/database) | resource |
| [snowflake_database_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/database_grant) | resource |
| [snowflake_database_grant.grant_create_schema](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/database_grant) | resource |
| [snowflake_database_grant.grant_modify](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/database_grant) | resource |
| [snowflake_external_function.ext_func](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/external_function) | resource |
| [snowflake_file_format.file_format](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/file_format) | resource |
| [snowflake_file_format_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/file_format_grant) | resource |
| [snowflake_function.function](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/function) | resource |
| [snowflake_pipe.auto_gen_pipe](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/pipe) | resource |
| [snowflake_procedure.procedure](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/procedure) | resource |
| [snowflake_schema.schemas](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/schema) | resource |
| [snowflake_schema_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/schema_grant) | resource |
| [snowflake_schema_grant.stream_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/schema_grant) | resource |
| [snowflake_schema_grant.task_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/schema_grant) | resource |
| [snowflake_stage.stage](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/stage) | resource |
| [snowflake_stage_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/stage_grant) | resource |
| [snowflake_stream.stream](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/stream) | resource |
| [snowflake_table.tables](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/table) | resource |
| [snowflake_table_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/table_grant) | resource |
| [snowflake_task.custom_task](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task) | resource |
| [snowflake_task.proc_task](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task) | resource |
| [snowflake_task.task](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task) | resource |
| [snowflake_task_grant.custom_task_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task_grant) | resource |
| [snowflake_task_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task_grant) | resource |
| [snowflake_task_grant.proc_grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/task_grant) | resource |
| [snowflake_view.admin_views](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/view) | resource |
| [snowflake_view_grant.grant](https://registry.terraform.io/providers/snowflake-labs/snowflake/0.89.0/docs/resources/view_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databases"></a> [databases](#input\_databases) | n/a | <pre>list(object({<br>    name               = string<br>    transfer_ownership = optional(string)<br>    dev_only           = optional(bool, false)<br><br>    pipe_error_integration = optional(string)<br><br>    schemas = optional(list(object({<br>      name = string<br><br>      stages = optional(list(object({<br>        name                = string<br>        url                 = string<br>        storage_integration = string<br>        file_format         = optional(string)<br>        file_format_name    = optional(string)<br><br>        grants = optional(list(object({<br>          privilege = string<br>          roles     = list(string)<br>        })), [])<br>      })), [])<br><br>      tables = optional(list(object({<br>        names = list(string)<br><br>        columns = list(object({<br>          name = string<br>          type = string<br>        }))<br><br>        pipes = optional(object({<br>          file_names = list(string)<br><br>          auto_ingest = bool<br>          integration = string<br>          stage_name  = string<br>        }))<br><br>        streams          = optional(bool, false)<br>        tasks_on_streams = optional(bool, false)<br>        change_tracking  = optional(bool, false)<br><br>        grants = optional(list(object({<br>          privileges = list(string)<br>          roles      = list(string)<br>        })), [])<br>      })), [])<br><br>      admin_views = optional(list(object({<br>        name = string<br><br>        statement = string<br><br>        grants = optional(list(object({<br>          privilege = string<br>          roles     = list(string)<br>        })), [])<br>      })), [])<br><br>      functions = optional(list(object({<br>        name     = string<br>        language = string<br><br>        arguments = optional(list(object({<br>          name = string<br>          type = string<br>        })), [])<br><br>        comment = optional(string)<br><br>        return_type         = string<br>        return_behavior     = optional(string)<br>        null_input_behavior = optional(string)<br><br>        runtime_version = optional(string)<br>        handler         = optional(string)<br>        statement       = string<br>      })), [])<br><br>      external_functions = optional(list(object({<br>        name = string<br><br>        arguments = optional(list(object({<br>          name = string<br>          type = string<br>        })), [])<br><br>        comment = optional(string)<br><br>        return_type     = string<br>        return_behavior = optional(string)<br><br>        api_integration           = string<br>        url_of_proxy_and_resource = string<br>      })), [])<br><br>      procedures = optional(list(object({<br>        name     = string<br>        language = string<br><br>        arguments = optional(list(object({<br>          name = string<br>          type = string<br>        })), [])<br><br>        comment = optional(string)<br><br>        return_type         = string<br>        execute_as          = optional(string)<br>        return_behavior     = optional(string)<br>        null_input_behavior = optional(string)<br>        statement           = string<br>      })), [])<br><br>      file_formats = optional(list(object({<br>        name                           = string<br>        compression                    = optional(string)<br>        format_type                    = optional(string)<br>        record_delimiter               = optional(string)<br>        field_delimiter                = optional(string)<br>        timestamp_format               = optional(string)<br>        empty_field_as_null            = optional(bool)<br>        error_on_column_count_mismatch = optional(bool)<br>        binary_format                  = optional(string)<br>        escape                         = optional(string)<br>        escape_unenclosed_field        = optional(string)<br>        field_optionally_enclosed_by   = optional(string)<br>        encoding                       = optional(string)<br>        skip_header                    = optional(bool)<br><br>        grants = optional(list(object({<br>          privilege = string<br>          roles     = list(string)<br>        })), [])<br>      })), [])<br><br>      tasks = optional(list(object({<br>        name = string<br><br>        schedule      = optional(string)<br>        sql_statement = string<br><br>        user_task_managed_initial_warehouse_size = optional(string)<br>        warehouse                                = optional(string)<br><br>        when    = optional(string)<br>        enabled = optional(bool, false)<br>      })), [])<br><br>      grants = optional(list(object({<br>        privilege = string<br>        roles     = list(string)<br>      })))<br>    })), [])<br><br>    grants = optional(list(object({<br>      privilege = string<br>      roles     = list(string)<br>    })), [])<br>  }))</pre> | n/a | yes |
| <a name="input_developer_role"></a> [developer\_role](#input\_developer\_role) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_service_role_name"></a> [service\_role\_name](#input\_service\_role\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databases"></a> [databases](#output\_databases) | n/a |
| <a name="output_file_formats"></a> [file\_formats](#output\_file\_formats) | n/a |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | n/a |
| <a name="output_stage"></a> [stage](#output\_stage) | n/a |
| <a name="output_tables"></a> [tables](#output\_tables) | n/a |

<!-- END_TF_DOCS -->