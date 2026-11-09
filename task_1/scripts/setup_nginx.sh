#!/bin/bash
# Copy to the VM with scp, then run on the VM:
#   sudo bash setup_nginx.sh
# Installs nginx everywhere, but systemd only starts it when role=backend.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
MD="http://metadata.google.internal/computeMetadata/v1/instance/attributes"

apt-get update
apt-get install -y nginx

# Label checker is delivered through instance metadata by Terraform
curl -fsS -H "Metadata-Flavor: Google" "$MD/check-labels-py" -o /usr/local/bin/check_labels.py
chmod 755 /usr/local/bin/check_labels.py

# systemd drop-in: before nginx starts, check the role label.
# Exit 1 = condition not met, so systemd skips the start without marking it failed.
mkdir -p /etc/systemd/system/nginx.service.d
cat > /etc/systemd/system/nginx.service.d/role.conf <<'UNIT'
[Unit]
Wants=network-online.target
After=network-online.target

[Service]
ExecCondition=/usr/bin/python3 /usr/local/bin/check_labels.py --require backend
UNIT

systemctl daemon-reload
systemctl enable nginx
systemctl restart nginx   # backend: runs. frontend: stopped, start is skipped by the condition
