
variable "public_key" {
  description = "SSH public key used to access the EC2 instance"
  type        = string
  sensitive   = true
}



variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
  default     = "november-ec2-key"
}

