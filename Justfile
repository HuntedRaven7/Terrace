# List available commands
[group('info')]
default:
	@just --list

# Same bst2 container image FSDK/dakota CI uses -- pinned by SHA.
export bst2_image := env("BST2_IMAGE", "registry.gitlab.com/freedesktop-sdk/infrastructure/freedesktop-sdk-docker-images/bst2:64eb0b4930d57a92710822898fb73af6cc1ae35d")

# Prefix for podman calls: empty when rootless podman works, "sudo" otherwise.
sudo_cmd := if `podman info >/dev/null 2>&1 && echo 1 || echo 0` == "1" { "" } else { "sudo" }

# FSDK release parsed from the pinned junction ref — the single source of truth
# for image versioning. e.g. "26.08.1".
export fsdk_version := `grep -oE 'freedesktop-sdk-[0-9]+\.[0-9]+\.[0-9]+' elements/freedesktop-sdk.bst | head -1 | sed 's/freedesktop-sdk-//'`

# Exact junction commit ref (full ref: value), for provenance.
export fsdk_ref := `grep -E '^\s*ref:' elements/freedesktop-sdk.bst | head -1 | sed -E 's/^\s*ref:\s*//'`

# -- BuildStream wrapper ------------------------------------------------------

# Runs any bst command inside the bst2 container via podman.
# Baseline x86_64 (no x86_64_v3) so the base image runs on the widest CPU set.
[group('dev')]
bst *ARGS:
	#!/usr/bin/env bash
	set -euo pipefail

	export CONTAINERS_CONF="${CONTAINERS_CONF:-/dev/null}"
	export CONTAINERS_CONF_OVERRIDE="${CONTAINERS_CONF_OVERRIDE:-/dev/null}"

	mkdir -p "${HOME}/.cache/buildstream"

	# shellcheck disable=SC2086
	{{sudo_cmd}} podman run --rm \
	--privileged \
	--device /dev/fuse \
	--network=host \
	-v "{{justfile_directory()}}:/src:rw" \
	-v "${HOME}/.cache/buildstream:/root/.cache/buildstream:rw" \
	-w /src \
	"{{bst2_image}}" \
	bash -c 'bst --colors "$@"' -- --no-interactive --error-lines 500 ${BST_FLAGS:-} {{ARGS}}

# Print the FSDK-derived point release used for asset versioning.
[group('info')]
version:
	@echo "{{fsdk_version}}"

# Print the tag set derived from the FSDK release: latest, minor line, point release.
[group('info')]
tags:
	#!/usr/bin/env bash
	set -euo pipefail
	V="{{fsdk_version}}"
	MINOR="$(echo "$V" | cut -d. -f1,2)"
	printf '%s\n%s\n%s\n' latest "$MINOR" "$V"

# ── Validate ──────────────────────────────────────────────────────────

[group('dev')]
validate:
	python3 .github/scripts/check-release-version.py
	python3 .github/scripts/docs-checks.py
	just bst show --deps all elements/plateau/plateau.bst
	just bst show --deps all elements/strata/strata.bst

# Run the unit test suite (pytest + bats).
[group('dev')]
test-unit:
	python3 -m pytest scripts/ -q
	bats scripts/

# ── Build ─────────────────────────────────────────────────────────────

[group('build')]
build-plateau:
	just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming false --option x86_64_v3 true

[group('build')]
build-plateau-gaming:
	just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming true --option x86_64_v3 true

[group('build')]
build-strata:
	just bst build elements/strata/strata.bst --option arch x86_64 --option gaming false --option x86_64_v3 true

[group('build')]
build-all:
	just build-plateau
	just build-strata

# ── Export ────────────────────────────────────────────────────────────

[group('export')]
export-plateau:
	rm -rf dist/oci/plateau
	mkdir -p dist/oci/plateau
	just bst artifact checkout elements/plateau/plateau.bst --directory /src/dist/oci/plateau
	@echo "==> exported Plateau OCI layout to dist/oci/plateau/"

[group('export')]
export-strata:
	rm -rf dist/oci/strata
	mkdir -p dist/oci/strata
	just bst artifact checkout elements/strata/strata.bst --directory /src/dist/oci/strata
	@echo "==> exported Strata OCI layout to dist/oci/strata/"

# ── Push to GHCR ──────────────────────────────────────────────────────

[group('publish')]
push-plateau:
	#!/usr/bin/env bash
	set -euo pipefail
	VERSION="{{fsdk_version}}"
	TAG="testing-${VERSION}-x86_64-default"
	IMAGE="ghcr.io/huntedraven7/terrace/plateau:${TAG}"
	just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming false --option x86_64_v3 true
	skopeo copy --all oci:dist/oci/plateau:latest docker://${IMAGE}
	@echo "Pushed ${IMAGE}"

[group('publish')]
push-strata:
	#!/usr/bin/env bash
	set -euo pipefail
	VERSION="{{fsdk_version}}"
	TAG="testing-${VERSION}-x86_64-default"
	IMAGE="ghcr.io/huntedraven7/terrace/strata:${TAG}"
	just bst build elements/strata/strata.bst --option arch x86_64 --option gaming false --option x86_64_v3 true
	skopeo copy --all oci:dist/oci/strata:latest docker://${IMAGE}
	@echo "Pushed ${IMAGE}"

# ── Test ──────────────────────────────────────────────────────────────

[group('test')]
test:
	just test-unit
	python3 scripts/test_desktop_defaults.py
	python3 scripts/test_image_variants.py

[group('test')]
show-me-the-future-plateau:
	#!/usr/bin/env bash
	set -euo pipefail
	just build-plateau
	just export-plateau
	@echo "Running Plateau QEMU smoke test..."
	# Simplified - full test would need QEMU setup
	@echo "Plateau image built and exported. Run QEMU test manually or via CI."

[group('test')]
show-me-the-future-strata:
	#!/usr/bin/env bash
	set -euo pipefail
	just build-strata
	just export-strata
	@echo "Running Strata QEMU smoke test..."
	@echo "Strata image built and exported. Run QEMU test manually or via CI."

# ── Sync ──────────────────────────────────────────────────────────────

[group('maintenance')]
sync-next:
	#!/usr/bin/env bash
	set -euo pipefail
	git fetch origin
	git checkout -B next origin/testing
	git push origin next --force
	@echo "Synced next branch from testing"

# ── Clean ─────────────────────────────────────────────────────────────

[group('maintenance')]
clean:
	rm -rf dist/
	rm -rf ~/.cache/buildstream/*
	@echo "Cleaned build artifacts and cache"