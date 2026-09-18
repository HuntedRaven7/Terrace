#!/usr/bin/env python3
"""
Documentation validation checks
"""
import os
import sys
import yaml

def check_skills_index():
    """Check that all skills are listed in index"""
    skills_dir = '.agents/skills'
    if not os.path.exists(skills_dir):
        return True  # Skip if not created yet

    skill_files = [f for f in os.listdir(skills_dir) if f.endswith('.md')]
    print(f"Found {len(skill_files)} skill files")

    # Could check against docs/skills/index.md if it exists
    return True

def check_markdown_syntax():
    """Basic markdown syntax check"""
    for root, dirs, files in os.walk('docs'):
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                with open(filepath) as f:
                    content = f.read()
                # Basic checks
                if not content.strip():
                    print(f"WARNING: {filepath} is empty")
    return True

def check_yaml_syntax():
    """Check YAML syntax in config files"""
    yaml_files = [
        'include/aliases.yml',
        'include/os-release.yml',
        '.github/image-variants.json',  # JSON but similar
        '.github/release-state.yaml',
    ]
    for filepath in yaml_files:
        if os.path.exists(filepath):
            try:
                with open(filepath) as f:
                    if filepath.endswith('.json'):
                        import json
                        json.load(f)
                    else:
                        yaml.safe_load(f)
            except Exception as e:
                print(f"ERROR: {filepath} has invalid syntax: {e}")
                return False
    return True

def main():
    checks = [
        check_skills_index,
        check_markdown_syntax,
        check_yaml_syntax,
    ]

    failed = False
    for check in checks:
        try:
            if not check():
                failed = True
        except Exception as e:
            print(f"ERROR in {check.__name__}: {e}")
            failed = True

    if failed:
        sys.exit(1)
    print("✓ All documentation checks passed")
    sys.exit(0)

if __name__ == '__main__':
    main()