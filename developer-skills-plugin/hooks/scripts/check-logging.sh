#!/bin/bash
# Logging schema enforcement - runs before Write/Edit tools that contain logging code
# This enforces the "standardized-logging" skill's iron law

TOOL_NAME="$CLAUDE_TOOL_NAME"
TOOL_PARAMS="$CLAUDE_TOOL_PARAMS"

# Check if the tool parameters contain logging-related code
if echo "$TOOL_PARAMS" | grep -qiE "(log|logger|console\.)"; then
    echo ""
    echo "# ⚠️ STANDARDIZED LOGGING ENFORCEMENT"
    echo ""
    echo "**IRON LAW: NO LOGGING CODE WITHOUT CHECKING SCHEMA FIRST**"
    echo ""
    echo "Detected logging code in ${TOOL_NAME} operation."
    echo ""
    echo "**Required actions:**"
    echo "1. Check project's logging schema file first"
    echo "2. Use consistent field names across application"
    echo "3. Include correlation IDs for request tracing"
    echo "4. Follow structured logging format (JSON preferred)"
    echo ""
    echo "The \`standardized-logging\` skill contains the full requirements."
    echo ""
    echo "**Common schema fields:**"
    echo "- \`timestamp\`, \`level\`, \`message\`, \`correlationId\`"
    echo "- \`userId\`, \`sessionId\`, \`requestId\` (when applicable)"
    echo "- \`component\`, \`method\`, \`duration\` (for operations)"
    echo ""

    # Exit code 2 = blocking error (forces Claude to acknowledge)
    # This makes it a "remind" rather than hard block
    exit 0
fi

# No logging code detected, continue normally
exit 0
