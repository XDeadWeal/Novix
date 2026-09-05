#!/bin/bash
echo "Installing bootgui plugin..."

# Create necessary directories
mkdir -p /usr/share/bootgui
mkdir -p /usr/bin

# Copy source files
if [ -f "src/main.c" ]; then
    gcc -o bootgui src/main.c -lgfx 2>/dev/null || gcc -o bootgui src/main.c 2>/dev/null
    if [ -f "bootgui" ]; then
        cp bootgui /usr/bin/bootgui
        chmod +x /usr/bin/bootgui
        echo "bootgui compiled and installed!"
    else
        echo "Warning: Could not compile bootgui. Make sure gcc is installed."
    fi
fi

# Copy config files
if [ -f "config/bootgui.conf" ]; then
    mkdir -p /etc/bootgui
    cp config/bootgui.conf /etc/bootgui/
fi

echo "bootgui plugin installed!"