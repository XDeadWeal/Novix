#!/bin/bash
echo "Updating bootgui..."
git pull
if [ -f "src/main.c" ]; then
    gcc -o bootgui src/main.c 2>/dev/null && cp bootgui /usr/bin/bootgui
fi
