variable "environment" {
  description = "Environment for resources"
  type        = string
  default     = "DEV"
  validation {
    condition     = contains(["DEV", "PROD"], var.environment)
    error_message = "Environment should be either: DEV, or PROD."
  }
}

variable "environment_prefix" {
  description = "Environment prefix for resources"
  type        = string
  default     = ""
}

variable "azure_tenant_id" {
  type = string
}

variable "core_enabled" {
  type = bool
}

variable "database_enabled" {
  type = bool
}

variable "integration_enabled" {
  type = bool
}

variable "SAML2_X509_CERT" {
  type = string
}

variable "API_INTEGRATION_API_KEY" {
  type = string
}

variable "api_integration_ad_app_id" {
  type = string
}

variable "storage_account_url" {
  type = string
}

variable "storage_queue_url" {
  type = string
}

variable "event_hub_filename" {
  type = string
}

variable "api_management_url" {
  type = string
}
