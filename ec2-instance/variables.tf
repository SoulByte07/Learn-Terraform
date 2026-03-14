variable "instance_name"{
    description="Value of the EC2 instance name"
    type=string
    default="hashicorp-learn"
}

variable "instance_type"{
    description="EC2 instance type"
    type=string
    default="t2.micro"
}
