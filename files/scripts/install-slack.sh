#!/bin/bash

set -ouex pipefail

rpm --import https://packagecloud.io/slacktechnologies/slack/gpgkey

cat <<'EOF' | tee /etc/yum.repos.d/slack.repo
[slack]
name=Slack
baseurl=https://packagecloud.io/slacktechnologies/slack/fedora/21/$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packagecloud.io/slacktechnologies/slack/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

dnf5 -y --refresh makecache
dnf5 -y install slack
