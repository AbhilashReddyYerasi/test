terraform {
  required_version = ">= 1.3"

  required_providers {
    snowflake = {
      source                = "snowflake-labs/snowflake"
      version               = "0.89.0"
      configuration_aliases = [snowflake.loader, snowflake.account_admin]
    }
  }
}

resource "snowflake_database" "db" {
  for_each = { for database in var.databases : database.name => database if var.environment != "PROD" || (var.environment == "PROD" && !database.dev_only) }

  provider = snowflake.loader

  name = each.value.name
  data_retention_time_in_days = 1
}

resource "snowflake_schema" "schemas" {
  for_each = { for schema in local.schemas : "${schema.database}.${schema.name}" => schema }

  provider = snowflake.loader

  depends_on = [
    snowflake_database.db
  ]

  name     = each.value.name
  database = each.value.database
  data_retention_days = 1
}

resource "snowflake_stage" "stage" {
  for_each = { for stage in local.stages : "${stage.database}.${stage.schema}.${stage.name}" => stage }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas,
    snowflake_file_format.file_format
  ]

  name                = each.value.name
  url                 = each.value.url
  database            = each.value.database
  schema              = each.value.schema
  storage_integration = each.value.storage_integration
  file_format         = each.value.file_format
}

resource "snowflake_file_format" "file_format" {
  for_each = { for format in local.file_formats : "${format.database}.${format.schema}.${format.name}" => format }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas
  ]

  name                           = each.value.name
  database                       = each.value.database
  schema                         = each.value.schema
  format_type                    = each.value.format_type
  compression                    = each.value.compression
  record_delimiter               = each.value.record_delimiter
  field_delimiter                = each.value.field_delimiter
  timestamp_format               = each.value.timestamp_format
  empty_field_as_null            = each.value.empty_field_as_null
  error_on_column_count_mismatch = each.value.error_on_column_count_mismatch
  binary_format                  = each.value.binary_format
  escape                         = each.value.escape
  escape_unenclosed_field        = each.value.escape_unenclosed_field
  field_optionally_enclosed_by   = each.value.field_optionally_enclosed_by
  encoding                       = each.value.encoding
  skip_header                    = each.value.skip_header
}

resource "snowflake_table" "tables" {
  for_each = { for table in local.tables : "${table.database}.${table.schema}.${table.name}" => table }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas
  ]

  name     = each.value.name
  database = each.value.database
  schema   = each.value.schema
  data_retention_time_in_days = 1

  cluster_by      = []
  change_tracking = each.value.change_tracking

  dynamic "column" {
    for_each = each.value.columns

    content {
      name = column.value.name
      type = column.value.type
    }
  }
}

resource "snowflake_view" "admin_views" {
  for_each = { for view in local.admin_views : "${view.database}.${view.schema}.${view.name}" => view }

  provider = snowflake.account_admin

  name     = each.value.name
  database = each.value.database
  schema   = each.value.schema

  statement = each.value.statement
}

resource "snowflake_pipe" "auto_gen_pipe" {
  for_each = { for pipe in local.auto_pipes : "${pipe.database}.${pipe.schema}.${pipe.name}" => pipe }

  provider = snowflake.loader

  depends_on = [
    snowflake_table.tables,
    snowflake_stage.stage
  ]

  database = each.value.database
  schema   = each.value.schema

  name              = each.value.name
  copy_statement    = each.value.copy_statement
  auto_ingest       = each.value.auto_ingest
  integration       = each.value.integration
  error_integration = each.value.error_integration
}

resource "snowflake_database_grant" "grant" {
  for_each = { for index, grant in local.database_grants : "${grant.database_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_database.db
  ]

  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles

## Added to ignore the shares changes in the TF-Output Plan as it seems to be doing nothing but showing as delete as it was created outside of terraform.
  lifecycle {
    ignore_changes = [
      shares,
    ]
  }
}

resource "snowflake_schema_grant" "grant" {
  for_each = { for index, grant in local.schema_grants : "${grant.database_name}.${grant.schema_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas
  ]

  schema_name   = each.value.schema_name
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles

## Added to ignore the shares changes in the TF-Output Plan as it seems to be doing nothing but showing as delete as it was created outside of terraform.
  lifecycle {
    ignore_changes = [
      shares,
    ]
  }
}

