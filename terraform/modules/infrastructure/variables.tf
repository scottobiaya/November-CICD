
variable "environment" {
  description = "Name of the environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for this environment"
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
  description = "CIDR range allowed to access EC2 through SSH"
  type        = string
}