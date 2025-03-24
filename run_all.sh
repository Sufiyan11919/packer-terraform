#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SSH_DIR="${ROOT_DIR}/.ssh"
PACKER_DIR="${ROOT_DIR}/packer"
TERRAFORM_DIR="${ROOT_DIR}/terraform"

# Load environment
set -a
source "${ROOT_DIR}/.env"
set +a

# Ensure SSH key
mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"

if [ ! -f "${SSH_DIR}/id_rsa" ]; then
  echo "[INFO] Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -N "" -f "${SSH_DIR}/id_rsa"
fi

echo "[INFO] Running Packer build..."
cd "${PACKER_DIR}"
packer validate amazon-linux-docker.json
packer build amazon-linux-docker.json | tee build.log
AMI_ID=$(grep -Eo 'ami-[0-9a-f]{17}' build.log | tail -1)
echo "[INFO] Created AMI: ${AMI_ID}"

echo "[INFO] Getting public IP..."
MY_IP=$(curl -s https://checkip.amazonaws.com)/32
echo "Public IP: ${MY_IP}"

echo "[INFO] Deploying with Terraform..."
cd "${TERRAFORM_DIR}"
terraform init
terraform plan -var="ami_id=${AMI_ID}" -var="bastion_src_ip=${MY_IP}"
terraform apply -auto-approve -var="ami_id=${AMI_ID}" -var="bastion_src_ip=${MY_IP}"
