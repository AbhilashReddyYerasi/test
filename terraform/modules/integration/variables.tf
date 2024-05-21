variable "storage_integrations" {
  type = list(object({
    name                      = string
    storage_provider          = string
    type                      = string
    azure_tenant_id           = string
    storage_allowed_locations = list(string)
    comment                   = optional(string)
  }))

  default = []
}

variable "notification_integrations" {
  type = list(object({
    name    = string
    comment = optional(string)

    enabled = bool
    type    = string

    azure_tenant_id                 = string
    azure_storage_queue_primary_uri = string
  }))

  default = []
}

variable "stages" {
  type = list(object({
    name                = string
    url                 = string
    database            = string
    schema              = string
    storage_integration = string
    file_format         = string
  }))

  default = []
}

variable "database_grants" {
  type = list(object({
    database_name = string
    privilege     = string
    roles         = list(string)
  }))

  default = []
}

variable "file_format_grants" {
  type = list(object({
    file_format_name = string
    database_name    = string
    schema_name      = string
    privilege        = string
    roles            = list(string)
  }))

  default = []
}

variable "stage_grants" {
  type = list(object({
    stage_name    = string
    database_name = string
    schema_name   = string
    privilege     = string
    roles         = list(string)
  }))

  default = []
}

variable "schema_grants" {
  type = list(object({
    schema_name   = string
    database_name = string
    privilege     = string
    roles         = list(string)
  }))

  default = []
}

variable "table_grants" {
  type = list(object({
    table_name    = string
    schema_name   = string
    database_name = string
    privilege     = string
    roles         = list(string)
  }))

  default = []
}

variable "tag_grants" {
  type = list(object({
    tag_name      = string
    database_name = string
    schema_name   = string
    privilege     = string
    roles         = list(string)
  }))

  default = []
}

variable "resource_monitor_grants" {
  type = list(object({
    monitor_name      = string
    privilege         = string
    roles             = list(string)
    with_grant_option = bool
  }))

  default = []
}

variable "saml_integration" {
  type = object({
    enabled                   = bool
    name                      = string
    saml2_provider            = string
    saml2_issuer              = string
    saml2_sso_url             = string
    saml2_x509_cert           = string
    saml2_enable_sp_initiated = bool
    saml2_force_authn         = bool
  })
}

variable "scim_integration" {
  type = object({
    enabled          = bool
    name             = string
    provisioner_role = string
    scim_client      = string
    network_policy   = string
  })
}

variable "tags" {
  type = list(object({
    name           = string
    database       = string
    schema         = string
    allowed_values = list(string)
  }))

  default = []
}

variable "resource_monitors" {
  type = list(object({
    name            = string
    credit_quota    = optional(number)
    set_for_account = optional(bool)

    frequency       = optional(string)
    start_timestamp = optional(string)
    end_timestamp   = optional(string)

    notify_triggers            = optional(list(number))
    suspend_triggers           = optional(list(number))
    suspend_immediate_triggers = optional(list(number))

    warehouses = optional(list(string))
  }))

  default = []
}

variable "api_integration" {
  type = object({
    name                    = string
    enabled                 = bool
    api_provider            = string
    api_key                 = string
    api_allowed_prefixes    = list(string)
    azure_tenant_id         = string
    azure_ad_application_id = string
  })

  default = null
}
