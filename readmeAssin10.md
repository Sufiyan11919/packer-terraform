# AWS EC2 Infrastructure Automation 

## Prerequisites

- AWS credentials (Access Key, Secret Key, Session Token)
- Terraform (v1.3+ or higher)
- SSH key file with appropriate permissions:
  ```bash
  chmod 400 labsuser.pem
Setup Steps
1. Create .env file in the project root:
bash
Copy
Edit
export AWS_ACCESS_KEY="YOUR_ACCESS_KEY"
export AWS_SECRET_KEY="YOUR_SECRET_KEY"
export AWS_SESSION_TOKEN="YOUR_SESSION_TOKEN"
export AWS_REGION="us-east-1"
export SSH_KEY_PATH="/absolute/path/to/labsuser.pem"
Then run:

bash
Copy
Edit
source .env
2. Make Scripts Executable
bash
Copy
Edit
chmod +x run_now.sh
chmod +x scripts/*.sh
3. Provision and Configure Infrastructure
bash
Copy
Edit
./run_now.sh
This will:

Run Terraform to create VPC, subnets, bastion host, and 6 EC2 instances

SSH into the bastion and install Git and Ansible

Run an Ansible playbook to:

Update packages

Install and verify Docker

Display disk usage


//checking