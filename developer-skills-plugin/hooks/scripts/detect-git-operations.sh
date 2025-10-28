#!/bin/bash
# Pre-commit and git operation detection - triggers pre-ship validation superflow
# Detects git commit commands and injects /ship-check reminder

# Get the bash command being executed
BASH_COMMAND="$CLAUDE_TOOL_PARAMS"

# Check if this is a git commit operation
if echo "$BASH_COMMAND" | grep -qE "git\s+(commit|push)"; then
    echo ""
    echo "# 🚢 Pre-Ship Validation Superflow Activated"
    echo ""
    echo "## ⚠️ Detected Git Operation"
    echo ""
    echo "You are about to commit or push code. Before proceeding:"
    echo ""
    echo "**Pre-Ship Checklist:**"
    echo ""
    echo "1. **Integration Verification**"
    echo "   - Suggest: \`/check-integration\` to verify full-stack (DB → API → Frontend)"
    echo "   - Use: \`full-stack-integration-checker\` skill"
    echo "   - Validates: No gaps, no unused code, complete CRUD"
    echo ""
    echo "2. **Comprehensive Validation**"
    echo "   - Suggest: \`/ship-check\` for complete pre-deployment validation"
    echo "   - Checks: Tests passing, spec criteria met, security, code quality"
    echo ""
    echo "3. **Verification Protocol**"
    echo "   - Use: \`verification-before-completion\` skill"
    echo "   - **IRON LAW: NO SUCCESS CLAIMS WITHOUT FRESH EVIDENCE**"
    echo "   - Run actual verification commands, don't assume"
    echo ""
    echo "4. **Documentation** (Optional but recommended)"
    echo "   - Use: \`changelog-generator\` skill for technical release notes"
    echo "   - Generates: Changelog from git commits with implementation details"
    echo ""
    echo "**Result:** ✅ Ready to ship OR ❌ Gaps found with action items"
    echo ""
    echo "---"
    echo ""
    echo "If user has already validated, you may proceed. Otherwise, suggest running checks first."
    echo ""
fi

# Check if this is a git add operation (staging files)
if echo "$BASH_COMMAND" | grep -qE "git\s+add"; then
    echo ""
    echo "# 📝 Staging Files for Commit"
    echo ""
    echo "Remember to run validation checks before committing:"
    echo "- Consider: \`/ship-check\` before the actual commit"
    echo "- Ensure: Tests pass, integration complete, no gaps"
    echo ""
fi

# Exit code 0 = add context without blocking
exit 0
