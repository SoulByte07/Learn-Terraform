locals {
  ami_id = try(one(data.aws_ami.amazon_linux_2023[*].id), var.localstack_ami_id)
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

data "aws_iam_policy" "s3_read_only" {
  count = var.use_localstack ? 0 : 1
  arn   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_policy" "s3_read_only_localstack" {
  count = var.use_localstack ? 1 : 0
  name  = "${var.instance_name}-s3-read-only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*",
        ]
        Resource = "*"
      },
    ]
  })
}

locals {
  s3_read_only_policy_arn = try(
    one(data.aws_iam_policy.s3_read_only[*].arn),
    aws_iam_policy.s3_read_only_localstack[0].arn,
  )
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.this.name
  policy_arn = local.s3_read_only_policy_arn
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
