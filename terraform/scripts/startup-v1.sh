#!/bin/bash
apt-get update
apt-get install -y nginx stress
HOST=$(hostname)
ZONE=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | awk -F/ '{print $NF}')
echo "<h1>Version: v1</h1><p>Host: $HOST</p><p>Zone: $ZONE</p>" > /var/www/html/index.html
systemctl restart nginx
