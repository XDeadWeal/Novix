#!/bin/bash
echo "Updating bootgui plugin..."

# Pull latest changes
git pull

# Recompile
if [ -f "src/main.c" ]; then
    gcc -o bootgui src/main.c -lgfx 2>/dev/null || gcc -o bootgui src/main.c 2>/dev/null
    if [ -f "bootgui" ]; then
        cp bootgui /usr/bin/bootgui
        chmod +x /usr/bin/bootgui
        echo "bootgui recompiled and updated!"
    fi
fi

# Update config if changed
if [ -f "config/bootgui.conf" ]; then
    cp config/bootgui.conf /etc/bootgui/
fi

echo "bootgui plugin updated!"