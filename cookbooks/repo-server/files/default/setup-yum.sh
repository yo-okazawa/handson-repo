#!/bin/sh

set -e

sudo -k

echo "This script requires superuser authority to configure Mackerel yum repository:"

sudo sh <<'SCRIPT'
  set -x

  # add hosts for reposerver
  echo '198.18.0.15  chefrepo.cloud-platform.kddi.ne.jp' >> /etc/hosts

  # import GPG key
  gpgkey_path=`mktemp`
  curl -fsSk -o $gpgkey_path https://chefrepo.cloud-platform.kddi.ne.jp/packages/mackerel/GPG-KEY-mackerel
  rpm --import $gpgkey_path
  rm $gpgkey_path

  # add config for mackerel yum repos
  cat >/etc/yum.repos.d/mackerel.repo <<'EOF';
[mackerel]
name=mackerel-agent
baseurl=https://chefrepo.cloud-platform.kddi.ne.jp/packages/yum_mackerel/mackerel-$basearch
sslverify=0
gpgcheck=1
EOF
SCRIPT

echo 'done'
echo 'To install mackerel-agent type: sudo yum install mackerel-agent'
