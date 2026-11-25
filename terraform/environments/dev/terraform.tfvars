environment        = "dev"
vpc_cidr           = "10.10.0.0/16"
public_subnet_cidr = "10.10.1.0/24"
availability_zone  = "us-east-1a"

instance_type = "t3.micro"
ami_id        = "ami-096ef200a877f36af"
key_name      = "november-ec2-key"

ssh_allowed_cidr = "91.8.247.132/32"