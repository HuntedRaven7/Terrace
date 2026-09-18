# Patch Management

## Overview

Patches in Terrace are managed via BuildStream `patch_queue` junctions, applied at the junction boundary to override upstream FSDK/GNOME components.

## Patch Structure

```
patches/
├── freedesktop-sdk/
│   ├── series                    # Ordered patch list
│   ├── 0001-fix-build.patch
│   └── ...
├── linux/
│   ├── series
│   └── ...
├── common/
│   ├── series
│   └── ...
└── shell-extensions/
    └── ...
```

## Patch Queue in Junctions

### freedesktop-sdk.bst
```yaml
sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: freedesktop-sdk-26.08*
  ref: freedesktop-sdk-26.08.1-0-gb02b59ffe19a49a402f357fd5fcb1d552ebc50d7
- kind: patch_queue
  path: patches/freedesktop-sdk
```

## Adding Patches

### 1. Create Patch
```bash
# From upstream repo
cd /path/to/freedesktop-sdk
git format-patch -1 <commit-sha> --stdout > 0001-description.patch

# Or create manually
cat > patches/freedesktop-sdk/0001-fix-something.patch << 'EOF'
From: Name <email@example.com>
Date: 2026-01-01
Subject: [PATCH] Fix something

---
 component/something.bst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/component/something.bst b/component/something.bst
index abcdef..123456 100644
--- a/component/something.bst
+++ b/component/something.bst
@@ -1,3 +1,4 @@
 kind: manual
+depends: []
 config:
   install-commands:
-    - echo "old"
+    - echo "new"
EOF
```

### 2. Add to Series
```bash
# Edit patches/freedesktop-sdk/series
echo "0001-fix-something.patch" >> patches/freedesktop-sdk/series
```

### 3. Order Matters
Patches apply in series order. Dependencies between patches must be ordered correctly.

## Common Patch Types

### FSDK Overrides
- Fix build failures in FSDK components
- Update component versions
- Add missing dependencies

### Kernel Patches
- Hardware support (NVIDIA, specific drivers)
- Security backports
- Config changes

### GNOME/GTK Patches
- Theme fixes
- Extension compatibility
- Version alignment

## Patch Best Practices

1. **Minimal scope** — One logical change per patch
2. **Upstreamable** — Write patches that could be upstreamed
3. **Documented** — Clear commit message with rationale
4. **Tested** — Verify patch applies cleanly
5. **Ordered** — Dependencies first in series

## Anti-patterns (DO NOT)
- ❌ Edit staged junction contents directly
- ❌ Apply patches outside patch_queue
- ❌ Skip series file
- ❌ Large multi-purpose patches
- ❌ Patches that break other components

## Verification

```bash
# Test patch applies
just bst source checkout freedesktop-sdk.bst
# Check patches/freedesktop-sdk/ applied

# Build with patches
just validate
just build-plateau
```

## Related Files
- `elements/freedesktop-sdk.bst` (patch_queue source)
- `patches/freedesktop-sdk/series`
- `patches/linux/series`
- `project.conf` (patch plugin)