resource "snowflake_stage_grant" "grant" {
  for_each = { for index, grant in local.stage_grants : "${grant.database_name}.${grant.schema_name}.${grant.stage_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_stage.stage
  ]

  database_name = each.value.database_name
  schema_name   = each.value.schema_name
  stage_name    = each.value.stage_name
  privilege     = each.value.privilege
  roles         = each.value.roles
}

resource "snowflake_file_format_grant" "grant" {
  for_each = { for index, grant in local.file_format_grants : "${grant.database_name}.${grant.schema_name}.${grant.file_format_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_file_format.file_format
  ]

  file_format_name = each.value.file_format_name
  database_name    = each.value.database_name
  schema_name      = each.value.schema_name
  roles            = each.value.roles
  privilege        = each.value.privilege
}
resource "snowflake_table_grant" "grant" {
  for_each = { for index, grant in local.table_grants : "${grant.database_name}.${grant.schema_name}.${grant.table_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_table.tables
  ]

  table_name    = each.value.table_name
  schema_name   = each.value.schema_name
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles

## Added to ignore the shares changes in the TF-Output Plan as it seems to be doing nothing but showing as delete as it was created outside of terraform.
  lifecycle {
    ignore_changes = [
      shares,
    ]
  }
}

resource "snowflake_schema_grant" "stream_grant" {
  for_each = { for index, grant in local.schemas : "${grant.database}.${grant.name}.CREATE STREAM.${var.service_role_name}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas
  ]

  schema_name   = each.value.name
  database_name = each.value.database
  privilege     = "CREATE STREAM"
  roles         = [var.service_role_name]
}

resource "snowflake_function" "function" {
  for_each = { for function in local.functions : "${function.database}.${function.schema}.${function.name}" => function }

  provider = snowflake.loader

  name     = each.value.name
  database = each.value.database
  schema   = each.value.schema
  language = each.value.language
  dynamic "arguments" {
    for_each = each.value.arguments

    content {
      name = arguments.value.name
      type = arguments.value.type
    }
  }

  comment = each.value.comment

  return_type         = each.value.return_type
  return_behavior     = each.value.return_behavior
  null_input_behavior = each.value.null_input_behavior

  runtime_version = each.value.runtime_version
  handler         = each.value.handler
  statement       = each.value.statement
}

resource "snowflake_external_function" "ext_func" {
  for_each = { for function in local.external_functions : "${function.database}.${function.schema}.${function.name}" => function }

  provider = snowflake.loader

  name     = each.value.name
  database = each.value.database
  schema   = each.value.schema
  dynamic "arg" {
    for_each = each.value.arguments

    content {
      name = arg.value.name
      type = arg.value.type
    }
  }
  return_type     = each.value.return_type
  return_behavior = each.value.return_behavior

  api_integration           = each.value.api_integration
  url_of_proxy_and_resource = each.value.url_of_proxy_and_resource
}

resource "snowflake_procedure" "procedure" {
  for_each = { for procedure in local.procedures : "${procedure.database}.${procedure.schema}.${procedure.name}" => procedure }

  provider = snowflake.loader

  name     = each.value.name
  database = each.value.database
  schema   = each.value.schema
  language = each.value.language

  dynamic "arguments" {
    for_each = each.value.arguments

    content {
      name = arguments.value.name
      type = arguments.value.type
    }
  }

  comment             = each.value.comment
  return_type         = each.value.return_type
  execute_as          = each.value.execute_as
  return_behavior     = each.value.return_behavior
  null_input_behavior = each.value.null_input_behavior
  statement           = each.value.statement
}

resource "snowflake_stream" "stream" {
  for_each = { for stream in local.streams : "${stream.database}.${stream.schema}.${stream.name}" => stream }

  provider = snowflake.loader

  depends_on = [
    snowflake_table.tables,
    snowflake_schema_grant.stream_grant
  ]

  database = each.value.database
  schema   = each.value.schema
  name     = each.value.name

  on_table    = "${each.value.database}.${each.value.schema}.${each.value.on_table}"
  append_only = each.value.append_only
}

resource "snowflake_schema_grant" "task_grant" {
  for_each = { for index, grant in local.schemas : "${grant.database}.${grant.name}.CREATE TASK.${var.service_role_name}" => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema.schemas
  ]

  schema_name   = each.value.name
  database_name = each.value.database
  privilege     = "CREATE TASK"
  roles         = [var.service_role_name]
}

