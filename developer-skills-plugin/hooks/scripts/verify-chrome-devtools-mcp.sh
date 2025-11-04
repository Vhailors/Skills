#!/bin/bash

# verify-chrome-devtools-mcp.sh - Verifies Chrome DevTools MCP is available and functional
# Part of pixel-perfect-site-copy superflow

# This script should be called early in the workflow to ensure MCP is ready

# Exit codes:
# 0 - MCP available and functional
# 1 - MCP not configured
# 2 - MCP configured but not responding

# Check if .mcp.json exists and contains chrome-devtools
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-/mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin}"
MCP_CONFIG="$PLUGIN_ROOT/.mcp.json"

if [ ! -f "$MCP_CONFIG" ]; then
  echo "⚠️ Chrome DevTools MCP not configured: .mcp.json not found"
  exit 1
fi

if ! grep -q "chrome-devtools" "$MCP_CONFIG"; then
  echo "⚠️ Chrome DevTools MCP not configured in .mcp.json"
  echo "Please add chrome-devtools server configuration"
  exit 1
fi

# MCP is configured
echo "✅ Chrome DevTools MCP configured in .mcp.json"
exit 0
