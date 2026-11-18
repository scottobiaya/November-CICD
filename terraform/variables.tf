
variable "public_key" {
  description = "SSH public key used to access the EC2 instance"
  type        = string
  sensitive   = true
}
