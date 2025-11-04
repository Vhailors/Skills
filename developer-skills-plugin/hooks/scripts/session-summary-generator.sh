#!/bin/bash
# Session Summary Generator Hook
# Triggered when Claude Code stops working or session ends
# Auto-generates SESSION-SUMMARY-{timestamp}.md from session context

set -e

PROJECT_ROOT="${1:-.}"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
SUMMARY_FILE="$PROJECT_ROOT/SESSION-SUMMARY-${TIMESTAMP}.md"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[SESSION-SUMMARY] Generating session summary...${NC}"

# Collect git changes
GIT_MODIFIED=$(git -C "$PROJECT_ROOT" status --short 2>/dev/null | wc -l)
GIT_DIFF=$(git -C "$PROJECT_ROOT" diff --stat 2>/dev/null | tail -1 | awk '{print $NF}' || echo "0")

# Check for test results
TEST_STATUS="not run"
if [ -f "$PROJECT_ROOT/test-results.json" ]; then
    TEST_STATUS=$(jq -r '.summary.status' "$PROJECT_ROOT/test-results.json" 2>/dev/null || echo "unknown")
fi

# Get last few git commits for accomplishments
RECENT_COMMITS=$(git -C "$PROJECT_ROOT" log --oneline -10 2>/dev/null | head -5)

# Extract completed todos from .claude/conversation-history.json if available
COMPLETED_TODOS=""
if [ -f "$PROJECT_ROOT/.claude/conversation-history.json" ]; then
    COMPLETED_TODOS=$(jq -r '.todos[] | select(.status == "completed") | "- " + .content' "$PROJECT_ROOT/.claude/conversation-history.json" 2>/dev/null || echo "")
fi

# Extract pending todos
PENDING_TODOS=""
if [ -f "$PROJECT_ROOT/.claude/conversation-history.json" ]; then
    PENDING_TODOS=$(jq -r '.todos[] | select(.status == "pending") | "- " + .content + " - [next step]"' "$PROJECT_ROOT/.claude/conversation-history.json" 2>/dev/null || echo "")
fi

# Create summary file
cat > "$SUMMARY_FILE" << EOF
# Session Summary: $(date '+%Y-%m-%d %H:%M:%S')

## ✅ Completed

$(if [ -n "$COMPLETED_TODOS" ]; then echo "$COMPLETED_TODOS"; else echo "- [Add accomplishments from session]"; fi)

## 📋 Pending

$(if [ -n "$PENDING_TODOS" ]; then echo "$PENDING_TODOS"; else echo "- [Add pending items and blockers]"; fi)

## ⚠️ Known Issues

- [Document any known issues discovered]

## 🎯 Next Steps

1. [First priority action]
2. [Second priority action]
3. [Long-term follow-up]

---
**Generated**: $(date '+%Y-%m-%d %H:%M:%S')
**Session Duration**: [Calculate from session start]
**Files Modified**: $GIT_MODIFIED
**Test Status**: $TEST_STATUS
**Changed Files**: $GIT_DIFF files changed
EOF

echo -e "${GREEN}✅ Session summary created: $SUMMARY_FILE${NC}"
echo -e "${YELLOW}⚠️  Review and fill in the bracketed sections before committing${NC}"

# Note: Interactive prompts disabled in hook context
# Use: code "$SUMMARY_FILE" manually if needed

exit 0
