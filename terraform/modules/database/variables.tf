variable "service_role_name" {}

variable "environment" {}

variable "databases" {
  type = list(object({
    name               = string
    transfer_ownership = optional(string)
    dev_only           = optional(bool, false)

    pipe_error_integration = optional(string)

    schemas = optional(list(object({
      name = string

      stages = optional(list(object({
        name                = string
        url                 = string
        storage_integration = string
        file_format         = optional(string)
        file_format_name    = optional(string)

        grants = optional(list(object({
          privilege = string
          roles     = list(string)
        })), [])
      })), [])

      tables = optional(list(object({
        names = list(string)

        columns = list(object({
          name = string
          type = string
        }))

        pipes = optional(object({
          file_names = list(string)

          auto_ingest = bool
          integration = string
          stage_name  = string
        }))

        streams          = optional(bool, false)
        tasks_on_streams = optional(bool, false)
        change_tracking  = optional(bool, false)

        grants = optional(list(object({
          privileges = list(string)
          roles      = list(string)
        })), [])
      })), [])

      admin_views = optional(list(object({
        name = string

        statement = string

        grants = optional(list(object({
          privilege = string
          roles     = list(string)
        })), [])
      })), [])

      functions = optional(list(object({
        name     = string
        language = string

        arguments = optional(list(object({
          name = string
          type = string
        })), [])

        comment = optional(string)

        return_type         = string
        return_behavior     = optional(string)
        null_input_behavior = optional(string)

        runtime_version = optional(string)
        handler         = optional(string)
        statement       = string
      })), [])

      external_functions = optional(list(object({
        name = string

        arguments = optional(list(object({
          name = string
          type = string
        })), [])

        comment = optional(string)

        return_type     = string
        return_behavior = optional(string)

        api_integration           = string
        url_of_proxy_and_resource = string
      })), [])

      procedures = optional(list(object({
        name     = string
        language = string

        arguments = optional(list(object({
          name = string
          type = string
        })), [])

        comment = optional(string)

        return_type         = string
        execute_as          = optional(string)
        return_behavior     = optional(string)
        null_input_behavior = optional(string)
        statement           = string
      })), [])

      file_formats = optional(list(object({
        name                           = string
        compression                    = optional(string)
        format_type                    = optional(string)
        record_delimiter               = optional(string)
        field_delimiter                = optional(string)
        timestamp_format               = optional(string)
        empty_field_as_null            = optional(bool)
        error_on_column_count_mismatch = optional(bool)
        binary_format                  = optional(string)
        escape                         = optional(string)
        escape_unenclosed_field        = optional(string)
        field_optionally_enclosed_by   = optional(string)
        encoding                       = optional(string)
        skip_header                    = optional(bool)

        grants = optional(list(object({
          privilege = string
          roles     = list(string)
        })), [])
      })), [])

      tasks = optional(list(object({
        name = string

        schedule      = optional(string)
        sql_statement = string

        user_task_managed_initial_warehouse_size = optional(string)
        warehouse                                = optional(string)

        when    = optional(string)
        enabled = optional(bool, false)
      })), [])

      grants = optional(list(object({
        privilege = string
        roles     = list(string)
      })))
    })), [])

    grants = optional(list(object({
      privilege = string
      roles     = list(string)
    })), [])
  }))
}

variable "developer_role" {
  type = string
}
