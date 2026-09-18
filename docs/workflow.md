# Development Workflow

## Branch Strategy

- **main** — Stable release branch (protected)
- **testing** — Development branch (default for PRs)
- **next** — Bleeding edge (auto-synced from testing daily)
- **feature/** — Feature branches from testing

## Contributing

### 1. Fork & Clone
```bash
git clone https://github.com/huntedraven7/terrace.git
cd terrace
git remote add upstream https://github.com/huntedraven7/terrace.git
```

### 2. Create Branch
```bash
git fetch upstream
git checkout -b feature/my-change upstream/testing
```

### 3. Make Changes
- Edit BST elements in `elements/`
- Edit configs in `include/`, `files/`
- Add tests in `scripts/`

### 4. Validate Locally
```bash
just validate
just test-unit
```

### 5. Commit
```bash
git add -p  # Stage selectively, never git add -A
git commit -m "type(scope): description"
# Add trailer:
# Assisted-by: <Model> via GitHub Copilot
```

### 6. Push & PR
```bash
git push origin feature/my-change
gh pr create --base testing --title "type(scope): description" --body "Fixes #123"
```

### 7. CI & Review
- Wait for CI (`just validate`, tests)
- Address review feedback
- Maintainer merges when approved

## Commit Conventions

### Format
```
<type>(<scope>): <description>

[optional body]

Assisted-by: <Model> via GitHub Copilot
```

### Types
- `feat` — New feature
- `fix` — Bug fix
- `docs` — Documentation
- `ci` — CI/CD changes
- `chore` — Maintenance
- `refactor` — Code restructuring
- `test` — Test changes
- `build` — Build system

### Scopes
- `bst` — BuildStream elements
- `ci` — GitHub Actions
- `plateau` — Desktop image
- `strata` — Server image
- `pkg` — Packaging
- `docs` — Documentation

### Examples
```
feat(plateau): add mango 0.17.2 support
fix(bst): correct freedesktop-sdk junction ref
docs(ci): update workflow documentation
ci(release): add friday promotion schedule
```

## Code Review

### Seven-Label Rule
Every issue must have one label from each category (type, status, priority, area, platform?, variant?, kind?).

### Review Checklist
- [ ] Issue linked in PR
- [ ] `just validate` passes
- [ ] Changes match issue scope
- [ ] Commit format correct
- [ ] `Assisted-by:` trailer present
- [ ] No secrets in diff
- [ ] Tests updated if needed

## Release Process

### Automated (Friday)
1. `execute-release.yml` runs at 6 AM UTC
2. Verifies testing images exist
3. Runs smoke tests
4. Promotes testing → stable + latest
5. Signs with cosign + SBOM + SLSA
6. Chunkah rechunking
7. Trivy scan
8. Creates GitHub Release
9. Updates release-state.yaml

### Manual
```bash
# Promote specific version
gh workflow run execute-release.yml -f version=26.08.1

# Rollback
gh workflow run rollback-stable.yml -f version=26.08.0

# Publish manual
gh workflow run publish.yml -f image=all -f stream=testing -f version=26.08.1
```

## Anti-patterns
- ❌ Push directly to main/testing
- ❌ Use `git add -A` or `git add .`
- ❌ `Co-authored-by:` instead of `Assisted-by:`
- ❌ Merge without CI green
- ❌ Bundle unrelated changes
- ❌ Skip `just validate`