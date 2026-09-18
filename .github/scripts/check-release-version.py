#!/usr/bin/env python3
"""
Check that release version matches FSDK pin in freedesktop-sdk.bst
"""
import re
import sys

def extract_fsdk_version():
    """Extract FSDK version from freedesktop-sdk.bst"""
    with open('elements/freedesktop-sdk.bst') as f:
        content = f.read()

    # Match ref: freedesktop-sdk-26.08.1-...
    match = re.search(r'ref:\s*freedesktop-sdk-(\d+\.\d+\.\d+)', content)
    if match:
        return match.group(1)
    return None

def check_version_consistency():
    """Check that version is consistent across files"""
    fsdk_version = extract_fsdk_version()
    if not fsdk_version:
        print("ERROR: Could not extract FSDK version from freedesktop-sdk.bst")
        return False

    print(f"FSDK version from freedesktop-sdk.bst: {fsdk_version}")

    # Check project.conf
    with open('project.conf') as f:
        content = f.read()
    # Version should be derivable from fsdk_version

    # Check os-release.yml
    with open('include/os-release.yml') as f:
        content = f.read()
    if f'VERSION_ID: "{fsdk_version}"' not in content:
        print(f"ERROR: os-release.yml VERSION_ID doesn't match FSDK version ({fsdk_version})")
        return False

    print("✓ Version consistency check passed")
    return True

def main():
    if not check_version_consistency():
        sys.exit(1)
    sys.exit(0)

if __name__ == '__main__':
    main()