#!/usr/bin/env python3
"""
Test script to verify Plateau desktop defaults
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
    assert 'VARIANT_ID="plateau"' in content
    print("✓ os-release verified")

def test_mango_installed():
    """Test that mango is installed"""
    result = subprocess.run(['which', 'mango'], capture_output=True)
    assert result.returncode == 0, "mango not found in PATH"
    print("✓ mango installed")

def test_quickshell_installed():
    """Test that quickshell is installed"""
    result = subprocess.run(['which', 'quickshell'], capture_output=True)
    assert result.returncode == 0, "quickshell not found in PATH"
    print("✓ quickshell installed")

def test_rofi_installed():
    """Test that rofi is installed"""
    result = subprocess.run(['which', 'rofi'], capture_output=True)
    assert result.returncode == 0, "rofi not found in PATH"
    print("✓ rofi installed")

def test_awww_installed():
    """Test that awww is installed"""
    result = subprocess.run(['which', 'awww'], capture_output=True)
    assert result.returncode == 0, "awww not found in PATH"
    print("✓ awww installed")

def test_pipewire_installed():
    """Test that pipewire is installed"""
    result = subprocess.run(['which', 'pipewire'], capture_output=True)
    assert result.returncode == 0, "pipewire not found in PATH"
    print("✓ pipewire installed")

def test_wireplumber_installed():
    """Test that wireplumber is installed"""
    result = subprocess.run(['which', 'wireplumber'], capture_output=True)
    assert result.returncode == 0, "wireplumber not found in PATH"
    print("✓ wireplumber installed")

def test_wlclipboard_installed():
    """Test that wlclipboard is installed"""
    for cmd in ['wl-copy', 'wl-paste', 'wl-move']:
        result = subprocess.run(['which', cmd], capture_output=True)
        assert result.returncode == 0, f"{cmd} not found in PATH"
    print("✓ wlclipboard installed")

def test_systemd_services():
    """Test that required systemd services are enabled"""
    services = [
        'NetworkManager.service',
        'dbus-broker.service',
        'pipewire.service',
        'wireplumber.service',
        'polkit.service',
    ]
    for service in services:
        result = subprocess.run(['systemctl', 'is-enabled', service], capture_output=True)
        assert result.returncode == 0, f"{service} is not enabled"
    print("✓ systemd services enabled")

def test_dconf_defaults():
    """Test dconf defaults"""
    # This would run in a graphical session
    # For now, just check the file exists
    dconf_file = '/etc/dconf/db/local.d/99-terrace-desktop'
    assert os.path.exists(dconf_file), f"{dconf_file} not found"
    print("✓ dconf defaults file exists")

def test_wayland_sessions():
    """Test Wayland session files exist"""
    sessions = ['/usr/share/wayland-sessions/mango.desktop', '/usr/share/wayland-sessions/quickshell.desktop']
    for session in sessions:
        assert os.path.exists(session), f"{session} not found"
    print("✓ Wayland sessions exist")

def main():
    """Run all tests"""
    tests = [
        test_os_release,
        test_mango_installed,
        test_quickshell_installed,
        test_rofi_installed,
        test_awww_installed,
        test_pipewire_installed,
        test_wireplumber_installed,
        test_wlclipboard_installed,
        test_systemd_services,
        test_dconf_defaults,
        test_wayland_sessions,
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