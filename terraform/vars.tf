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
  description = "List of public subnets"
  type        = list(string)
  default     = ["10.101.1.0/24", "10.101.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.101.3.0/24", "10.101.4.0/24"]
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "The custom AMI ID built by Packer"
  type        = string
}

variable "bastion_src_ip" {
  description = "Public IP (CIDR) allowed to SSH to bastion"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  type        = string
  default     = "t2.micro"
}

variable "private_instance_type" {
  description = "Instance type for the private servers"
  type        = string
  default     = "t2.micro"
}

variable "num_private_instances" {
  description = "How many private instances to launch"
  type        = number
  default     = 6
}
