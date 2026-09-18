#!/bin/bash
# Firstboot setup for Plateau desktop

set -euo pipefail

echo "Running Plateau firstboot setup..."

# Update font cache
fc-cache -f -v

# Update GTK icon cache
gtk-update-icon-cache -f /usr/share/icons/Adwaita || true
gtk-update-icon-cache -f /usr/share/icons/hicolor || true

# Update desktop database
update-desktop-database /usr/share/applications || true

# Update MIME database
update-mime-database /usr/share/mime || true

# Set up user directories
xdg-user-dirs-update || true

# Mark firstboot as complete
touch /var/lib/terrace/firstboot-complete

echo "Plateau firstboot setup complete."