kind: manual

sources:
- kind: git_repo
  url: https://github.com/NVIDIA/open-gpu-kernel-modules.git
  track: 550.90.07
  ref: 550.90.07

depends:
- core/linux-ogc.bst
- freedesktop-sdk.bst:gcc
- freedesktop-sdk.bst:make
- freedesktop-sdk.bst:libglvnd
- freedesktop-sdk.bst:linux-headers

config:
  environment:
    SYSSRC: "/usr/lib/modules/$(uname -r)/build"
    NV_KERNEL_SOURCES: "/usr/lib/modules/$(uname -r)/build"
  build-commands:
  - make -j$(nproc) modules
  install-commands:
  - mkdir -p ${DESTDIR}/usr/lib/modules/$(uname -r)/extra/nvidia
  - cp kernel-open/nvidia.ko ${DESTDIR}/usr/lib/modules/$(uname -r)/extra/nvidia/
  - cp kernel-open/nvidia-modeset.ko ${DESTDIR}/usr/lib/modules/$(uname -r)/extra/nvidia/
  - cp kernel-open/nvidia-drm.ko ${DESTDIR}/usr/lib/modules/$(uname -r)/extra/nvidia/
  - cp kernel-open/nvidia-uvm.ko ${DESTDIR}/usr/lib/modules/$(uname -r)/extra/nvidia/
  - depmod -b ${DESTDIR} $(uname -r)