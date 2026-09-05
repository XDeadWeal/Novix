#!/bin/bash
echo "Installing hello-world plugin..."

# Compile the C source if available
if [ -f "src/hello.c" ]; then
    gcc -o hello src/hello.c 2>/dev/null || echo "Compilation skipped (gcc not available)"
fi

echo "hello-world plugin installed!"