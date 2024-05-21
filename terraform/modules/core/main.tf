terraform {
  required_version = ">= 1.3"

  required_providers {
    snowflake = {
      source                = "snowflake-labs/snowflake"
      version               = "0.89.0"
      configuration_aliases = [snowflake.account_admin]
    }
  }
}

resource "snowflake_role" "roles" {
  for_each = { for role in var.roles : role.name => role }

  provider = snowflake.account_admin

  name    = each.value.name
  comment = each.value.comment
}

resource "snowflake_warehouse" "warehouses" {
  for_each = { for warehouse in var.warehouses : warehouse.name => warehouse }

  provider = snowflake.account_admin

  name                                = each.value.name
  comment                             = each.value.comment
  warehouse_size                      = each.value.warehouse_size
  auto_resume                         = each.value.auto_resume
  auto_suspend                        = each.value.auto_suspend
  enable_query_acceleration           = each.value.enable_query_acceleration
  query_acceleration_max_scale_factor = each.value.query_acceleration_max_scale_factor
}

resource "snowflake_user" "users" {
  for_each = { for user in var.users : user.name => user }

  provider = snowflake.account_admin

  name         = each.value.name
  login_name   = each.value.login_name
  comment      = each.value.comment
  password     = random_password.user_passwords[each.key].result
  disabled     = each.value.disabled
  display_name = each.value.display_name
  email        = each.value.email
  first_name   = each.value.first_name
  last_name    = each.value.last_name

  default_warehouse       = each.value.default_warehouse
  default_secondary_roles = each.value.default_secondary_roles
  default_role            = each.value.default_role

  must_change_password = each.value.must_change_password
}

resource "random_password" "user_passwords" {
  for_each = { for user in var.users : user.name => user }

  length  = 16
  special = false
}

resource "snowflake_role_grants" "role_grant" {
  for_each = { for user in var.users : user.name => user if user.default_role != null }

  provider = snowflake.account_admin

  depends_on = [
    snowflake_user.users
  ]

  role_name = each.value.default_role
  users = [
    each.value.name
  ]
}

resource "snowflake_role_grants" "mx_ci_grant" {
  provider = snowflake.account_admin

  role_name = snowflake_role.roles["MX_TRANSFORMER"].name
  users     = ["MX_CI"]
}

resource "snowflake_role_grants" "ci_grant" {
  provider = snowflake.account_admin

  role_name = snowflake_role.roles["LOADER"].name
  users     = ["CI_SERVICE_USER"]
}

resource "snowflake_role_grants" "ci_dev_grant" {
  count    = var.environment != "PROD" && lookup(snowflake_role.roles, "DEVELOPER", null) != null ? 1 : 0
  provider = snowflake.account_admin

  role_name = snowflake_role.roles["DEVELOPER"].name
  users     = ["CI_SERVICE_USER"]
}

resource "snowflake_account_grant" "grant" {
  provider = snowflake.account_admin

  roles             = [snowflake_role.roles["LOADER"].name, snowflake_role.roles["TRANSFORMER"].name]
  privilege         = "CREATE DATABASE"
  with_grant_option = false
}

resource "snowflake_account_grant" "grant_integration" {
  provider = snowflake.account_admin

  roles             = [snowflake_role.roles["LOADER"].name]
  privilege         = "CREATE INTEGRATION"
  with_grant_option = false
}

resource "snowflake_account_grant" "grant_execute_managed_task" {
  provider = snowflake.account_admin

  roles             = [snowflake_role.roles["LOADER"].name]
  privilege         = "EXECUTE MANAGED TASK"
  with_grant_option = false
}

resource "snowflake_account_grant" "grant_execute_task" {
  provider = snowflake.account_admin

  roles                  = [snowflake_role.roles["LOADER"].name]
  privilege              = "EXECUTE TASK"
  enable_multiple_grants = true
  with_grant_option      = false
}

resource "snowflake_warehouse_grant" "grant_wh_usage" {
  for_each = { for warehouse in var.warehouses : warehouse.name => warehouse }

  provider = snowflake.account_admin

  warehouse_name = each.value.name
  privilege      = "USAGE"
  roles          = [for role_name in each.value.roles : role_name]
}


# Used by dbt in airflow
resource "snowflake_role_grants" "transformer_grant" {
  provider = snowflake.account_admin

  role_name = snowflake_role.roles["TRANSFORMER"].name
  users     = ["SCHEDULER"]
}


# Used by the airtable self-service in airflow
resource "snowflake_role_grants" "scheduler_loader_grant" {
  provider = snowflake.account_admin

  role_name = snowflake_role.roles["LOADER"].name
  users     = ["SCHEDULER"]
}


resource "snowflake_warehouse_grant" "grant" {
  for_each = { for index, grant in var.warehouse_grants : index => grant }

  provider = snowflake.account_admin

  warehouse_name = each.value.warehouse_name
  privilege      = each.value.privilege
  roles          = each.value.roles
}

resource "snowflake_role_ownership_grant" "grant" {
  for_each = { for idx, grant in var.owner_role_grants : idx => grant }
  
  provider = snowflake.account_admin

  on_role_name   = each.value.on_role_name
  to_role_name   = each.value.to_role_name
  current_grants = each.value.current_grants
}