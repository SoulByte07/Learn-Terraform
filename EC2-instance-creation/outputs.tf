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

output "availability_zone" {
  description = "Availability Zone of the EC2 instance"
  value       = aws_instance.this.availability_zone
}

output "ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = aws_instance.this.ami
}

output "key_pair_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_file" {
  description = "Path to the saved private key file"
  value       = local_sensitive_file.private_key.filename
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}
