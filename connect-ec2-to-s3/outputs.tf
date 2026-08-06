output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.this.public_dns
}

output "bucket_name" {
  description = "Name of the S3 bucket the instance can access"
  value       = aws_s3_bucket.this.id
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the instance"
  value       = aws_iam_role.this.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the instance"
  value       = aws_iam_role.this.arn
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.this.public_ip}"
}

output "verify_commands" {
  description = "Commands to run inside the instance to verify S3 read/write access"
  value = [
    "aws sts get-caller-identity",
    "aws s3 ls s3://${aws_s3_bucket.this.id}/",
    "aws s3 cp s3://${aws_s3_bucket.this.id}/hello.txt -",
    "echo 'test' > /tmp/upload.txt && aws s3 cp /tmp/upload.txt s3://${aws_s3_bucket.this.id}/upload.txt",
    "mkdir -p /tmp/sync && echo 'a' > /tmp/sync/a.txt && aws s3 sync /tmp/sync s3://${aws_s3_bucket.this.id}/${var.write_prefix}/sync/",
  ]
}
