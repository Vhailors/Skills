#!/bin/bash
# Debug script to see what environment variables are available

echo "=== Available CLAUDE Environment Variables ==="
env | grep -i claude | sort
echo ""
echo "=== All Environment Variables ==="
env | sort
exit 0
