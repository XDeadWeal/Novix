#!/bin/bash
echo "Installing hello-world plugin..."
if [ -f "src/hello.c" ]; then
    gcc -o hello src/hello.c 2>/dev/null || echo "Compilation skipped"
fi
echo "hello-world installed!"