resource "snowflake_task" "task" {
  for_each = { for task in local.tasks : "${task.database}.${task.schema}.${task.name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_stream.stream,
    snowflake_schema_grant.task_grant
  ]

  database = each.value.database
  schema   = each.value.schema
  name     = each.value.name

  schedule      = each.value.schedule
  sql_statement = each.value.sql_statement

  user_task_managed_initial_warehouse_size = each.value.user_task_managed_initial_warehouse_size

  when    = each.value.when
  enabled = each.value.enabled

  suspend_task_after_num_failures = 10
}

resource "snowflake_task_grant" "grant" {
  for_each = { for task in local.tasks : "${task.database}.${task.schema}.${task.name}.OPERATE.${var.service_role_name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_task.task
  ]

  database_name = each.value.database
  schema_name   = each.value.schema
  task_name     = each.value.name

  privilege = "OPERATE"
  roles = [
    var.service_role_name
  ]
}

resource "snowflake_task" "proc_task" {
  for_each = { for task in local.proc_tasks : "${task.database}.${task.schema}.${task.name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_stream.stream,
    snowflake_schema_grant.task_grant
  ]

  database = each.value.database
  schema   = each.value.schema
  name     = each.value.name

  schedule      = each.value.schedule
  sql_statement = each.value.sql_statement

  user_task_managed_initial_warehouse_size = each.value.user_task_managed_initial_warehouse_size

  when    = each.value.when
  enabled = each.value.enabled
}

resource "snowflake_task_grant" "proc_grant" {
  for_each = { for task in local.proc_tasks : "${task.database}.${task.schema}.${task.name}.OPERATE.${var.service_role_name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_task.proc_task
  ]

  database_name = each.value.database
  schema_name   = each.value.schema
  task_name     = each.value.name

  privilege = "OPERATE"
  roles = [
    var.service_role_name
  ]
}

resource "snowflake_task" "custom_task" {
  for_each = { for task in local.custom_tasks : "${task.database}.${task.schema}.${task.name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_schema_grant.task_grant
  ]

  database = each.value.database
  schema   = each.value.schema
  name     = each.value.name

  schedule      = each.value.schedule
  sql_statement = each.value.sql_statement

  user_task_managed_initial_warehouse_size = each.value.user_task_managed_initial_warehouse_size
  warehouse                                = each.value.warehouse

  when    = each.value.when
  enabled = each.value.enabled
  suspend_task_after_num_failures          = 10
}

resource "snowflake_task_grant" "custom_task_grant" {
  for_each = { for task in local.custom_tasks : "${task.database}.${task.schema}.${task.name}.OPERATE.${var.service_role_name}" => task }

  provider = snowflake.loader

  depends_on = [
    snowflake_task.custom_task
  ]

  database_name = each.value.database
  schema_name   = each.value.schema
  task_name     = each.value.name

  privilege = "OPERATE"
  roles = [
    var.service_role_name
  ]
}

resource "snowflake_database_grant" "grant_create_schema" {
  for_each = { for index, database in var.databases : "${database.name}.CREATE SCHEMA.${index}" => database if database.transfer_ownership != null && (var.environment != "PROD" || (var.environment == "PROD" && !database.dev_only)) }

  provider = snowflake.loader

  depends_on = [
    snowflake_database.db
  ]

  database_name = each.value.name

  privilege = "CREATE SCHEMA"
  roles     = flatten([each.value.transfer_ownership, var.developer_role != null && each.value.dev_only ? [var.developer_role] : []])
}

resource "snowflake_database_grant" "grant_modify" {
  for_each = { for index, database in var.databases : "${database.name}.MODIFY.${index}" => database if database.transfer_ownership != null && (var.environment != "PROD" || (var.environment == "PROD" && !database.dev_only)) }

  provider = snowflake.loader

  depends_on = [
    snowflake_database.db
  ]

  database_name = each.value.name

  privilege = "MODIFY"
  roles     = flatten([each.value.transfer_ownership, var.developer_role != null && each.value.dev_only ? [var.developer_role] : []])
}

resource "snowflake_view_grant" "grant" {
  for_each = { for index, grant in local.admin_view_grants : "${grant.database_name}.${grant.schema_name}.${grant.view_name}.${grant.privilege}.${join(",", grant.roles)}" => grant }

  provider = snowflake.account_admin

  depends_on = [
    snowflake_view.admin_views
  ]

  view_name     = each.value.view_name
  schema_name   = each.value.schema_name
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles
}
