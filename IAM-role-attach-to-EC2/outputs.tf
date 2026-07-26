output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.this.public_dns
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the instance"
  value       = aws_iam_role.this.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the instance"
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.this.name
}

output "attached_policy_arn" {
  description = "ARN of the S3 read-only policy attached to the role"
  value       = local.s3_read_only_policy_arn
}
