#######################################
# Provider & VPC Module (existing code)
#######################################
provider "aws" {
  region = var.region
}

module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "myCustomVPC"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#######################################
# AMI Data Sources
#######################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#######################################
# Security Groups
#######################################
# 1) Ansible Controller SG (public)
resource "aws_security_group" "sg_ansible_controller" {
  name        = "ansible-controller-sg"
  description = "Allow SSH from your IP"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    description = "SSH from local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_src_ip]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_AnsibleController"
  }
}

# 2) Private Instances SG
resource "aws_security_group" "sg_private" {
  name        = "private-sg"
  description = "Allow SSH from Ansible Controller"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    description     = "SSH from controller"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ansible_controller.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Private"
  }
}

#######################################
# Ansible Controller Instance (public)
#######################################
resource "aws_instance" "ansible_controller" {
  ami                    = data.aws_ami.ubuntu.id  # Using Ubuntu for the controller
  instance_type          = var.controller_instance_type
  subnet_id              = module.my_vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.sg_ansible_controller.id]

  associate_public_ip_address = true

  tags = {
    Name = "AnsibleController"
    Role = "ansible-controller"
  }

  # Optional: bootstrap Ansible automatically
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y software-properties-common python3-pip
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get update -y
    apt-get install -y ansible
    pip3 install boto3 botocore
  EOF
}

#######################################
# Private Ubuntu Instances
#######################################
resource "aws_instance" "ubuntu_ec2" {
  count                  = var.num_ubuntu_instances
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.private_instance_type
  subnet_id              = element(module.my_vpc.private_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.sg_private.id]

  tags = {
    Name = "UbuntuEC2-${count.index}"
    OS   = "ubuntu"
    Role = "ansible-target"
  }
}

#######################################
# Private Amazon Linux Instances
#######################################
resource "aws_instance" "amazon_ec2" {
  count                  = var.num_amazon_instances
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.private_instance_type
  subnet_id              = element(module.my_vpc.private_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.sg_private.id]

  tags = {
    Name = "AmazonEC2-${count.index}"
    OS   = "amazon"
    Role = "ansible-target"
  }
}
