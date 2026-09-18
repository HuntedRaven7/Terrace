kind: manual

depends:
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:systemd-sysupdate
- freedesktop-sdk.bst:systemd-repart
- freedesktop-sdk.bst:systemd-ukify
- freedesktop-sdk.bst:systemd-ukify
- freedesktop-sdk.bst:systemd-container

config:
  install-commands:
  - mkdir -p ${DESTDIR}/usr/lib/systemd/system
  - cat > ${DESTDIR}/usr/lib/systemd/system/terrace-server-setup.service << 'EOF'
[Unit]
Description=Terrace Server Initial Setup
Documentation=https://github.com/huntedraven7/terrace
After=network-online.target
Wants=network-online.target
Before=k0s.service kubestellar.service
ConditionPathExists=!/etc/terrace/server-configured

[Service]
Type=oneshot
ExecStart=/usr/libexec/terrace-server-setup
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

  - mkdir -p ${DESTDIR}/usr/libexec
  - cat > ${DESTDIR}/usr/libexec/terrace-server-setup << 'EOF'
#!/bin/bash
set -euo pipefail

# Terrace Server initial configuration
# This runs once on first boot

echo "Running Terrace Server initial setup..."

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
fi
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
fi

# Configure SSH to be disabled by default (on-demand)
systemctl disable sshd.service || true
systemctl stop sshd.service || true

# Set up k0s token directory
mkdir -p /var/lib/k0s
chmod 700 /var/lib/k0s

# Generate k0s token if it doesn't exist
if [ ! -f /var/lib/k0s/token ]; then
    k0s token create --token-file /var/lib/k0s/token || true
fi

# Mark as configured
touch /etc/terrace/server-configured

echo "Terrace Server initial setup complete."
EOF
  - chmod +x ${DESTDIR}/usr/libexec/terrace-server-setup

  # Enable the setup service
  - mkdir -p ${DESTDIR}/etc/systemd/system/multi-user.target.wants
  - ln -sf /usr/lib/systemd/system/terrace-server-setup.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/terrace-server-setup.service

  # systemd-sysupdate configuration for OTA updates
  - mkdir -p ${DESTDIR}/etc/systemd/sysupdate.d
  - cat > ${DESTDIR}/etc/systemd/sysupdate.d/terrace.conf << 'EOF'
[SysUpdate]
# Signed manifest verification
SignedManifests=/usr/share/terrace/signed-manifests
# Trust anchors for verification
TrustAnchors=/usr/share/terrace/trust-anchors
EOF

  # Create directories for signed manifests and trust anchors
  - mkdir -p ${DESTDIR}/usr/share/terrace/signed-manifests
  - mkdir -p ${DESTDIR}/usr/share/terrace/trust-anchors