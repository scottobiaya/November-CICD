
output "vpc_id" {
  description = "ID of the environment VPC"
  value       = aws_vpc.main.id
}

output "instance_id" {
  description = "ID of the Nginx EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of the Nginx server"
  value       = aws_instance.web.public_ip
}

output "nginx_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "security_group_id" {
  description = "ID of the Nginx security group"
  value       = aws_security_group.web.id
}
