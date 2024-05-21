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

resource "snowflake_storage_integration" "integration" {
  for_each = { for integration in var.storage_integrations : integration.name => integration }

  provider = snowflake.loader

  name                      = each.value.name
  storage_provider          = each.value.storage_provider
  type                      = each.value.type
  azure_tenant_id           = each.value.azure_tenant_id
  storage_allowed_locations = each.value.storage_allowed_locations
  comment                   = each.value.comment
}

resource "snowflake_notification_integration" "integration" {
  for_each = { for integration in var.notification_integrations : integration.name => integration }

  provider = snowflake.loader

  name    = each.value.name
  comment = each.value.comment

  enabled = each.value.enabled
  type    = each.value.type

  notification_provider           = "AZURE_STORAGE_QUEUE"
  azure_storage_queue_primary_uri = each.value.azure_storage_queue_primary_uri
  azure_tenant_id                 = each.value.azure_tenant_id
}


resource "snowflake_saml_integration" "saml_integration" {
  count = var.saml_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  name                      = var.saml_integration.name
  saml2_provider            = var.saml_integration.saml2_provider
  saml2_issuer              = var.saml_integration.saml2_issuer
  saml2_sso_url             = var.saml_integration.saml2_sso_url
  saml2_x509_cert           = sensitive(var.saml_integration.saml2_x509_cert)
  enabled                   = var.saml_integration.enabled
  saml2_enable_sp_initiated = var.saml_integration.saml2_enable_sp_initiated
  saml2_force_authn         = var.saml_integration.saml2_force_authn
}

resource "snowflake_role" "scim_role" {
  count = var.scim_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  name    = var.scim_integration.provisioner_role
  comment = "AAD SCIM Provisioner role."
}

resource "snowflake_account_grant" "create_user_grant" {
  count = var.scim_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  roles             = [snowflake_role.scim_role[0].name]
  privilege         = "CREATE USER"
  with_grant_option = false
}

resource "snowflake_account_grant" "create_role_grant" {
  count = var.scim_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  roles             = [snowflake_role.scim_role[0].name]
  privilege         = "CREATE ROLE"
  with_grant_option = false
}

resource "snowflake_role_grants" "add_grant" {
  count = var.scim_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  role_name = snowflake_role.scim_role[0].name
  roles     = ["ACCOUNTADMIN"]
}

resource "snowflake_scim_integration" "aad" {
  count = var.scim_integration.enabled ? 1 : 0

  provider = snowflake.account_admin

  depends_on = [
    snowflake_account_grant.create_user_grant[0],
    snowflake_account_grant.create_role_grant[0],
    snowflake_role_grants.add_grant[0]
  ]

  name             = var.scim_integration.name
  provisioner_role = snowflake_role.scim_role[0].name
  scim_client      = var.scim_integration.scim_client
  network_policy   = var.scim_integration.network_policy
}

resource "snowflake_tag" "tag" {
  for_each = { for tag in var.tags : tag.name => tag }

  provider = snowflake.loader

  name           = each.value.name
  database       = each.value.database
  schema         = each.value.schema
  allowed_values = each.value.allowed_values
}

resource "snowflake_tag_grant" "grant" {
  for_each = { for index, grant in var.tag_grants : index => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_tag.tag
  ]

  tag_name      = each.value.tag_name
  database_name = each.value.database_name
  schema_name   = each.value.schema_name
  privilege     = each.value.privilege
  roles         = each.value.roles
}

resource "time_offset" "monitor_default_offset" {
  offset_days = 1
}

resource "snowflake_resource_monitor" "monitor" {
  for_each = { for monitor in var.resource_monitors : monitor.name => monitor }

  provider = snowflake.account_admin

  name            = each.value.name
  credit_quota    = each.value.credit_quota
  set_for_account = each.value.set_for_account

  frequency = each.value.frequency
  start_timestamp = each.value.start_timestamp == null ? formatdate(
    "YYYY-MM-DD 00:00",
    time_offset.monitor_default_offset.rfc3339
  ) : each.value.start_timestamp
  end_timestamp = each.value.end_timestamp

  notify_triggers            = each.value.notify_triggers
  suspend_triggers           = each.value.suspend_triggers
  suspend_immediate_triggers = each.value.suspend_immediate_triggers

  warehouses = each.value.warehouses

  lifecycle {
    ignore_changes = [
      start_timestamp
    ]
  }
}

resource "snowflake_resource_monitor_grant" "grant" {
  for_each = { for index, grant in var.resource_monitor_grants : index => grant }

  provider = snowflake.loader

  depends_on = [
    snowflake_resource_monitor.monitor
  ]

  monitor_name      = each.value.monitor_name
  privilege         = each.value.privilege
  roles             = each.value.roles
  with_grant_option = each.value.with_grant_option
}

resource "snowflake_api_integration" "api_integration" {
  provider = snowflake.account_admin

  name                    = var.api_integration.name
  api_provider            = var.api_integration.api_provider
  azure_tenant_id         = var.api_integration.azure_tenant_id
  azure_ad_application_id = var.api_integration.azure_ad_application_id
  api_key                 = var.api_integration.api_key
  api_allowed_prefixes    = var.api_integration.api_allowed_prefixes
  enabled                 = var.api_integration.enabled
}

resource "snowflake_integration_grant" "grant" {
  provider = snowflake.account_admin

  integration_name = snowflake_api_integration.api_integration.name

  privilege = "USAGE"
  roles     = ["LOADER"]
  with_grant_option = false
}