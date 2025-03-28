output "vpc_id" {
  description = "ID of the VPC"
  value       = module.my_vpc.vpc_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion instance"
  value       = aws_instance.bastion_host.public_ip
}

output "private_ips" {
  description = "Private IP addresses of the private instances"
  value       = aws_instance.private_ec2[*].private_ip
}
