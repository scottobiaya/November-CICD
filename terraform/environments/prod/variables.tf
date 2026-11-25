variable "environment" {
  description = "Name of the environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for the Production VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the Production public subnet"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Production"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  type        = string
}

variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR range allowed to access EC2 through SSH"
  type        = string
}
