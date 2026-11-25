variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "Staging VPC CIDR range"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Staging public subnet CIDR range"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
}

variable "instance_type" {
  description = "Staging EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Approved SSH source IP"
  type        = string
}
