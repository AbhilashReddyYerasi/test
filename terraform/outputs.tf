output "warehouses" {
  value = module.core[0].warehouses
}

output "roles" {
  value = module.core[0].roles
}

output "databases" {
  value = module.database[0].databases
}

output "schemas" {
  value = module.database[0].schemas
}

output "storage_integration" {
  value = module.integration[0].storage_integration
}

output "notification_integration" {
  value = module.integration[0].notification_integration
}

output "resource_monitors" {
  value = module.integration[0].resource_monitors
}
