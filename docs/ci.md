# CI Pipeline

## Overview

Terrace uses GitHub Actions for CI/CD, modeled on Project Bluefin Dakota's pipeline with `projectbluefin/actions` integration.

## Workflows

### Build (`build.yml`)
**Trigger**: Push to main/testing, PR, manual dispatch
**Matrix**: 6 combinations (2 images × 2 arches × 2 variants, minus strata-gaming)
**Steps**:
1. Detect changes → compute build matrix
2. Setup runner (Podman, tools)
3. Restore DNF cache
4. Build image via BuildStream
5. Save DNF cache
6. Generate tags
7. Push to GHCR (non-PR)
8. Create multi-arch manifest
9. Sign + SBOM + SLSA (main branch)
10. Chunkah rechunking
11. Trivy scan
12. Upload artifacts

### Publish (`publish.yml`)
**Trigger**: Manual dispatch
**Purpose**: Publish existing images to different stream (testing/stable)
**Steps**: Pull → Retag → Push → Manifest → Sign → Chunkah → Scan

### Execute Release (`execute-release.yml`)
**Trigger**: Schedule (Friday 6 AM UTC), manual dispatch
**Purpose**: Promote testing → stable
**Steps**:
1. Verify testing images exist
2. Run smoke tests
3. Re-tag testing → stable + latest
4. Cosign sign + SBOM + SLSA L2
5. Chunkah rechunking
6. Trivy scan
7. Generate release notes (git-cliff)
8. Create GitHub Release
9. Update release-state.yaml

### Validate (`validate.yml`)
**Trigger**: PR, push to main/testing
**Steps**:
1. `just validate` (BST graph)
2. `check-release-version.py` (version consistency)
3. `docs-checks.py` (documentation)
4. Shellcheck (all .sh files)
5. Hadolint (Containerfile)
6. Pre-commit hooks
7. BST dependency validation

### E2E Tests (`e2e.yml`)
**Trigger**: Manual dispatch
**Matrix**: plateau/strata × x86_64/x86_64_v3
**Steps**:
1. Pull testing image
2. QEMU boot test (`show-me-the-future`)
3. Run image-specific tests

### Vulnerability Scan (`vulnerability-scan.yml`)
**Trigger**: Daily 2 AM UTC, manual dispatch
**Matrix**: plateau/strata × testing/stable
**Steps**: Trivy scan → Upload SARIF → Auto-file issues

### Publish Smoke (`publish-smoke.yml`)
**Trigger**: Successful publish workflow
**Steps**: Pull published images → QEMU smoke test

### Rollback Stable (`rollback-stable.yml`)
**Trigger**: Manual dispatch
**Steps**: Re-tag previous stable → Sign → Update release-state

### Sync Next (`sync-next.yml`)
**Trigger**: Daily 4 AM UTC, manual dispatch
**Steps**: Sync testing → next branch → Trigger next build

### Run Test Suite (`run-testsuite.yml`)
**Trigger**: PR, push, manual dispatch
**Steps**:
1. Unit tests (pytest + bats)
2. Desktop defaults test
3. Image variants test
4. Ownership tests
5. Render card test
6. OCI layer comparison

## Secrets

| Secret | Used By | Purpose |
|--------|---------|---------|
| `GITHUB_TOKEN` | All | Auto-provided, GHCR push |
| `COSIGN_PASSWORD` | sign-and-publish | Cosign keyless signing |
| `COSIGN_PRIVATE_KEY` | sign-and-publish | Cosign key (if not keyless) |

## Cache

BuildStream CAS caches (from `project.conf`):
- `https://gbm.gnome.org:11003` — GNOME cache
- `https://cache.projectbluefin.io:11001` — Bluefin cache

DNF cache per image/arch/variant via `dnf-cache` action.

## Tag Format

```
ghcr.io/huntedraven7/terrace/{plateau,strata}:{stream}-{version}-{arch}-{variant}
ghcr.io/huntedraven7/terrace/{plateau,strata}:latest-{arch}-{variant}
ghcr.io/huntedraven7/terrace/{plateau,strata}:stable-{version}-{arch}-{variant}
```

## Status Badges

Add to README:
```markdown
![Build](https://github.com/huntedraven7/terrace/workflows/Build/badge.svg)
![Validate](https://github.com/huntedraven7/terrace/workflows/Validate/badge.svg)
![Vulnerability Scan](https://github.com/huntedraven7/terrace/workflows/Vulnerability%20Scan/badge.svg)
```