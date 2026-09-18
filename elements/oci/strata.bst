kind: compose

depends:
- strata/deps.bst

config:
  # Install the base system from the dependency stack
  install-commands:
  - bst-artifact-install strata/deps.bst ${DESTDIR}

  # Set up the OS release
  - |
    mkdir -p ${DESTDIR}/etc
    cat > ${DESTDIR}/etc/os-release << 'EOF'
NAME="Terrace"
ID="terrace"
VERSION_ID="26.08.1"
PRETTY_NAME="Terrace 26.08.1 (Strata)"
VERSION="26.08.1 (Free Desktop SDK)"
VERSION_CODENAME="terrace"
BUILD_ID="26.08.1"
HOME_URL="https://github.com/huntedraven7/terrace"
SUPPORT_URL="https://github.com/huntedraven7/terrace/issues"
BUG_REPORT_URL="https://github.com/huntedraven7/terrace/issues"
VARIANT="strata"
VARIANT_ID="strata"
EOF

  # Set up bootc configuration
  - mkdir -p ${DESTDIR}/etc/bootc
  - cat > ${DESTDIR}/etc/bootc/bootc.json << 'EOF'
{
  "bootc": {
    "version": "26.08.1",
    "image": "ghcr.io/huntedraven7/terrace/strata",
    "variant": "strata"
  }
}
EOF

  # Enable services
  - |
    mkdir -p ${DESTDIR}/etc/systemd/system/multi-user.target.wants
    ln -sf /usr/lib/systemd/system/NetworkManager.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/NetworkManager.service
    ln -sf /usr/lib/systemd/system/dbus-broker.service ${DESTDIR}/etc/systemd/system/dbus-broker.service
    ln -sf /usr/lib/systemd/system/terrace-server-setup.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/terrace-server-setup.service
    ln -sf /usr/lib/systemd/system/systemd-sysupdate.service ${DESTDIR}/etc/systemd/system/multi-user.target.wants/systemd-sysupdate.service

  # SSH is disabled by default (on-demand)
  # systemctl enable sshd.service is NOT done

  # Copy server files from files/
  - |
    if [ -d /src/files ]; then
      cp -r /src/files/* ${DESTDIR}/
    fi