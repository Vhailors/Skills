#!/usr/bin/env bash
# Debug version of statusline - logs stdin to see what Claude Code sends
# Replace your statusline temporarily with this to debug

set -euo pipefail

# Create debug log file
DEBUG_LOG="$HOME/.claude/statusline-debug.log"

# Capture stdin
STDIN_DATA=""
if [[ ! -t 0 ]]; then
    STDIN_DATA=$(cat)
fi

# Log to file with timestamp
{
    echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
    echo "PWD: $PWD"
    echo "STDIN length: ${#STDIN_DATA} chars"
    if [[ -n "$STDIN_DATA" ]]; then
        echo "STDIN data:"
        echo "$STDIN_DATA" | head -c 1000
        echo ""
        echo "---"
        # Pretty print if JSON
        if command -v jq &>/dev/null; then
            echo "Parsed JSON fields:"
            echo "$STDIN_DATA" | jq -r 'keys[]' 2>/dev/null || echo "Not valid JSON"
        fi
    else
        echo "NO STDIN DATA (running interactively or Claude Code not passing data)"
    fi
    echo ""
} >> "$DEBUG_LOG"

# Still output a statusline so it works
printf "📁 %s  🌿 DEBUG MODE (check %s)\n" "$(basename "$PWD")" "$DEBUG_LOG"
printf "📝 Logged at %s\n" "$(date '+%H:%M:%S')"
