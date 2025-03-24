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

# ✅ Security group for the bastion
resource "aws_security_group" "sg_bastion" {
  name        = "bastion-sg"  # ✅ FIXED: can't start with sg-
  description = "Allow SSH from my IP only"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_src_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Bastion"
  }
}

# ✅ Security group for private instances
resource "aws_security_group" "sg_private" {
  name        = "private-sg"  # ✅ FIXED: can't start with sg-
  description = "Allow SSH only from the bastion"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
    description     = "SSH from bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Private"
  }
}

# Bastion host in public subnet
resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = module.my_vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]

  associate_public_ip_address = true

  tags = {
    Name = "BastionHost"
  }
}

# Private EC2 instances
resource "aws_instance" "private_ec2" {
  count                  = var.num_private_instances
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = element(module.my_vpc.private_subnets, count.index % length(module.my_vpc.private_subnets))
  vpc_security_group_ids = [aws_security_group.sg_private.id]

  tags = {
    Name = "PrivateEC2-${count.index}"
  }
}
