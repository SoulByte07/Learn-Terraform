output "data_bucket_name" {
  description = "Name of the demo data bucket"
  value       = aws_s3_bucket.data.id
}

output "data_bucket_arn" {
  description = "ARN of the demo data bucket"
  value       = aws_s3_bucket.data.arn
}

output "state_backend" {
  description = "S3 backend used for this state (from -backend-config)"
  value = {
    bucket  = "provided via -backend-config at init"
    key     = "provided via -backend-config at init"
    region  = var.aws_region
    table   = "provided via -backend-config at init"
  }
}
