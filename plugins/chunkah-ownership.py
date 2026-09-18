#!/usr/bin/env python3
"""
Chunkah Ownership Plugin for BuildStream

Records public staging results while preserving BuildStream compose filtering
and integration semantics.
"""

import os
import json
import subprocess
import hashlib
from pathlib import Path

class ChunkahOwnershipPlugin:
    """BuildStream plugin for chunkah ownership tracking."""

    def __init__(self, config):
        self.config = config
        self.ownership_dir = Path(config.get('ownership_dir', '/var/cache/chunkah/ownership'))

    def record_ownership(self, element_name, artifact_path):
        """Record ownership metadata for an artifact."""
        self.ownership_dir.mkdir(parents=True, exist_ok=True)

        # Calculate artifact hash
        sha256 = hashlib.sha256()
        with open(artifact_path, 'rb') as f:
            for chunk in iter(lambda: f.read(8192), b''):
                sha256.update(chunk)

        ownership_data = {
            'element': element_name,
            'artifact': str(artifact_path),
            'sha256': sha256.hexdigest(),
            'timestamp': subprocess.check_output(['date', '-u', '+%Y-%m-%dT%H:%M:%SZ']).decode().strip(),
            'hostname': subprocess.check_output(['hostname']).decode().strip(),
        }

        ownership_file = self.ownership_dir / f"{element_name.replace('/', '_')}.json"
        with open(ownership_file, 'w') as f:
            json.dump(ownership_data, f, indent=2)

        return ownership_data

    def get_ownership(self, element_name):
        """Get ownership metadata for an element."""
        ownership_file = self.ownership_dir / f"{element_name.replace('/', '_')}.json"
        if ownership_file.exists():
            with open(ownership_file) as f:
                return json.load(f)
        return None

def main():
    import sys
    if len(sys.argv) < 3:
        print("Usage: chunkah-ownership.py <record|get> <element_name> [artifact_path]")
        sys.exit(1)

    action = sys.argv[1]
    element_name = sys.argv[2]

    plugin = ChunkahOwnershipPlugin({})

    if action == 'record':
        if len(sys.argv) < 4:
            print("record action requires artifact_path")
            sys.exit(1)
        artifact_path = sys.argv[3]
        data = plugin.record_ownership(element_name, artifact_path)
        print(json.dumps(data))
    elif action == 'get':
        data = plugin.get_ownership(element_name)
        if data:
            print(json.dumps(data))
        else:
            print("{}")
    else:
        print(f"Unknown action: {action}")
        sys.exit(1)

if __name__ == '__main__':
    main()