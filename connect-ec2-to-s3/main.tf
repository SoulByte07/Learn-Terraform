locals {
  ami_id    = try(one(data.aws_ami.amazon_linux_2023[*].id), var.localstack_ami_id)
  role_name = coalesce(var.role_name, "${var.instance_name}-role")
}

data "aws_ami" "amazon_linux_2023" {
  count = var.use_localstack ? 0 : 1

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name        = var.key_name
    Environment = var.environment
  }
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = pathexpand("~/.ssh/${var.key_name}.pem")
  file_permission = "0600"
}

resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = null

  tags = {
    Name        = "${var.instance_name}-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH access"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_http_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP access"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_https_cidr
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS access"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "All outbound traffic"
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "hello" {
  bucket       = aws_s3_bucket.this.id
  key          = "hello.txt"
  content      = "Hello from EC2 -> S3 connection demo!\n"
  content_type = "text/plain"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = local.role_name
    Environment = var.environment
  }
}

moved {
  from = data.aws_iam_policy_document.s3_read_only
  to   = data.aws_iam_policy_document.s3_access
}

moved {
  from = aws_iam_policy.s3_read_only
  to   = aws_iam_policy.s3_access
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }

  dynamic "statement" {
    for_each = var.permissions_mode == "read_only" ? [] : [1]
    content {
      effect = "Allow"
      actions = [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
      ]
      resources = var.permissions_mode == "read_write"
        ? ["${aws_s3_bucket.this.arn}/*"]
        : ["${aws_s3_bucket.this.arn}/${var.write_prefix}/*"]
    }
  }
}

resource "aws_iam_policy" "s3_access" {
  name   = "${var.instance_name}-s3-access"
  policy = data.aws_iam_policy_document.s3_access.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_name}-instance-profile"
  role = aws_iam_role.this.name

  tags = {
    Name        = "${var.instance_name}-instance-profile"
    Environment = var.environment
  }
}

resource "aws_instance" "this" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/scripts/bootstrap.sh.tpl", {
    bucket_name          = var.bucket_name
    use_localstack       = var.use_localstack
    localstack_endpoint  = var.localstack_endpoint
    aws_region           = var.aws_region
    permissions_mode     = var.permissions_mode
    write_prefix         = var.write_prefix
  })

  user_data_replace_on_change = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = !var.use_localstack

    tags = {
      Name = "${var.instance_name}-root-volume"
    }
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
