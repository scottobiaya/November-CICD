output "vpc_id" {
  description = "Staging VPC ID"
  value       = module.infrastructure.vpc_id
}

output "instance_id" {
  description = "Staging Nginx EC2 instance ID"
  value       = module.infrastructure.instance_id
}

output "instance_public_ip" {
  description = "Staging Nginx public IP"
  value       = module.infrastructure.instance_public_ip
}

output "nginx_url" {
  description = "Staging Nginx website URL"
  value       = module.infrastructure.nginx_url
}
