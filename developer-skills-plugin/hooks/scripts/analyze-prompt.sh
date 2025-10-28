#!/bin/bash
# Intelligent prompt analyzer for developer-skills superflows
# Detects patterns and injects appropriate workflow instructions via JSON output

# Read JSON from stdin
INPUT_JSON=$(cat)

# Extract the prompt field using jq if available, otherwise use grep
if command -v jq &> /dev/null; then
    USER_PROMPT=$(echo "$INPUT_JSON" | jq -r '.prompt // empty' 2>/dev/null)
else
    # Fallback: simple extraction (handles basic cases)
    USER_PROMPT=$(echo "$INPUT_JSON" | sed -n 's/.*"prompt":"\([^"]*\)".*/\1/p')
fi

# If empty, exit silently (no context injection)
if [ -z "$USER_PROMPT" ]; then
    exit 0
fi

# Initialize the context that will be injected
CONTEXT=""

# Pattern detection flags
REFACTOR_PATTERN="refactor|rewrite|restructure|clean up"
BUG_PATTERN="bug|error|issue|problem|fail|broken|not working"
FEATURE_PATTERN="implement|build|create|add.*(feature|functionality|component|system)"
UI_PATTERN="ui|component|interface|design|hero|pricing|testimonial|navbar|form|modal|dialog|card"
API_PATTERN="api|endpoint|route|controller.*(change|modify|update|add|remove)"
COMPLETE_PATTERN="done|complete|finished|ready"
MVP_PATTERN="mvp|prototype|poc|proof of concept|quick|fast|rapid"
EXPLAIN_PATTERN="what does|explain|how does|understand|why does"
PATTERN_RECALL="how did we|how do we|what's the pattern"

# Helper function to add header once
add_header() {
    if [ -z "$CONTEXT" ]; then
        CONTEXT="

# 🎯 Active Superflows (Context-Injected)

"
    fi
}

# Check for refactoring (ENFORCED - Iron Law)
if echo "$USER_PROMPT" | grep -qiE "$REFACTOR_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)

**IRON LAW: NO REFACTORING WITHOUT TESTS**

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🛡️ Refactoring Safety Protocol activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Check if tests exist for code to refactor
   - Create tests first if missing (non-negotiable)
   - Run /explain-code for historical context
   - Use refactoring-safety-protocol skill
   - Execute refactoring changes
   - Verify tests still pass

