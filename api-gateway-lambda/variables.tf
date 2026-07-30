variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my-lambda-function"
}

variable "runtime" {
  description = "Lambda runtime identifier"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Lambda function handler (file.method)"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "memory_size" {
  description = "Memory allocated to the Lambda function in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 3
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "role_name" {
  description = "Name of the Lambda execution role"
  type        = string
  default     = null
}

variable "api_name" {
  description = "Name of the API Gateway HTTP API"
  type        = string
  default     = "my-http-api"
}

variable "stage_name" {
  description = "API Gateway deployment stage name"
  type        = string
  default     = "$default"
}

variable "cors_allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "List of allowed CORS methods"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_headers" {
  description = "List of allowed CORS headers"
  type        = list(string)
  default     = ["*"]
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
