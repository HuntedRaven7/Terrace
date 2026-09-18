# PR Checklist

## Before Submitting

### Code Quality
- [ ] `just validate` passes locally
- [ ] `just test-unit` passes locally
- [ ] No new shellcheck warnings
- [ ] No new hadolint warnings
- [ ] Pre-commit hooks pass
- [ ] Conventional Commits format for all commits
- [ ] `Assisted-by:` trailer on AI-authored commits
- [ ] No `Co-authored-by:` trailers

### Scope
- [ ] Changes match issue scope
- [ ] Single logical change per PR
- [ ] No unrelated refactoring
- [ ] No Containerfile package installs
- [ ] No mutable refs (branches) in elements

### Testing
- [ ] Build succeeds for affected images
- [ ] `just validate` in CI passes
- [ ] E2E test considered (if image change)
- [ ] Version consistency check passes

### Documentation
- [ ] Relevant docs updated (if user-facing change)
- [ ] Skill docs updated (if agent-relevant)
- [ ] CHANGELOG entry (if applicable)

### Security
- [ ] No secrets in code/config
- [ ] No weakened signing/provenance
- [ ] Supply chain checks preserved

## Review Process

### Author
1. Self-review diff
2. Run `just validate`
3. Link issue in PR description
4. Request review from area owner

### Reviewer
1. Read linked issue
2. Verify CI passes (`just validate`)
3. Check element changes match scope
4. Validate commit messages/trailers
5. Approve or request changes

### Merge
1. All CI green
2. At least one approval
3. No `do-not-merge` or `review/changes-requested`
4. Squash and merge (or rebase)
5. Delete branch

## Issue Labels (Seven-Label Rule)

Every issue must have exactly one from each:
- [ ] **Type**: `type/feature`, `type/bug`, `type/docs`, `type/maintenance`, `type/epic`, `type/kind/feature`, `type/kind/epic`
- [ ] **Status**: `status/discussing`, `status/approved`, `status/queued`, `status/in-progress`, `status/review`, `status/blocked`
- [ ] **Priority**: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
- [ ] **Area**: `area/buildstream`, `area/ci`, `area/desktop`, `area/server`, `area/image`, `area/docs`, `area/testing`, `area/packaging`, `area/security`
- [ ] **Platform** (optional): `platform/x86_64`, `platform/x86_64_v3`, `platform/aarch64`
- [ ] **Variant** (optional): `variant/default`, `variant/gaming`
- [ ] **Kind** (optional, sub-tasks): `kind/feature`, `kind/bug`, `kind/docs`, `kind/maintenance`

## Common Rejection Reasons

- ❌ Missing seven labels
- ❌ `just validate` fails
- ❌ Containerfile package installation
- ❌ Mutable refs in BST elements
- ❌ Unrelated changes bundled
- ❌ Missing `Assisted-by:` on AI commits
- ❌ Secrets in diff
- ❌ No issue linked