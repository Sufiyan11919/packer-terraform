# AWS Custom AMI & Terraform Infrastructure

## Overview
This project demonstrates how to:
1. Build a custom Amazon Linux AMI with Docker & Docker Compose using Packer
2. Deploy a VPC, a bastion host, and multiple private EC2 instances via Terraform
3. Test SSH connectivity and optionally destroy the infrastructure

## Prerequisites
- [AWS CLI](https://aws.amazon.com/cli/) configured or environment variables in `.env`
- [Terraform](https://www.terraform.io/downloads) installed
- [Packer](https://developer.hashicorp.com/packer) installed
-  If installing from homebrew then use this commands 
    steps
brew tap hashicorp/tap
brew install hashicorp/tap/packer
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

### Installing Packer Plugins
If you receive an error like **"The builder amazon-ebs is unknown"**, you may need to install the Amazon EBS plugin:
```bash
packer plugins install github.com/hashicorp/amazon
packer plugins installed
