locals {
  schemas = flatten([
    for db in var.databases : [
      for schema in db.schemas : {
        database = db.name

        db_dev_only = db.dev_only

        name = schema.name
      }
    ]
  ])

  stages = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for stage in schema.stages : {
          database = db.name

          schema = schema.name

          name                = stage.name
          url                 = stage.url
          storage_integration = stage.storage_integration
          file_format         = stage.file_format != null ? stage.file_format : stage.file_format_name != null ? "FORMAT_NAME = ${db.name}.${schema.name}.${stage.file_format_name}" : null
        }
      ]
    ]
  ])

  tables = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for table_name in tables.names : {
            database = db.name

            schema = schema.name

            name            = table_name
            columns         = tables.columns
            change_tracking = tables.change_tracking
          }
        ]
      ]
    ]
  ])

  admin_views = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for view in schema.admin_views : {
          database = db.name
          schema   = schema.name

          name      = view.name
          statement = view.statement
        }
      ]
    ]
  ])

  auto_pipes = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for index, table_name in tables.names : {
            name              = "${table_name}_PIPE"
            database          = db.name
            schema            = schema.name
            auto_ingest       = tables.pipes.auto_ingest
            integration       = tables.pipes.integration
            error_integration = db.pipe_error_integration
            copy_statement    = "COPY INTO ${db.name}.${schema.name}.${table_name} FROM @${db.name}.${schema.name}.${tables.pipes.stage_name} PATTERN = '${tables.pipes.file_names[index]}_.*'"
          } if tables.pipes.file_names[index] != null
        ] if tables.pipes != null
      ]
    ]
  ])

  functions = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for function in schema.functions : {
          name     = function.name
          database = db.name
          schema   = schema.name
          language = function.language

          arguments = function.arguments

          comment = function.comment

          return_type         = function.return_type
          return_behavior     = function.return_behavior
          null_input_behavior = function.null_input_behavior

          runtime_version = function.runtime_version
          handler         = function.handler
          statement       = function.statement
        }
      ]
    ]
  ])

  external_functions = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for function in schema.external_functions : {
          name     = function.name
          database = db.name
          schema   = schema.name

          arguments = function.arguments

          return_type     = function.return_type
          return_behavior = function.return_behavior

          api_integration           = function.api_integration
          url_of_proxy_and_resource = function.url_of_proxy_and_resource
        }
      ]
    ]
  ])

  procedures = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for procedure in schema.procedures : {
          name     = procedure.name
          database = db.name
          schema   = schema.name
          language = procedure.language

          arguments = procedure.arguments

          comment = procedure.comment

          return_type         = procedure.return_type
          execute_as          = procedure.execute_as
          return_behavior     = procedure.return_behavior
          null_input_behavior = procedure.null_input_behavior
          statement           = procedure.statement
        }
      ]
    ]
  ])

  streams = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for index, table_name in tables.names : {
            name     = "${table_name}_STREAM"
            database = db.name
            schema   = schema.name

            on_table    = table_name
            append_only = true
          } if tables.streams
        ]
      ]
    ]
  ])

  tasks = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for index, table_name in tables.names : {
            name     = "${table_name}_MERGE_TASK"
            database = db.name
            schema   = schema.name

            schedule      = "2 MINUTE"
            sql_statement = file("${path.module}/merge_commands/${lower(schema.name)}/${table_name}.sql")

            user_task_managed_initial_warehouse_size = "XSMALL"

            when    = "SYSTEM$STREAM_HAS_DATA('${table_name}_STREAM')"
            enabled = true
          } if tables.tasks_on_streams && fileexists("${path.module}/merge_commands/${lower(schema.name)}/${table_name}.sql")
        ]
      ]
    ]
  ])

  custom_tasks = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for task in schema.tasks : {
          name     = task.name
          database = db.name
          schema   = schema.name

          schedule      = task.schedule
          sql_statement = task.sql_statement

          user_task_managed_initial_warehouse_size = task.user_task_managed_initial_warehouse_size
          warehouse                                = task.warehouse

          when    = task.when
          enabled = task.enabled
        }
      ]
    ]
  ])

  proc_tasks = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for index, table_name in tables.names : {
            name     = "${table_name}_MERGE_PROC_TASK"
            database = db.name
            schema   = schema.name

            schedule      = "2 MINUTE"
            sql_statement = "call ${table_name}_MERGE_PROC()"

            user_task_managed_initial_warehouse_size = "XSMALL"

            when    = "SYSTEM$STREAM_HAS_DATA('${table_name}_STREAM')"
            enabled = true
          } if tables.tasks_on_streams && fileexists("${path.module}/procedures/${lower(schema.name)}/${table_name}.sql")
        ]
      ]
    ]
  ])

  file_formats = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for file_format in schema.file_formats : {
          database = db.name

          schema = schema.name

          name                           = file_format.name
          format_type                    = file_format.format_type
          compression                    = file_format.compression
          record_delimiter               = file_format.record_delimiter
          field_delimiter                = file_format.field_delimiter
          timestamp_format               = file_format.timestamp_format
          empty_field_as_null            = file_format.empty_field_as_null
          error_on_column_count_mismatch = file_format.error_on_column_count_mismatch
          binary_format                  = file_format.binary_format
          escape                         = file_format.escape
          escape_unenclosed_field        = file_format.escape_unenclosed_field
          field_optionally_enclosed_by   = file_format.field_optionally_enclosed_by
          encoding                       = file_format.encoding
          skip_header                    = file_format.skip_header == null ? 0 : file_format.skip_header ? 1 : 0
        }
      ]
    ]
  ])

  database_grants = flatten([
    for db in var.databases : [
      for grant in db.grants : {
        database_name = db.name

        privilege = grant.privilege
        roles     = concat(grant.roles, var.developer_role != null && grant.privilege == "USAGE" ? [var.developer_role] : [])
      }
    ]
  ])

  schema_grants = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for grant in schema.grants : {
          database_name = db.name
          schema_name   = schema.name

          privilege = grant.privilege
          roles     = concat(grant.roles, var.developer_role != null && grant.privilege == "USAGE" ? [var.developer_role] : [])
        }
      ]
    ]
  ])

  stage_grants = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for stage in schema.stages : [
          for grant in stage.grants : {
            database_name = db.name
            schema_name   = schema.name
            stage_name    = stage.name

            privilege = grant.privilege
            roles     = grant.roles
          }
        ]
      ]
    ]
  ])

  file_format_grants = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for file_format in schema.file_formats : [
          for grant in file_format.grants : {
            database_name    = db.name
            schema_name      = schema.name
            file_format_name = file_format.name

            privilege = grant.privilege
            roles     = grant.roles
          }
        ]
      ]
    ]
  ])

  table_grants = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for tables in schema.tables : [
          for grant in tables.grants : [
            for privilege in grant.privileges : [
              for table_name in tables.names : {
                database_name = db.name
                schema_name   = schema.name
                table_name    = table_name

                privilege = privilege
                roles     = concat(grant.roles, var.developer_role != null && privilege == "SELECT" ? [var.developer_role] : [])
              }
            ]
          ]
        ]
      ]
    ]
  ])

  admin_view_grants = flatten([
    for db in var.databases : [
      for schema in db.schemas : [
        for view in schema.admin_views : [
          for grant in view.grants : {

            database_name = db.name
            schema_name   = schema.name
            view_name     = view.name

            privilege = grant.privilege
            roles     = grant.roles
          }
        ]
      ]
    ]
  ])
}
