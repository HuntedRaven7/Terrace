# Contributing to Terrace

## Welcome

Thank you for contributing to Terrace! This document outlines the workflow for contributors.

## Getting Started

1. Read [AGENTS.md](AGENTS.md) for the full agent guide
2. Read [docs/workflow.md](docs/workflow.md) for the development workflow
3. Read [docs/pr-checklist.md](docs/pr-checklist.md) for the PR checklist
4. Check [open issues](https://github.com/huntedraven7/terrace/issues) for work

## Issue Labels

Every issue must have seven labels (one from each category):
- **Type**: `type/feature`, `type/bug`, `type/docs`, `type/maintenance`, `type/epic`
- **Status**: `status/discussing`, `status/approved`, `status/queued`, `status/in-progress`, `status/review`, `status/blocked`
- **Priority**: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
- **Area**: `area/buildstream`, `area/ci`, `area/desktop`, `area/server`, `area/image`, `area/docs`, `area/testing`, `area/packaging`, `area/security`
- **Platform** (optional): `platform/x86_64`, `platform/x86_64_v3`, `platform/aarch64`
- **Variant** (optional): `variant/default`, `variant/gaming`
- **Kind** (optional): `kind/feature`, `kind/bug`, `kind/docs`, `kind/maintenance`

## Branch & Commit

- Branch from `upstream/testing`
- Use Conventional Commits: `type(scope): description`
- Add `Assisted-by: <Model> via GitHub Copilot` trailer on AI-authored commits
- Never use `Co-authored-by:`
- Stage selectively with `git add -p`, never `git add -A`

## Validation

Before submitting:
```bash
just validate
just test-unit
```

## PR Process

1. Link issue in PR description
2. Wait for CI (`just validate`, tests)
3. Address review feedback
4. Maintainer merges when approved

## Code Style

- Follow existing patterns in the codebase
- Use BuildStream for all package builds
- No Containerfile package installation
- Deterministic builds (no network, timestamps, hostnames)
- Pin all sources to commit SHAs

## Security

- Never commit secrets
- Report vulnerabilities via [SECURITY.md](SECURITY.md)
- All releases are signed with cosign + SBOM + SLSA L2