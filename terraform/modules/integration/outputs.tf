output "storage_integration" {
  value = snowflake_storage_integration.integration
}

output "notification_integration" {
  value = snowflake_notification_integration.integration
}

output "api_integration" {
  value = snowflake_api_integration.api_integration
}

output "tags" {
  value = snowflake_tag.tag
}

output "resource_monitors" {
  value = snowflake_resource_monitor.monitor
}
