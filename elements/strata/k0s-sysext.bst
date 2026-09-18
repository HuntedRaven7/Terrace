kind: manual

sources:
- kind: git_repo
  url: https://github.com/k0sproject/k0s.git
  track: v1.30.0
  ref: v1.30.0

depends:
- freedesktop-sdk.bst:go
- freedesktop-sdk.bst:make
- freedesktop-sdk.bst:gcc
- freedesktop-sdk.bst:libseccomp
- freedesktop-sdk.bst:libapparmor

config:
  environment:
    CGO_ENABLED: "1"
    GOFLAGS: "-trimpath -buildvcs=false"
    CGO_CFLAGS: "-I/usr/include"
    CGO_LDFLAGS: "-L/usr/lib"
  build-commands:
  - make k0s
  install-commands:
  - mkdir -p ${DESTDIR}/usr/lib/systemd/system
  - mkdir -p ${DESTDIR}/usr/bin
  - cp k0s ${DESTDIR}/usr/bin/k0s
  - cat > ${DESTDIR}/usr/lib/systemd/system/k0s.service << 'EOF'
[Unit]
Description=k0s - Zero Friction Kubernetes
Documentation=https://k0sproject.io
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/k0s controller --enable-worker --no-taints --disable-components=konnectivity
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=5s
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

  - cat > ${DESTDIR}/usr/lib/systemd/system/k0s-worker.service << 'EOF'
[Unit]
Description=k0s Worker
Documentation=https://k0sproject.io
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/k0s worker --token-file /var/lib/k0s/token
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=5s
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF