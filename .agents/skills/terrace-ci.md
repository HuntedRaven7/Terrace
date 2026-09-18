# Terrace CI Skill

## Overview

This skill covers GitHub Actions workflows, matrix builds, CI publication, and the projectbluefin/actions integration for the Terrace project.

Terrace CI is modeled on Project Bluefin Dakota's pipeline, using the shared `projectbluefin/actions` for bootc image building, signing, and publishing.

## Workflow Architecture

### Core Workflows (`.github/workflows/`)

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `build.yml` | Push, PR, dispatch | Main build matrix (image × arch × variant) |
| `publish.yml` | Dispatch | Manual publish to GHCR |
| `execute-release.yml` | Schedule (Fri 6 AM), dispatch | Friday stable promotion |
| `validate.yml` | PR, push | Validation (bst, lint, shellcheck, pre-commit) |
| `e2e.yml` | Dispatch | QEMU boot testing |
| `vulnerability-scan.yml` | Schedule (daily), dispatch | Trivy CVE scanning |
| `publish-smoke.yml` | Workflow run (publish) | Post-publish smoke tests |
| `rollback-stable.yml` | Dispatch | Stable rollback |
| `sync-next.yml` | Schedule (daily) | Sync testing → next branch |
| `run-testsuite.yml` | PR, push, dispatch | Full test suite |
| `track-bst-sources.yml` | Schedule | Track BST source updates |

### Build Matrix
Defined in `.github/image-variants.json`:
```json
{
  "plateau": {
    "variants": ["default", "gaming"],
    "architectures": ["x86_64", "x86_64_v3"]
  },
  "strata": {
    "variants": ["default"],
    "architectures": ["x86_64", "x86_64_v3"]
  }
}
```
Total: 6 build combinations per run.

### projectbluefin/actions Integration

All build/publish workflows use these actions (pinned to `@v1`):

| Action | Purpose |
|--------|---------|
| `bootc-build/setup-runner` | Prepare runner: Podman, BTRFS, tools |
| `bootc-build/preflight` | Validate runner environment |
| `bootc-build/dnf-cache` | Restore/save DNF cache |
| `bootc-build/detect-changes` | Compute build matrix from changes |
| `bootc-build/generate-tags` | Generate OCI tags from stream/version |
| `bootc-build/push-image` | GHCR push with retry |
| `bootc-build/create-manifest` | Multi-arch manifest index |
| `bootc-build/sign-and-publish` | Cosign + SBOM + SLSA L2 |
| `bootc-build/scan-image` | Trivy CVE scan |
| `bootc-build/chunka` | Chunkah OCI rechunking |
| `bootc-build/rechunk` | rpm-ostree rechunking |
| `bootc-build/generate-release-notes` | git-cliff changelog |

### Tag Format
```
ghcr.io/huntedraven7/terrace/{plateau,strata}:{stream}-{version}-{arch}-{variant}
ghcr.io/huntedraven7/terrace/{plateau,strata}:latest-{arch}-{variant}
ghcr.io/huntedraven7/terrace/{plateau,strata}:stable-{version}-{arch}-{variant}
```

Examples:
- `ghcr.io/huntedraven7/terrace/plateau:testing-26.08.1-x86_64-default`
- `ghcr.io/huntedraven7/terrace/strata:stable-26.08.1-x86_64_v3-default`

### Stable Promotion (Friday)
1. **Schedule**: Every Friday 6 AM UTC (`execute-release.yml`)
2. **Verify**: All testing images exist and pass smoke tests
3. **Promote**: Re-tag `testing-*` → `stable-*` and `latest-*`
4. **Sign**: Cosign sign + SBOM + SLSA L2 provenance
5. **Chunkah**: OCI rechunking for delta efficiency
5. **Scan**: Trivy vulnerability scan
6. **Release**: GitHub Release with git-cliff changelog
7. **Update**: `.github/release-state.yaml` committed

### Secrets Required
| Secret | Purpose |
|--------|---------|
| `COSIGN_PASSWORD` | Cosign keyless signing password |
| `COSIGN_PRIVATE_KEY` | Cosign private key (if not keyless) |
| `GITHUB_TOKEN` | Auto-provided for GHCR push |

### Cache
BuildStream CAS caches (configured in `project.conf`):
- `https://gbm.gnome.org:11003` — GNOME BuildStream cache
- `https://cache.projectbluefin.io:11001` — Project Bluefin cache

Both used as `artifacts` and `source-caches`.

## Common Tasks

### Trigger Manual Build
```bash
gh workflow run build.yml -f image=plateau -f variant=gaming -f arch=x86_64
```

### Trigger Publish
```bash
gh workflow run publish.yml -f image=all -f stream=testing -f version=26.08.1
```

### Trigger Stable Promotion
```bash
gh workflow run execute-release.yml -f version=26.08.1
```

### View Build Logs
```bash
gh run list --workflow=build.yml --limit=10
gh run view <run-id> --log
```

### Debug Failed Build
```bash
# Re-run with debug
gh workflow run build.yml -f image=plateau -f variant=default -f arch=x86_64

# Or run locally with act
act -W .github/workflows/build.yml -j build
```

## Anti-patterns (DO NOT)
- ❌ Pin actions to mutable refs (`main`, `v1`) — use SHA for third-party
- ❌ Hardcode registry/image names — use env vars and matrix
- ❌ Skip signing for stable releases
- ❌ Disable Trivy scanning
- ❌ Use mutable tags (`latest`) for production
- ❌ Hardcode internal hostnames — use placeholders

## Related Files
- `.github/workflows/*.yml` — Workflow definitions
- `.github/image-variants.json` — Build matrix
- `.github/release-state.yaml` — Release tracking
- `.github/scripts/check-release-version.py` — Version validation
- `projectbluefin/actions` — Shared actions (external)