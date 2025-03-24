# AWS Custom AMI & Terraform Infrastructure

## Overview
This project demonstrates how to:
1. Build a custom Amazon Linux AMI with Docker & Docker Compose using Packer
2. Deploy a VPC, a bastion host, and multiple private EC2 instances via Terraform
3. Test SSH connectivity and optionally destroy the infrastructure

## Create & Load .env file
example structure
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_SESSION_TOKEN=your_token
AWS_DEFAULT_REGION=us-east-1
NUM_PRIVATE_INSTANCES=6 (for this project)

# 1️⃣ Load the Environment Variables (only if you testing packer individually)
Before anything else, run this:
set -a
source .env
set +a
This exports your AWS credentials and other variables.

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


## Run Full Workflow (Packer + Terraform)
Run the main script:

//gives the permission if not given
chmod +x run_all.sh
./run_all.sh
