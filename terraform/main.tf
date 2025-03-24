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

resource "aws_security_group" "sg_bastion" {
  name        = "sg-bastion"
  vpc_id      = module.my_vpc.vpc_id
  description = "SSH from my IP only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Placeholder
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
