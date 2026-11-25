output "vpc_id" {
  description = "ID of the Production VPC"
  value       = module.infrastructure.vpc_id
}

output "instance_id" {
  description = "ID of the Production Nginx EC2 instance"
  value       = module.infrastructure.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the Production Nginx server"
  value       = module.infrastructure.instance_public_ip
}

output "nginx_url" {
  description = "URL to access the Production Nginx web server"
  value       = module.infrastructure.nginx_url
}
