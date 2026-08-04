variable "project_name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must be lowercase alphanumeric with hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "instance_count" {
  description = "Number of instances to provision"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 100
    error_message = "Instance count must be between 1 and 100."
  }
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "regions" {
  description = "List of AWS regions to deploy to"
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

variable "instance_config" {
  description = "EC2 instance configuration"
  type = object({
    instance_type = string
    ami_id        = optional(string, "ami-0c55b159cbfafe1f0")
    root_volume   = optional(number, 20)
  })
  default = {
    instance_type = "t3.micro"
  }
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
  nullable    = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