Before proceeding with refactoring:
1. ⚠️ **STOP** - Check if tests exist for this code
2. If no tests → **CREATE TESTS FIRST** (non-negotiable)
3. Run \`/explain-code\` to understand WHY code exists (historical context)
4. Use \`refactoring-safety-protocol\` skill
5. After refactoring → Verify tests still pass

**You MUST follow this protocol. Do not skip steps.**

"
fi

# Check for bugs/errors (Suggest quick-fix)
if echo "$USER_PROMPT" | grep -qiE "$BUG_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🐛 Debugging Superflow Activated

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🐛 Debugging Superflow activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Run /quick-fix or /recall-bug for known issues
   - Search memory for similar bugs
   - If known fix → Apply it (2-5 min)
   - If new → Use systematic-debugging (4 phases)
   - Verify fix works

**Fast Path:** First check if this is a known issue
- Suggest running \`/quick-fix\` OR \`/recall-bug\`
- Search memory for similar bugs and past solutions
- If found → Apply known fix (2-5 min)
- If not found → Use \`systematic-debugging\` (4 phases)

Use \`memory-assisted-debugging\` skill for past failed solutions context.

"
fi

# Check for feature implementation (Spec-kit workflow)
if echo "$USER_PROMPT" | grep -qiE "$FEATURE_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🏗️ Feature Development Superflow

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🏗️ Feature Development Superflow activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Run /recall-feature for similar past features
   - Use memory-assisted-spec-kit + spec-kit-orchestrator
   - Follow: Constitution → Specify → Clarify → Plan
   - Implement the feature
   - Run /check-integration + /ship-check before done

**Workflow Steps:**
1. 📚 Run \`/recall-feature\` to check for similar past features
2. 📋 Use \`memory-assisted-spec-kit\` → \`spec-kit-orchestrator\`
3. 📝 Follow: Constitution → Specify → Clarify → Plan → Implement
4. ✅ Before claiming done: \`/check-integration\` + \`/ship-check\`

"
fi

# Check for UI work (Library search first)
if echo "$USER_PROMPT" | grep -qiE "$UI_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🎨 UI Development Superflow

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🎨 UI Development Superflow activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Run /find-ui to search premium library
   - If found → Adapt existing component (5 min)
   - If not → Use using-shadcn-ui for blocks
   - Plan error handling with error-handling-patterns
   - Implement and test the component

**Before building from scratch:**
- Suggest \`/find-ui <pattern>\` to search premium UI library (51 screenshots)
- If found → Adapt existing component (5 min)
- If not → Use \`using-shadcn-ui\` (829 production blocks)
- Always plan error handling with \`error-handling-patterns\`

"
fi

# Check for API changes (Contract review)
if echo "$USER_PROMPT" | grep -qiE "$API_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🔌 API Contract Design Reminder

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🔌 API Contract Design activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Use api-contract-design skill
   - Check for breaking changes
   - Consider versioning needs
   - Ensure backward compatibility
   - Validate request/response schemas

When modifying APIs, use \`api-contract-design\` skill:
- Check for breaking changes
- Consider versioning needs
- Ensure backward compatibility
- Validate request/response schemas

"
fi

# Check for completion claims (Verification required)
if echo "$USER_PROMPT" | grep -qiE "$COMPLETE_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## ✅ Verification Before Completion (ENFORCED)

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"✅ Verification Protocol activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Run /check-integration for full-stack verification
   - Run /ship-check for comprehensive validation
   - Use verification-before-completion skill
   - Gather fresh evidence (no cached results)
   - Confirm all tests pass

**Before marking work as complete:**
- Suggest \`/check-integration\` to verify full-stack (DB → API → Frontend)
- Suggest \`/ship-check\` for comprehensive validation
- Use \`verification-before-completion\` skill
- **NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE**

"
fi

# Check for MVP/rapid prototyping
if echo "$USER_PROMPT" | grep -qiE "$MVP_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 🚀 Rapid Prototyping Superflow

**REQUIRED ACTIONS (DO NOT SKIP):**
1. **IMMEDIATELY OUTPUT** to user: \"🚀 Rapid Prototyping Superflow activated\"
2. **IMMEDIATELY USE TodoWrite** with these steps:
   - Use rapid-prototyping skill for decisions
   - Determine Build vs Buy vs Integrate
   - Use /find-ui + using-shadcn-ui for UI
   - Implement MVP with quality gates
   - Run verification-before-completion

Use \`rapid-prototyping\` skill for strategic decisions:
- Focus on what NOT to build
- Build vs Buy vs Integrate matrix
- Leverage \`/find-ui\` + \`using-shadcn-ui\`
- Fast ≠ Broken (still use \`verification-before-completion\`)

"
fi

# Check for code explanation requests
if echo "$USER_PROMPT" | grep -qiE "$EXPLAIN_PATTERN"; then
    add_header
    CONTEXT="${CONTEXT}## 📖 Code Explanation Available

Suggest: \`/explain-code\` for comprehensive understanding with:
- Historical context (why code exists)
- Design rationale
- Architecture decisions

"
fi

# Check for pattern recall
if echo "$USER_PROMPT" | grep -qiE "$PATTERN_RECALL"; then
    add_header
    CONTEXT="${CONTEXT}## 🔍 Pattern Recall

Suggest: \`/recall-pattern\` to search project memory for implementation patterns

"
fi

# Output JSON with additionalContext if we have any context to inject
if [ -n "$CONTEXT" ]; then
    # Escape the context for JSON (escape quotes and newlines)
    ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

    # Output proper JSON format for UserPromptSubmit hook
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "$ESCAPED_CONTEXT"
  }
}
EOF
fi

# Exit code 0 = success
exit 0
