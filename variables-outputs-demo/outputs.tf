output "name_prefix" {
  description = "Generated resource name prefix"
  value       = local.name_prefix
}

output "merged_tags" {
  description = "Complete tag set (variable tags + computed tags)"
  value       = local.merged_tags
}

output "instance_config" {
  description = "EC2 instance configuration"
  value       = var.instance_config
}

output "db_password" {
  description = "Database master password (sensitive — redacted in CLI)"
  value       = var.db_password
  sensitive   = true
}

output "summary" {
  description = "Full deployment summary"
  value       = local.summary
}

output "is_production" {
  description = "Whether this is a production deployment"
  value       = var.environment == "prod"
}

output "connection_cmd" {
  description = "Example connection command (conditional)"
  value = var.db_username != null
    ? "psql -U ${var.db_username} -h ${local.name_prefix}.rds.amazonaws.com"
    : null
}
