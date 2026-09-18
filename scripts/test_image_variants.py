#!/usr/bin/env python3
"""
Test script to verify image variant matrix
"""
import json
import sys
import subprocess

def test_image_variants():
    """Test that image variants are correctly defined"""
    with open('.github/image-variants.json') as f:
        variants = json.load(f)

    assert 'plateau' in variants
    assert 'strata' in variants
    assert 'default' in variants['plateau']['variants']
    assert 'gaming' in variants['plateau']['variants']
    assert 'default' in variants['strata']['variants']
    print("✓ image-variants.json verified")

def test_project_conf_options():
    """Test that project.conf has correct options"""
    with open('project.conf') as f:
        content = f.read()
    assert 'x86_64_v3' in content
    assert 'gaming' in content
    print("✓ project.conf options verified")

def main():
    tests = [
        test_image_variants,
        test_project_conf_options,
    ]

    failed = []
    for test in tests:
        try:
            test()
        except AssertionError as e:
            print(f"✗ {test.__name__}: {e}")
            failed.append(test.__name__)
        except Exception as e:
            print(f"✗ {test.__name__}: {e}")
            failed.append(test.__name__)

    if failed:
        print(f"\n{len(failed)} test(s) failed: {', '.join(failed)}")
        sys.exit(1)
    else:
        print(f"\nAll {len(tests)} tests passed!")
        sys.exit(0)

if __name__ == '__main__':
    main()