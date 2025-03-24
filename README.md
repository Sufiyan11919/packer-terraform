# AWS Custom AMI & Terraform Infrastructure

## 📖 Overview
This project demonstrates how to:

1. ✅ Build a custom Amazon Linux AMI with Docker & Docker Compose using **Packer**
2. ✅ Deploy a VPC, a bastion host, and multiple private EC2 instances via **Terraform**
3. ✅ Test SSH connectivity and optionally destroy the infrastructure

---

## 🧪 Create & Load `.env` File

**Example structure:**

```env
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_SESSION_TOKEN=your_token
AWS_DEFAULT_REGION=us-east-1
NUM_PRIVATE_INSTANCES=6
```

---

## 1️⃣ Load Environment Variables (for standalone Packer runs)

```bash
set -a
source .env
set +a
```

This exports your AWS credentials and other necessary variables into your shell session.

---

## ⚙️ Prerequisites

- ✅ [AWS CLI](https://aws.amazon.com/cli/) configured or `.env` file with valid credentials
- ✅ [Terraform](https://www.terraform.io/downloads) installed
- ✅ [Packer](https://developer.hashicorp.com/packer) installed

### 📦 Installing with Homebrew (if using macOS)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer
brew install hashicorp/tap/terraform
```

---

### 🔌 Installing Packer Plugins

If you get an error like:

> **"The builder amazon-ebs is unknown"**

Run this:

```bash
packer plugins install github.com/hashicorp/amazon
```

This will install the necessary plugin to support `amazon-ebs` builder.

---

## 🚀 Run Full Workflow (Packer + Terraform)

Run the main script to build the AMI and deploy infra:

```bash
# If not already executable
chmod +x run_all.sh

# Execute the script
./run_all.sh
```

---

## 📸 Screenshots

| Step | Description | Screenshot |
|------|-------------|------------|
| ✅ | Validating Packer template | ![Validate Packer](https://github.com/Sufiyan11919/packer-terraform/blob/main/screenshots/validatepacker.png) |
| 🐳 | Packer building AMI with Docker | ![Packer Build](https://github.com/Sufiyan11919/packer-terraform/blob/main/screenshots/build_packer.png) |
| 💻 | Final terminal result (AMI created & infra deployed) | ![Final Result](https://github.com/Sufiyan11919/packer-terraform/blob/main/screenshots/terminal_final_result.png) |
| ☁️ | AWS EC2 Instances created | ![Instances](https://github.com/Sufiyan11919/packer-terraform/blob/main/screenshots/instances.png) |

