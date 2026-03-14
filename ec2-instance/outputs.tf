output "instance_hostname"{
    description="private DNS name of the EC2 instance"
    value=aws_instance.app_server.private_dns
}
