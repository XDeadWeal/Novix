#!/bin/bash
echo "Uninstalling bootgui plugin..."

# Remove binary
rm -f /usr/bin/bootgui

# Remove config
rm -rf /etc/bootgui

# Remove shared files
rm -rf /usr/share/bootgui

echo "bootgui plugin uninstalled!"