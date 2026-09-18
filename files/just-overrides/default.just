# Default justfile overrides for Plateau desktop
# These are applied on top of the base justfile

# Plateau-specific commands
plateau-shell:
	@echo "Starting Plateau desktop session..."
	@mango

plateau-quickshell:
	@echo "Starting Quickshell session..."
	@quickshell

# Development helpers
dev-shell:
	@echo "Entering development shell..."
	@bash

# Image management
image-info:
	@bootc status
	@echo ""
	@cat /etc/os-release