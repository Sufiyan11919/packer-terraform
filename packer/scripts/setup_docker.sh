#!/usr/bin/env bash
set -e

# Install Docker
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose (version can be changed as needed)
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p "$DOCKER_CONFIG/cli-plugins"
curl -SL https://github.com/docker/compose/releases/download/v2.33.1/docker-compose-linux-x86_64 \
     -o "$DOCKER_CONFIG/cli-plugins/docker-compose"
chmod +x "$DOCKER_CONFIG/cli-plugins/docker-compose"

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Add the public key to authorized_keys
mkdir -p /home/ec2-user/.ssh
echo "${SSH_PUB_KEY_CONTENT}" >> /home/ec2-user/.ssh/authorized_keys
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
