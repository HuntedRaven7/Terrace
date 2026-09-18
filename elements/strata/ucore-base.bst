kind: stack

depends:
# Minimal base - uutils coreutils instead of GNU
- freedesktop-sdk.bst:uutils-coreutils
- freedesktop-sdk.bst:bash
- freedesktop-sdk.bst:util-linux
- freedesktop-sdk.bst:findutils
- freedesktop-sdk.bst:grep
- freedesktop-sdk.bst:sed
- freedesktop-sdk.bst:gawk
- freedesktop-sdk.bst:which
- freedesktop-sdk.bst:less
- freedesktop-sdk.bst:vim
- freedesktop-sdk.bst:nano

# Systemd minimal
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:systemd-libs
- freedesktop-sdk.bst:systemd-sysupdate
- freedesktop-sdk.bst:systemd-repart
- freedesktop-sdk.bst:systemd-ukify
- freedesktop-sdk.bst:systemd-container

# Networking minimal
- freedesktop-sdk.bst:networkmanager
- freedesktop-sdk.bst:openssh
- freedesktop-sdk.bst:openssl
- freedesktop-sdk.bst:ca-certificates
- freedesktop-sdk.bst:curl
- freedesktop-sdk.bst:iproute2
- freedesktop-sdk.bst:iptables
- freedesktop-sdk.bst:iptables-nft

# File systems
- freedesktop-sdk.bst:e2fsprogs
- freedesktop-sdk.bst:dosfstools
- freedesktop-sdk.bst:btrfs-progs
- freedesktop-sdk.bst:xfsprogs
- freedesktop-sdk.bst:cryptsetup

# Container runtime
- freedesktop-sdk.bst:crun
- freedesktop-sdk.bst:runc
- freedesktop-sdk.bst:containerd