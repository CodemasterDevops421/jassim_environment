output "public_ips" {
  description = "The public IP addresses of the instances"
  value       = aws_instance.demo-server[*].public_ip
}

output "private_ips" {
  description = "The private IP addresses of the instances"
  value       = aws_instance.demo-server[*].private_ip
}

