#!/bin/bash
echo "Installing bootgui..."
mkdir -p /usr/share/bootgui /usr/bin
if [ -f "src/main.c" ]; then
    gcc -o bootgui src/main.c 2>/dev/null
    if [ -f "bootgui" ]; then
        cp bootgui /usr/bin/bootgui; chmod +x /usr/bin/bootgui
        echo "bootgui compiled!"
    else echo "Warning: compile failed"; fi
fi
if [ -f "config/bootgui.conf" ]; then mkdir -p /etc/bootgui; cp config/bootgui.conf /etc/bootgui/; fi
echo "bootgui installed!"
