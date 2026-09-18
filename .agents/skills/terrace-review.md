# Terrace Review Skill

## Overview

This skill covers PR review, triage, user-donated reports, and label management for the Terrace project.

Follows the Project Bluefin Dakota seven-label issue and review workflow.

## Seven-Label Workflow

Every issue must have exactly one label from each category:

### Type (required)
- `type/feature` — New functionality
- `type/bug` — Defect fix
- `type/docs` — Documentation only
- `type/maintenance` — Refactor, cleanup, dependencies
- `type/epic` — Large multi-PR effort
- `type/kind/feature` — Feature sub-task
- `type/kind/epic` — Epic sub-task

### Status (required)
- `status/discussing` — Design discussion, needs consensus
- `status/approved` — Consensus reached, ready for build
- `status/queued` — Approved, waiting for capacity
- `status/in-progress` — Actively being worked on
- `status/review` — PR open, awaiting review
- `status/blocked` — Waiting on external dependency

### Priority (required)
- `priority/critical` — Blocks release, security
- `priority/high` — Important, next release
- `priority/medium` — Normal
- `priority/low` — Nice to have

### Area (required)
- `area/buildstream` — BST elements, junctions, build
- `area/ci` — GitHub Actions, workflows
- `area/desktop` — Plateau desktop (mango, quickshell, etc.)
- `area/server` — Strata server (k0s, kubestellar)
- `area/image` — OCI assembly, bootc, signing
- `area/docs` — Documentation
- `area/testing` — Tests, QEMU, validation
- `area/packaging` — Package builds (Go, Rust, C++)
- `area/security` — Signing, scanning, supply chain

### Platform (optional)
- `platform/x86_64`
- `platform/x86_64_v3`
- `platform/aarch64`

### Variant (optional)
- `variant/default`
- `variant/gaming`

### Kind (optional, for sub-tasks)
- `kind/feature`
- `kind/bug`
- `kind/docs`
- `kind/maintenance`

## PR Review Process

### Author Checklist
Before requesting review:
1. `just validate` passes
2. `just test-unit` passes
3. Conventional Commits format
4. `Assisted-by:` trailer on AI-authored commits
5. No `Co-authored-by:` (use `Assisted-by:`)

### Reviewer Checklist
1. Read the issue (linked in PR description)
2. Verify `just validate` in CI
3. Check element changes match issue scope
4. Validate no Containerfile package installs
5. Verify commit messages and trailers
6. Approve or request changes

### Labels on PR
- `review/needed` — Awaiting review
- `review/approved` — Approved, ready to merge
- `review/changes-requested` — Changes needed
- `do-not-merge` — Blocked, do not merge

## Triage Process

### New Issue
1. Assign seven labels (type, status, priority, area, platform?, variant?, kind?)
2. If `status/discussing` — leave for discussion
3. If `status/approved` — move to `status/queued`
4. Assign to milestone if applicable

### PR Triage
1. Validate PR title (Conventional Commits)
2. Check `just validate` in CI
3. Assign `review/needed`
4. Request review from area owner

## User-Donated Reports

Hardware reports via `ujust report`:
1. Issue created with `report/attached` label
2. Report attached as gist
3. Reviewer reads report before asking for logs
4. Hardware verification via `ujust confirm <issue>`
5. Fix verification via `ujust verify <issue>`

## Anti-patterns (DO NOT)
- ❌ Merge without seven labels
- ❌ Skip `just validate`
- ❌ Use `Co-authored-by:` instead of `Assisted-by:`
- ❌ Push directly to main/testing
- ❌ Review without reading linked issue
- ❌ Approve PR with failing CI

## Related Files
- `.github/workflows/pr-triage.yml`
- `.github/workflows/validate.yml`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/`
- `docs/pr-checklist.md`
- `docs/workflow.md`