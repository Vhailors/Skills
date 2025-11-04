#!/bin/bash
# Post-Test Spotlight Error Checker
# Runs after Bash commands to detect runtime errors captured by Spotlight
# Particularly useful after test execution to catch errors that don't fail tests

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Read JSON from stdin
INPUT_JSON=$(cat)

# Extract tool name and command if available
if command -v jq &> /dev/null; then
    TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.toolName // empty' 2>/dev/null)
    COMMAND=$(echo "$INPUT_JSON" | jq -r '.parameters.command // empty' 2>/dev/null)
else
    # Fallback: check if this was a Bash tool call
    TOOL_NAME=$(echo "$INPUT_JSON" | grep -oP '"toolName":\s*"\K[^"]+' || echo "")
    COMMAND=$(echo "$INPUT_JSON" | grep -oP '"command":\s*"\K[^"]+' || echo "")
fi

# Only run for Bash tool (and only for test-like commands)
if [ "$TOOL_NAME" != "Bash" ]; then
    exit 0
fi

# Check if this looks like a test command
TEST_PATTERNS="npm.*test|yarn.*test|pnpm.*test|jest|vitest|mocha|pytest|cargo.*test|go.*test|mvn.*test|gradle.*test"
if ! echo "$COMMAND" | grep -qiE "$TEST_PATTERNS"; then
    exit 0  # Not a test command, skip Spotlight check
fi

# Check if Spotlight is available
if [ ! -f "${PLUGIN_ROOT}/hooks/scripts/spotlight-query.sh" ]; then
    exit 0  # Spotlight query script not found
fi

# Check if Spotlight is configured
if ! bash "${PLUGIN_ROOT}/hooks/scripts/spotlight-query.sh" status &> /dev/null; then
    exit 0  # Spotlight not configured or not available
fi

# At this point, we know:
# 1. A test command was just executed
# 2. Spotlight is available
# 3. We should check for errors

# The actual MCP query will be done by Claude Code in the context injection
# This hook just signals that Spotlight should be checked

CONTEXT="
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔎 Spotlight Post-Test Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Test command completed:** \`${COMMAND}\`

**RECOMMENDED ACTION - Check Spotlight for Runtime Errors:**

Even if tests passed, there may be runtime errors captured by Spotlight:
- JavaScript/TypeScript: console.error calls
- Uncaught exceptions that didn't fail tests
- Network errors or API failures
- Performance issues or warnings

**How to check:**
1. Query Spotlight MCP for errors in the last 5-10 minutes
2. Look for errors that occurred during test execution
3. Investigate any unexpected errors even if tests passed

**MCP Query Example:**
If Spotlight MCP tools are available, query for recent errors:
- Filter by timestamp during test execution
- Check error types (errors, warnings, console logs)
- Review stack traces for test-related code

**Why this matters:**
Tests may pass while still producing errors:
- Unhandled promise rejections
- React render errors caught by error boundaries
- API calls that fail but are not asserted
- Memory leaks or resource warnings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"

# Output JSON with additionalContext
ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "$ESCAPED_CONTEXT"
  }
}
EOF

exit 0
