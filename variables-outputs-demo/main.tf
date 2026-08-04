terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "this" {
  length    = 2
  separator = "-"
}

locals {
  name_prefix = "${var.project_name}-${random_pet.this.id}"
  merged_tags = merge(var.tags, {
    Name        = local.name_prefix
    Environment = var.environment
    Project     = var.project_name
  })

  summary = <<-EOT
    Project:      ${var.project_name}
    Environment:  ${var.environment}
    Pet Name:     ${random_pet.this.id}
    Instances:    ${var.instance_count}
    Monitoring:   ${var.enable_monitoring ? "ON" : "OFF"}
    DB User:      ${var.db_username != null ? var.db_username : "(not set)"}
    Instance:     ${var.instance_config.instance_type} / ${var.instance_config.root_volume}GB
  EOT
}

resource "terraform_data" "this" {
  input = local.name_prefix
}
