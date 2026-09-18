kind: manual

sources:
- kind: git_repo
  url: https://github.com/kubestellar/kubestellar.git
  track: v0.14.0
  ref: v0.14.0

depends:
- freedesktop-sdk.bst:go
- freedesktop-sdk.bst:make
- freedesktop-sdk.bst:kubectl
- freedesktop-sdk.bst:helm

config:
  environment:
    CGO_ENABLED: "0"
    GOFLAGS: "-trimpath -buildvcs=false"
  build-commands:
  - make build
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp bin/kubestellar ${DESTDIR}/usr/bin/
  - mkdir -p ${DESTDIR}/usr/lib/systemd/system
  - cat > ${DESTDIR}/usr/lib/systemd/system/kubestellar.service << 'EOF'
[Unit]
Description=KubeStellar - Multi-cluster Kubernetes Management
Documentation=https://kubestellar.io
After=network-online.target k0s.service
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/kubestellar controller
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF