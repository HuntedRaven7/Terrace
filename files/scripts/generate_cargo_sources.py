#!/usr/bin/env python3
"""
Generate cargo sources for BuildStream cargo2 elements.

Usage: python3 generate_cargo_sources.py <Cargo.lock>
"""
import json
import sys
import subprocess
from pathlib import Path

def parse_cargo_lock(lock_file):
    """Parse Cargo.lock and extract package information."""
    result = subprocess.run(
        ['cargo', 'metadata', '--format-version=1', '--locked'],
        capture_output=True, text=True, check=True
    )
    return json.loads(result.stdout)

def generate_sources(metadata):
    """Generate BST cargo2 sources format."""
    packages = metadata['packages']
    sources = []

    for pkg in packages:
        if pkg['source'] is None:
            continue  # Local package

        # Extract crate name and version from source
        # Source format: "registry+https://github.com/rust-lang/crates.io-index#..."
        source = pkg['source']
        if 'registry+' in source:
            # This is a crates.io package
            name = pkg['name']
            version = pkg['version']
            # We would need to compute the checksum
            # For now, just output the structure
            sources.append({
                'name': name,
                'version': version,
                'registry': 'crates.io'
            })

    return sources

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate_cargo_sources.py <Cargo.lock>")
        sys.exit(1)

    lock_file = sys.argv[1]
    if not Path(lock_file).exists():
        print(f"Error: {lock_file} not found")
        sys.exit(1)

    metadata = parse_cargo_lock(lock_file)
    sources = generate_sources(metadata)

    # Output as JSON for BST consumption
    print(json.dumps(sources, indent=2))

if __name__ == '__main__':
    main()