#!/bin/bash
echo "Updating hello-world plugin..."
git pull
if [ -f "src/hello.c" ]; then
    gcc -o hello src/hello.c 2>/dev/null || echo "Recompilation skipped"
fi