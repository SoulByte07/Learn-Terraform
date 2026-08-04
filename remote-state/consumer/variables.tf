variable "bucket_name" {
  description = "Name of the demo data S3 bucket (proves state is stored remotely)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "use_localstack" {
  description = "Enable LocalStack compatibility mode"
  type        = bool
  default     = false
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
  default     = "http://localhost:4566"
}
