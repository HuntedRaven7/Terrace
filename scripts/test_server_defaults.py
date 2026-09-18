#!/usr/bin/env python3
"""
Test script to verify Strata server defaults
"""
import os
import sys
import subprocess

def test_os_release():
    """Test that os-release has correct values"""
    with open('/etc/os-release') as f:
        content = f.read()
    assert 'ID="terrace"' in content
    assert 'VERSION_ID="26.08.1"' in content
    assert 'VARIANT_ID="strata"' in content
    print("✓ os-release verified")

def test_k0s_installed():
    """Test that k0s is installed"""
    result = subprocess.run(['which', 'k0s'], capture_output=True)
    assert result.returncode == 0, "k0s not found in PATH"
    print("✓ k0s installed")

def test_kubestellar_installed():
    """Test that kubestellar is installed"""
    result = subprocess.run(['which', 'kubestellar'], capture_output=True)
    assert result.returncode == 0, "kubestellar not found in PATH"
    print("✓ kubestellar installed")

def test_kubectl_installed():
    """Test that kubectl is installed"""
    result = subprocess.run(['which', 'kubectl'], capture_output=True)
    assert result.returncode == 0, "kubectl not found in PATH"
    print("✓ kubectl installed")

def test_helm_installed():
    """Test that helm is installed"""
    result = subprocess.run(['which', 'helm'], capture_output=True)
    assert result.returncode == 0, "helm not found in PATH"
    print("✓ helm installed")

def test_podman_installed():
    """Test that podman is installed"""
    result = subprocess.run(['which', 'podman'], capture_output=True)
    assert result.returncode == 0, "podman not found in PATH"
    print("✓ podman installed")

def test_systemd_services():
    """Test that required systemd services are enabled"""
    services = [
        'NetworkManager.service',
        'dbus-broker.service',
        'terrace-server-setup.service',
        'systemd-sysupdate.service',
    ]
    for service in services:
        result = subprocess.run(['systemctl', 'is-enabled', service], capture_output=True)
        assert result.returncode == 0, f"{service} is not enabled"
    print("✓ systemd services enabled")

def test_ssh_disabled():
    """Test that SSH is disabled by default"""
    result = subprocess.run(['systemctl', 'is-enabled', 'sshd.service'], capture_output=True)
    # Should be disabled (non-zero exit) or masked
    assert result.returncode != 0, "sshd should be disabled by default"
    print("✓ SSH disabled by default")

def test_uutils_coreutils():
    """Test that uutils-coreutils is available"""
    result = subprocess.run(['which', 'coreutils'], capture_output=True)
    # uutils-coreutils provides coreutils
    assert result.returncode == 0, "coreutils not found"
    print("✓ uutils-coreutils available")

def test_container_tools():
    """Test container tools"""
    tools = ['buildah', 'skopeo', 'crun', 'runc']
    for tool in tools:
        result = subprocess.run(['which', tool], capture_output=True)
        assert result.returncode == 0, f"{tool} not found in PATH"
    print("✓ container tools installed")

def main():
    """Run all tests"""
    tests = [
        test_os_release,
        test_k0s_installed,
        test_kubestellar_installed,
        test_kubectl_installed,
        test_helm_installed,
        test_podman_installed,
        test_systemd_services,
        test_ssh_disabled,
        test_uutils_coreutils,
        test_container_tools,
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