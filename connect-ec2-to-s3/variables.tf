variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket the EC2 instance will access"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "ec2-s3-connector"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "ec2-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed for HTTP access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_https_cidr" {
  description = "CIDR block allowed for HTTPS access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = null
}

variable "permissions_mode" {
  description = "S3 access mode: read_only | read_write | read_write_prefix"
  type        = string
  default     = "read_only"

  validation {
    condition     = contains(["read_only", "read_write", "read_write_prefix"], var.permissions_mode)
    error_message = "permissions_mode must be one of: read_only, read_write, read_write_prefix."
  }
}

variable "write_prefix" {
  description = "S3 key prefix where writes are allowed (read_write_prefix mode)"
  type        = string
  default     = "uploads"
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

variable "localstack_ami_id" {
  description = "Hardcoded AMI ID for LocalStack"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}
