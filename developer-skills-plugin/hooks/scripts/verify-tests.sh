#!/bin/bash
# Post-test verification - ensures test results are properly interpreted
# Runs after test commands to enforce verification-before-completion

# Get the bash command and its output
BASH_COMMAND="$CLAUDE_TOOL_PARAMS"

# Check if this was a test command
if echo "$BASH_COMMAND" | grep -qiE "(npm\s+(test|run\s+test)|pytest|jest|vitest|cargo\s+test|go\s+test|mvn\s+test|gradle\s+test|phpunit|rspec|mocha)"; then
    echo ""
    echo "# ✅ Test Verification Protocol"
    echo ""
    echo "## Post-Test Verification Checklist"
    echo ""
    echo "**After running tests, ensure:**"
    echo ""
    echo "1. **Read Actual Output**"
    echo "   - ⚠️ **DO NOT assume tests passed without reading output**"
    echo "   - Check for: Pass/Fail counts, error messages, warnings"
    echo "   - Look for: \"X passing\", \"0 failing\", \"All tests passed\""
    echo ""
    echo "2. **Interpret Results Correctly**"
    echo "   - ✅ Success = ALL tests pass (not just some)"
    echo "   - ❌ Failure = ANY test fails or errors occur"
    echo "   - ⚠️ Warnings = Review required (may indicate issues)"
    echo ""
    echo "3. **Evidence-Based Completion**"
    echo "   - Use: \`verification-before-completion\` skill"
    echo "   - **IRON LAW: NO SUCCESS CLAIMS WITHOUT FRESH EVIDENCE**"
    echo "   - Include actual output in your response to user"
    echo ""
    echo "4. **If Tests Fail**"
    echo "   - DO NOT mark task as complete"
    echo "   - Use: \`systematic-debugging\` skill"
    echo "   - Check: \`/recall-bug\` for similar past failures"
    echo ""
    echo "**Remember:** Verification is not optional - it's a requirement."
    echo ""
fi

# Check for build commands
if echo "$BASH_COMMAND" | grep -qiE "(npm\s+(run\s+)?build|yarn\s+build|cargo\s+build|go\s+build|mvn\s+(clean\s+)?package|gradle\s+build|make\s+build)"; then
    echo ""
    echo "# 🏗️ Build Verification"
    echo ""
    echo "**After running build:**"
    echo "- Verify build succeeded (check exit code and output)"
    echo "- Check for warnings or errors in build output"
    echo "- If build fails, investigate before proceeding"
    echo ""
fi

# Check for linting/formatting commands
if echo "$BASH_COMMAND" | grep -qiE "(eslint|prettier|black|rustfmt|gofmt|rubocop|phpcs|stylelint)"; then
    echo ""
    echo "# 🎨 Code Quality Check"
    echo ""
    echo "**After linting/formatting:**"
    echo "- Review any errors or warnings"
    echo "- Fix issues before committing"
    echo "- Ensure code meets project standards"
    echo ""
fi

# Exit code 0 = add context without blocking
exit 0
