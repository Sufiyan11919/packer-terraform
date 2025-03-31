variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.101.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.101.1.0/24", "10.101.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.101.3.0/24", "10.101.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "bastion_src_ip" {
  description = "local IP (CIDR) for SSH access"
  type        = string
}

variable "controller_instance_type" {
  description = "Instance type for the Ansible Controller"
  type        = string
  default     = "t2.micro"
}

variable "private_instance_type" {
  description = "Instance type for private servers"
  type        = string
  default     = "t2.micro"
}

variable "num_ubuntu_instances" {
  description = "Number of Ubuntu servers"
  type        = number
  default     = 3
}

variable "num_amazon_instances" {
  description = "Number of Amazon Linux servers"
  type        = number
  default     = 3
}
