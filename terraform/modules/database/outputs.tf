output "databases" {
  value = snowflake_database.db
}

output "file_formats" {
  value = snowflake_file_format.file_format
}

output "schemas" {
  value = snowflake_schema.schemas
}

output "tables" {
  value = snowflake_table.tables
}

output "stage" {
  value = snowflake_stage.stage
}
