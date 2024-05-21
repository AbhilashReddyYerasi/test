variable "environment" {}

variable "roles" {
  type = list(object({
    name    = string
    comment = string
  }))

  default = []
}

variable "warehouses" {
  type = list(object({
    name                                = string
    comment                             = string
    warehouse_size                      = string
    auto_resume                         = bool
    auto_suspend                        = number
    enable_query_acceleration           = optional(bool, false)
    query_acceleration_max_scale_factor = optional(number, 0)
    roles                               = set(string)
  }))

  default = []
}

variable "users" {
  type = list(object({
    name         = string
    login_name   = string
    comment      = optional(string)
    disabled     = optional(bool, false)
    display_name = string
    email        = optional(string)
    first_name   = optional(string)
    last_name    = optional(string)

    default_warehouse       = string
    default_secondary_roles = optional(list(string))
    default_role            = string

    must_change_password = optional(bool, false)
  }))

  default = []
}

variable "warehouse_grants" {
  type = list(object({
    warehouse_name = string
    privilege      = string
    roles          = list(string)
  }))

  default = []
}

variable "owner_role_grants" {
  description = "A list of role ownership grants."
  type        = list(object({
    on_role_name   = string
    to_role_name   = string
    current_grants = string
  }))
  default     = []
}