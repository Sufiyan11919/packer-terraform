#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")"/.. && pwd)"
SSH_KEY="${ROOT_DIR}/.ssh/id_rsa"
TERRAFORM_DIR="${ROOT_DIR}/terraform"

cd "$TERRAFORM_DIR"

# Gather outputs
BASTION_IP=$(terraform output -raw bastion_public_ip)
PRIVATE_IPS=$(terraform output -json private_ips | jq -r '.[]')

echo "Verifying SSH connectivity..."

# start ssh-agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi

ssh-add "$SSH_KEY"

# Bastion host
echo "Testing connection to Bastion at $BASTION_IP ..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o ConnectTimeout=10 ec2-user@"$BASTION_IP" \
  "echo 'Connected to bastion successfully!'"

# Private instances
for IP in $PRIVATE_IPS; do
  echo "Testing connection to private instance at $IP..."
  ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
    -J ec2-user@"$BASTION_IP" ec2-user@"$IP" \
    "echo 'Connected to private instance successfully!'"
done

echo "All SSH tests completed successfully."
