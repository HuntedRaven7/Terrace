# Terrace Agent Guide

## Overview

Terrace is a BuildStream 2 factory for Free Desktop SDK bootc images, producing two OCI images:

- **Plateau** — Desktop image (Mango WM + Quickshell shell)
- **Strata** — Server image (k0s sysext + Kubestellar)

Assembled entirely from source with BuildStream 2 from freedesktop-sdk (FSDK 26.08). This is not an RPM-based image: do not use `dnf`, `rpm-ostree`, COPRs, Containerfile package overlays, or post-build package installation. Make image changes through BST elements.

Project skills live in `.agents/skills/` and are discovered by agents. Load only the skill matching the task; do not read every skill.

## Factory Model Invariants

- **Scoped Documentation**: Correct durable, task-relevant guidance when the work reveals an error or missing constraint. Do not manufacture documentation changes for every session or expand a read-only task into writes. Preparing changes does not authorize committing or publishing them.
- **Docs Are the Model**: Skills and documentation are evergreen operating procedures. Never append dated session logs, running issue numbers, or resolved checklists. Codify learnings as timeless architectural invariants and failure modes.
- **Documentation Freshness**: Verify external syntax against current official documentation and cite the source when updating guidance. Direct official documentation is equally valid.

## Skill Routing

| Task / Domain | Skill to Load |
|---------------|---------------|
| BST elements, junctions, patches, or build graph errors | `terrace-buildstream` |
| GitHub Actions workflows, matrix builds, CI publication | `terrace-ci` |
| GNOME Shell extensions, ESM modules, dconf defaults | `terrace-extensions` |
| Task-relevant documentation corrections and skill audits | `terrace-factory` |
| OCI layer composition, boot testing, VM checks, OTA | `terrace-image` |
| Native Go, Rust, Zig, C, or binary packaging in BST | `terrace-packaging` |
| Stable promotion, image signing, cosign, rollback | `terrace-release` |
| Reviewing PRs, triage, user-donated reports, labels | `terrace-review` |
| End-user recipes in `files/just-overrides/default.just` | `terrace-ujust` |
| Host Homebrew prefix, GCC/Make invariants, services | `terrace-workstation` |

## Non-Negotiable Safety

- **Never write to any `huntedraven7/terrace` repository without explicit human approval.** No issues, comments, PRs, forks, dispatches, webhooks, or automated reports without asking.
- Do not post GitHub comments, reviews, or edit PR bodies unless explicitly asked. When asked, post at most one combined comment and do not restate UI status.
- Never expose secrets or weaken signing, provenance, or supply-chain checks.
- Never push directly to `main` or `testing`. Work on a feature branch and leave final approval and merge to a human.

## Sources of Truth

1. Read the file being changed and its callers before editing it.
2. Use the relevant `.agents/skills/` package for task-specific guidance.
3. Treat workflows, elements, the Justfile, and tests as current truth; prose that disagrees with executable configuration is stale.
4. Verify external syntax and behavior in current official documentation before changing BuildStream, bootc, GitHub Actions, cosign, or skopeo usage.
5. Preserve useful knowledge by correcting existing guidance. Do not append dated session notes, changelogs, or mandatory "lessons learned" entries.

## Development Workflow

- Branch from `upstream/testing` unless the task explicitly targets `next`.
- Push PR branches to `upstream`, never a personal fork.
- Run `just --list` before inventing maintenance commands. Add a Justfile recipe when a repeatable repository operation has no existing entry.
- Run `just validate` for BST or image changes. Use the narrowest additional check that exercises the change; CI performs full image verification.
- Before claiming completion, inspect the diff and report the checks actually run. Do not claim CI is green while runs are pending or failing.

## Architecture Invariants

- BuildStream elements are the only package/build mechanism.
- OCI filesystem-producing layers use `kind: compose`; `kind: stack` only aggregates dependencies and produces no filesystem output.
- Cargo source blocks are generated with `python3 files/scripts/generate_cargo_sources.py <Cargo.lock>`.
- Patch junctions through `patch_queue`; do not edit staged junction contents.
- Keep install commands deterministic: no network access, timestamps, hostname, user identity, or mutable branch refs.
- Internal `projectbluefin/actions@v1` references are managed tags. Pin other third-party actions to full commit SHAs with a version comment.
- `main` is the stable-release bookmark. Do not add an e2e gate to stable promotion; preserve freshness locking, cosign verification, and digest checks.

## Human Decision Gates

Stop and ask before:

- Architecture or new-subsystem decisions;
- User-visible behavior changes without agreed acceptance criteria;
- Authentication, signing, secrets, or third-party supply-chain changes;
- Cross-repository breaking changes;
- Final PR approval or merge.

## GitHub Workflow

- Work from scoped, queued issues; respect `hold`, `do-not-merge`, and existing ownership.
- If an issue says `report: attached`, read the donated report before asking for more logs. Hardware verification is not interchangeable with CI.
- Follow `docs/workflow.md` and `docs/pr-checklist.md` when preparing or reviewing a PR.
- Commits use `<type>(<scope>): <description>` and the repo-local `Assisted-by:` trailer, never `Co-authored-by:`.

## Project-Specific Context

### Images
- **Plateau**: Desktop, Mango 0.17.2 + Quickshell 0.3.1, Rofi, Awww 0.12.1, PipeWire, wlclipboard
- **Strata**: Server, k0s sysext, Kubestellar, ucore-base (uutils-coreutils), systemd-sysupdate

### Build Options
- `arch`: x86_64 (default)
- `x86_64_v3`: true (default, per user request)
- `gaming`: false (default), true enables NVIDIA + OGC kernel

### Registry
- `ghcr.io/huntedraven7/terrace/plateau:26.08.1`
- `ghcr.io/huntedraven7/terrace/strata:26.08.1`
- Stable promotion every Friday via `execute-release.yml`

### Cache
- GNOME BuildStream CAS: `https://gbm.gnome.org:11003`
- Project Bluefin Cache: `https://cache.projectbluefin.io:11001`

### FSDK Pin
- `freedesktop-sdk-26.08.1` (same as Dakota)
- Extracted from `elements/freedesktop-sdk.bst` ref