output "ansible_controller_public_ip" {
  description = "Public IP of the Ansible Controller"
  value       = aws_instance.ansible_controller.public_ip
}

output "ubuntu_private_ips" {
  description = "Private IPs of the Ubuntu servers"
  value       = aws_instance.ubuntu_ec2[*].private_ip
}

output "amazon_private_ips" {
  description = "Private IPs of the Amazon servers"
  value       = aws_instance.amazon_ec2[*].private_ip
}
