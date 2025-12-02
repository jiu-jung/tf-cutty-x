#!/bin/bash
set -euo pipefail

REGION="ap-northeast-2"
PARAM_PREFIX="/k3s"

yum update -y || true
yum install -y awscli || true

SERVER_IP="${server_private_ip}"
SERVER_URL="https://$SERVER_IP:6443"

TOKEN=$(aws ssm get-parameter \
  --region "$REGION" \
  --name "$PARAM_PREFIX/cluster-token" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text)

echo "Fetched SERVER_URL=$SERVER_URL"
echo "Fetched TOKEN length: $${#TOKEN}"

curl -sfL https://get.k3s.io | \
  K3S_URL="$SERVER_URL" \
  K3S_TOKEN="$TOKEN" \
  INSTALL_K3S_EXEC="agent" \
  sh -

echo "k3s agent joined successfully."
