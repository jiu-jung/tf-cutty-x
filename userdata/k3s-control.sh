#!/bin/bash
set -euo pipefail

# --- 기본 설정 ---
# region 은 메타데이터에서 가져오기 (ap-northeast-2 기준)
REGION="ap-northeast-2"
PARAM_PREFIX="/k3s"

# --- 필요 유틸 설치 (Amazon Linux 2023 기준) ---
yum update -y || true
yum install -y awscli || true

# --- SSM Agent (안 깔려 있으면) ---
if ! systemctl is-active --quiet amazon-ssm-agent; then
  yum install -y amazon-ssm-agent || true
  systemctl enable amazon-ssm-agent || true
  systemctl start amazon-ssm-agent || true
fi

# --- k3s 서버 설치 ---
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" sh -

# node-token 파일 생성될 때까지 대기
for i in {1..20}; do
  if [ -f /var/lib/rancher/k3s/server/node-token ]; then
    break
  fi
  echo "Waiting for k3s node-token..."
  sleep 3
done

TOKEN=$(cat /var/lib/rancher/k3s/server/node-token | tr -d '\n')

# --- SSM Parameter Store 에 저장 ---
aws ssm put-parameter \
  --region "${REGION}" \
  --name "${PARAM_PREFIX}/cluster-token" \
  --type "SecureString" \
  --value "${TOKEN}" \
  --overwrite

echo "k3s token stored to SSM Parameter Store"
