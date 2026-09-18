kind: manual

depends:
- freedesktop-sdk.bst:linux

config:
  install-commands:
  - mkdir -p ${DESTDIR}
  - bst-artifact-install freedesktop-sdk.bst:linux ${DESTDIR}