kind: manual

depends:
- freedesktop-sdk.bst:linux-ogc

config:
  install-commands:
  - mkdir -p ${DESTDIR}
  - bst-artifact-install freedesktop-sdk.bst:linux-ogc ${DESTDIR}