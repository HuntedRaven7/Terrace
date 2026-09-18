kind: compose

depends:
- plateau/deps.bst

config:
  # Install the base system from the dependency stack
  install-commands:
  - bst-artifact-install plateau/deps.bst ${DESTDIR}

  # Set up the OS release
  - |
    mkdir -p ${DESTDIR}/etc
    cat > ${DESTDIR}/etc/os-release << 'EOF'
NAME="Terrace"
ID="terrace"
VERSION_ID="26.08.1"
PRETTY_NAME="Terrace 26.08.1 (Plateau)"
VERSION="26.08.1 (Free Desktop SDK)"
VERSION_CODENAME="terrace"
BUILD_ID="26.08.1"
HOME_URL="https://github.com/huntedraven7/terrace"
SUPPORT_URL="https://github.com/huntedraven7/terrace/issues"
BUG_REPORT_URL="https://github.com/huntedraven7/terrace/issues"
VARIANT="plateau"
VARIANT_ID="plateau"
EOF

  # Set up bootc configuration
  - mkdir -p ${DESTDIR}/etc/bootc
  - cat > ${DESTDIR}/etc/bootc/bootc.json << 'EOF'
{
  "bootc": {
    "version": "26.08.1",
    "image": "ghcr.io/huntedraven7/terrace/plateau",
    "variant": "plateau"
  }
}
EOF

  # Enable services
  - |
    mkdir -p ${DESTDIR}/etc/systemd/system/multi-user.target.wants
    ln -sf /usr/lib/systemd/system/NetworkManager.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/NetworkManager.service
    ln -sf /usr/lib/systemd/system/dbus-broker.service ${DESTDIR}/etc/systemd/system/dbus-broker.service
    ln -sf /usr/lib/systemd/system/pipewire.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/pipewire.service
    ln -sf /usr/lib/systemd/system/wireplumber.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/wireplumber.service
    ln -sf /usr/lib/systemd/system/polkit.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/polkit.service

  # Copy desktop files from files/
  - |
    if [ -d /src/files ]; then
      cp -r /src/files/* ${DESTDIR}/
    fi