kind: stack

depends:
# Base FSDK runtime (minimal)
- freedesktop-sdk.bst:runtime
- freedesktop-sdk.bst:platform

# Kernel
- core/linux-fdsdk.bst
(?):
- gaming == true:
  - core/linux-ogc.bst

# Core system - minimal
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:systemd-libs
- freedesktop-sdk.bst:systemd-sysupdate
- freedesktop-sdk.bst:systemd-repart
- freedesktop-sdk.bst:systemd-ukify
- freedesktop-sdk.bst:systemd-container
- freedesktop-sdk.bst:flatpak
- freedesktop-sdk.bst:polkit
- freedesktop-sdk.bst:dbus
- freedesktop-sdk.bst:dbus-broker

# Shell and utilities
- freedesktop-sdk.bst:bash
- freedesktop-sdk.bst:coreutils
- freedesktop-sdk.bst:util-linux
- freedesktop-sdk.bst:findutils
- freedesktop-sdk.bst:grep
- freedesktop-sdk.bst:sed
- freedesktop-sdk.bst:gawk
- freedesktop-sdk.bst:which
- freedesktop-sdk.bst:less
- freedesktop-sdk.bst:vim
- freedesktop-sdk.bst:nano
- freedesktop-sdk.bst:sudo
- freedesktop-sdk.bst:shadow
- freedesktop-sdk.bst:passwd

# Networking
- freedesktop-sdk.bst:networkmanager
- freedesktop-sdk.bst:openssh
- freedesktop-sdk.bst:openssl
- freedesktop-sdk.bst:gnutls
- freedesktop-sdk.bst:ca-certificates
- freedesktop-sdk.bst:curl
- freedesktop-sdk.bst:wget
- freedesktop-sdk.bst:iproute2
- freedesktop-sdk.bst:iptables
- freedesktop-sdk.bst:iptables-nft
- freedesktop-sdk.bst:firewalld

# File systems
- freedesktop-sdk.bst:e2fsprogs
- freedesktop-sdk.bst:dosfstools
- freedesktop-sdk.bst:btrfs-progs
- freedesktop-sdk.bst:xfsprogs
- freedesktop-sdk.bst:lvm2
- freedesktop-sdk.bst:cryptsetup

# Container tools
- freedesktop-sdk.bst:podman
- freedesktop-sdk.bst:buildah
- freedesktop-sdk.bst:skopeo
- freedesktop-sdk.bst:crun
- freedesktop-sdk.bst:runc
- freedesktop-sdk.bst:containerd
- freedesktop-sdk.bst:cri-o

# Kubernetes tools
- freedesktop-sdk.bst:kubectl
- freedesktop-sdk.bst:helm

# Development
- freedesktop-sdk.bst:git
- freedesktop-sdk.bst:meson
- freedesktop-sdk.bst:ninja
- freedesktop-sdk.bst:pkg-config
- freedesktop-sdk.bst:python3
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo
- freedesktop-sdk.bst:go

# Archive
- freedesktop-sdk.bst:tar
- freedesktop-sdk.bst:gzip
- freedesktop-sdk.bst:bzip2
- freedesktop-sdk.bst:xz
- freedesktop-sdk.bst:zstd
- freedesktop-sdk.bst:unzip

# Server specific
- strata/k0s-sysext.bst
- strata/kubestellar.bst
- strata/ucore-base.bst
- strata/server-install.bst