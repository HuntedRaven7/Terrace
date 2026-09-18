# Lint helper only for an already-built Terrace image.
# Do not add package installation or overlay logic here; Terrace image contents
# come from BuildStream elements and OCI assembly `.bst` files.

FROM ghcr.io/huntedraven7/terrace:latest

RUN bootc container lint || true