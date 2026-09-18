# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 26.08.x | Yes |

## Reporting a Vulnerability

**Do not report security vulnerabilities via public GitHub issues.**

Instead, please report them via the GitHub Security Advisory feature:
1. Go to the [Security tab](https://github.com/huntedraven7/terrace/security)
2. Click "Report a vulnerability"
3. Fill in the details

We will acknowledge receipt within 48 hours and provide a timeline for fix.

## Supply Chain Security

Terrace images include:
- **Cosign signatures** on all stable releases
- **SBOM** (Software Bill of Materials) via syft
- **SLSA Build L2** provenance attestations
- **Trivy vulnerability scans** on every build
- **Chunkah OCI rechunking** for verified layer integrity

## Verification

```bash
# Verify cosign signature
cosign verify ghcr.io/huntedraven7/terrace/plateau:stable-26.08.1-x86_64-default \
  --certificate-identity-regexp "https://github.com/huntedraven7/terrace" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com"

# Download SBOM
cosign download sbom ghcr.io/huntedraven7/terrace/plateau:stable-26.08.1-x86_64-default

# Verify SLSA provenance
cosign verify-attestation --type slsaprovenance \
  ghcr.io/huntedraven7/terrace/plateau:stable-26.08.1-x86_64-default
```

## Build Integrity

- All builds run in GitHub Actions with pinned action SHAs
- BuildStream CAS caches are read-only in CI
- No network access during build commands
- Deterministic, reproducible builds from pinned sources