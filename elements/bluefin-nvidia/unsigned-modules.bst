kind: stack

depends:
- bluefin-nvidia/bluefin-nvidia.bst

config:
  install-commands:
  - |
    # Sign kernel modules for secure boot
    if [ -f /usr/bin/sbsign ]; then
      for module in ${DESTDIR}/usr/lib/modules/*/extra/nvidia/*.ko; do
        if [ -f "$module" ]; then
          sbsign --key /etc/secureboot/db.key --cert /etc/secureboot/db.crt --output "$module.signed" "$module"
          mv "$module.signed" "$module"
        fi
      done
    fi