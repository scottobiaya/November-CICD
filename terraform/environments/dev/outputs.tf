output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.infrastructure.vpc_id
}

output "instance_id" {
  description = "Dev Nginx EC2 instance ID"
  value       = module.infrastructure.instance_id
}

output "instance_public_ip" {
  description = "Dev Nginx public IP"
  value       = module.infrastructure.instance_public_ip
}

output "nginx_url" {
  description = "Dev Nginx website URL"
  value       = module.infrastructure.nginx_url
}