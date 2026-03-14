provider "aws" {
  region = "us-west-2"

  access_key                  = "anaccesskey"
  secret_key                  = "asecretkey"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.linux.id
#   instance_type = "t2.micro"
    instance_type=var.instance_type

    vpc_security_group_ids=[module.vpc.default_security_group_id]
    subnet_id=module.vpc.private_subnets[0]


  tags = {
    # Name = "hashicorp-learn"
    Name=var.instance_name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames    = true
}




































