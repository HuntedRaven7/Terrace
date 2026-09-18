kind: manual

depends:
- include/os-release.yml

config:
  install-commands:
  - mkdir -p ${DESTDIR}/etc
  - cat > ${DESTDIR}/etc/os-release << 'EOF'
NAME="Terrace"
ID="terrace"
VERSION_ID="26.08.1"
PRETTY_NAME="Terrace 26.08.1"
VERSION="26.08.1 (Free Desktop SDK)"
VERSION_CODENAME="terrace"
BUILD_ID="26.08.1"
HOME_URL="https://github.com/huntedraven7/terrace"
SUPPORT_URL="https://github.com/huntedraven7/terrace/issues"
BUG_REPORT_URL="https://github.com/huntedraven7/terrace/issues"
VARIANT="terrace"
VARIANT_ID="terrace"
EOF