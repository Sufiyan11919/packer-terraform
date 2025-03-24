#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")"/.. && pwd)"
SSH_KEY="${ROOT_DIR}/.ssh/id_rsa"
TERRAFORM_DIR="${ROOT_DIR}/terraform"

cd "$TERRAFORM_DIR"

BASTION_IP=$(terraform output -raw bastion_public_ip)
PRIVATE_IPS=$(terraform output -json private_ips | jq -r '.[]')

echo "[INFO] Verifying SSH connectivity..."

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi
ssh-add "$SSH_KEY"

ssh -o StrictHostKeyChecking=no ec2-user@"$BASTION_IP" "echo 'Bastion connected!'"

for IP in $PRIVATE_IPS; do
  echo "Testing private instance at $IP..."
  ssh -o StrictHostKeyChecking=no -J ec2-user@"$BASTION_IP" ec2-user@"$IP" \
    "echo 'Private instance connected!'"
done

echo "[INFO] All SSH tests passed!"
