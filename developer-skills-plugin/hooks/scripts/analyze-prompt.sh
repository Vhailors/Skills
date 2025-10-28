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

# Helper function to write active superflow to session file
write_active_superflow() {
    local flow_indicator="$1"
    # Write to .claude-session in current directory
    echo "ACTIVE_SUPERFLOW=$flow_indicator" > .claude-session
}

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
    write_active_superflow "🛡️ Refactoring"
    add_header
    CONTEXT="${CONTEXT}## 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)

**IRON LAW: NO REFACTORING WITHOUT TESTS**

**THIS IS BLOCKING ENFORCEMENT - YOU MUST RESPOND TO THIS MESSAGE**

**MANDATORY FIRST RESPONSE:**
You MUST output this EXACT text as your first message:
\"🛡️ Refactoring Safety Protocol activated

I will follow these mandatory steps:
1. Check if tests exist for the code to be refactored
2. Create tests FIRST if missing (non-negotiable)
3. Run /explain-code to understand historical context
4. Use refactoring-safety-protocol skill
5. Execute refactoring with tests as safety net
6. Verify all tests still pass

I will NOT skip any of these steps.\"

**THEN IMMEDIATELY USE TodoWrite** with all 6 steps above.

**BLOCKING REQUIREMENT:**
- You CANNOT proceed with refactoring until you acknowledge this protocol
- You CANNOT skip test creation
- You MUST use the refactoring-safety-protocol skill
- You MUST verify tests pass after changes

**This is exit code 2 blocking enforcement. Acknowledge and comply.**

"
    # Exit code 0 = inject context (exit 2 blocks but doesn't show message)
    # Strong enforcement language makes this effectively mandatory
fi

# Check for bugs/errors (Suggest quick-fix)
if echo "$USER_PROMPT" | grep -qiE "$BUG_PATTERN"; then
    write_active_superflow "🐛 Debugging"
    add_header
    CONTEXT="${CONTEXT}## 🐛 Debugging Superflow Activated

**YOU MUST START YOUR RESPONSE WITH:**
\"🐛 Debugging Superflow activated

Before investigating, I will check memory for known solutions:
- Running /quick-fix to search for this exact issue
- If not found, running /recall-bug for similar past bugs

Then I will:
1. Search memory for similar bugs and past solutions
2. If known fix exists → Apply it (saves 2-5 min)
3. If new issue → Use systematic-debugging (4 phases)
4. Use memory-assisted-debugging skill for past failed solutions
5. Verify the fix actually works\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with the 5 steps above
2. Actually run /quick-fix or /recall-bug FIRST (don't skip memory search)
3. Follow the debugging superflow systematically

**PROACTIVE REQUIREMENT:**
- Always check memory BEFORE attempting new solutions
- Always suggest the fast path first
- Always use memory-assisted-debugging skill

"
fi

# Check for feature implementation (Spec-kit workflow)
if echo "$USER_PROMPT" | grep -qiE "$FEATURE_PATTERN"; then
    write_active_superflow "🏗️ Feature Dev"
    add_header
    CONTEXT="${CONTEXT}## 🏗️ Feature Development Superflow

**YOU MUST START YOUR RESPONSE WITH:**
\"🏗️ Feature Development Superflow activated

I will follow the complete spec-kit workflow:
1. Run /recall-feature to check for similar past implementations
2. Use memory-assisted-spec-kit skill to learn from past features
3. Use spec-kit-orchestrator: Constitution → Specify → Clarify → Plan
4. Implement following the plan
5. Before marking complete: Run /check-integration + /ship-check

Starting with memory search to avoid reinventing solutions...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all workflow steps
2. Actually run /recall-feature BEFORE planning (don't skip memory)
3. Use memory-assisted-spec-kit skill proactively
4. Follow spec-kit-orchestrator phases systematically
5. DO NOT skip verification at the end

**PROACTIVE REQUIREMENTS:**
- Always check memory for similar features FIRST
- Always use the full spec-kit workflow (don't shortcut)
- Always verify integration before claiming done

"
fi

# Check for UI work (Library search first)
if echo "$USER_PROMPT" | grep -qiE "$UI_PATTERN"; then
    write_active_superflow "🎨 UI Dev"
    add_header
    CONTEXT="${CONTEXT}## 🎨 UI Development Superflow

**YOU MUST START YOUR RESPONSE WITH:**
\"🎨 UI Development Superflow activated

Before building from scratch, I will search existing resources:
1. Running /find-ui to search premium UI library (51 screenshots, 100+ components)
2. If found → Adapt existing component (saves significant time)
3. If not found → Use using-shadcn-ui skill (829 production blocks from shadcnblocks.com)
4. Plan error handling with error-handling-patterns skill
5. Implement with loading states, error states, and proper UX

Let me search the premium library first...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 5 steps
2. Actually suggest /find-ui with a specific pattern (don't skip this)
3. Proactively use using-shadcn-ui skill for pre-built blocks
4. Use error-handling-patterns skill BEFORE implementing
5. Don't build basic UI from scratch when premium options exist

**IRON LAW: SEARCH BEFORE BUILD**
- ALWAYS check /find-ui FIRST
- ALWAYS consider shadcn/ui blocks SECOND
- ONLY build from scratch as last resort

"
fi

# Check for API changes (Contract review)
if echo "$USER_PROMPT" | grep -qiE "$API_PATTERN"; then
    write_active_superflow "🔌 API Design"
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
    write_active_superflow "✅ Verifying"
    add_header
    CONTEXT="${CONTEXT}## ✅ Verification Before Completion (ENFORCED)

**THIS IS BLOCKING ENFORCEMENT - YOU MUST RESPOND TO THIS MESSAGE**

**IRON LAW: NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE**

**MANDATORY FIRST RESPONSE:**
You MUST output this EXACT text:
\"✅ Verification Protocol activated

I will NOT mark work as complete until I:
1. Run /check-integration for full-stack verification (DB → API → Frontend)
2. Run /ship-check for comprehensive validation
3. Use verification-before-completion skill
4. Gather FRESH evidence from actual command execution
5. Confirm ALL tests pass with real output

I will NOT rely on cached results or assumptions.\"

**THEN IMMEDIATELY USE TodoWrite** with all 5 verification steps.

**BLOCKING REQUIREMENTS:**
- You CANNOT claim work is complete without running verification commands
- You CANNOT use cached/old test results
- You MUST provide actual command output as evidence
- You MUST confirm tests pass with fresh execution

**This is exit code 2 blocking enforcement. Acknowledge and comply.**

"
fi

# Check for MVP/rapid prototyping
if echo "$USER_PROMPT" | grep -qiE "$MVP_PATTERN"; then
    write_active_superflow "🚀 Rapid Proto"
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

# Check for security concerns
SECURITY_PATTERN="security|vulnerability|hack|exploit|attack|auth.*issue|inject|xss|csrf"
if echo "$USER_PROMPT" | grep -qiE "$SECURITY_PATTERN"; then
    write_active_superflow "🔐 Security"
    add_header
    CONTEXT="${CONTEXT}## 🔐 Security Hardening Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"🔐 Security Hardening Workflow activated

I will follow the complete security review process:
1. Run /security-scan for comprehensive vulnerability analysis
2. Use security-patterns skill for OWASP Top 10 compliance
3. Check authentication and authorization
4. Validate all input handling
5. Review secrets management
6. Verify security headers and configuration

Starting with security scan...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Actually run /security-scan to identify vulnerabilities
3. Use security-patterns skill proactively
4. Address each vulnerability systematically
5. Run /security-scan again to verify fixes

**IRON LAW: SECURITY FIRST**
- ALWAYS scan before implementing fixes
- NEVER trust client-side data
- ALWAYS validate all user input

"
fi

# Check for performance issues
PERF_PATTERN="slow|performance|latency|optimize.*speed|bottleneck|takes.*long"
if echo "$USER_PROMPT" | grep -qiE "$PERF_PATTERN"; then
    write_active_superflow "⚡ Performance"
    add_header
    CONTEXT="${CONTEXT}## ⚡ Performance Optimization Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"⚡ Performance Optimization Workflow activated

I will follow systematic profiling and optimization:
1. Run /perf-check to identify bottlenecks
2. Profile current performance (before metrics)
3. Use performance-optimization skill
4. Optimize highest-impact bottlenecks first
5. Measure improvements (after metrics)
6. Verify no regressions with tests

Starting with performance analysis...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Actually run /perf-check to profile
3. Use performance-optimization skill for systematic approach
4. Focus on algorithm > database > caching > network > code
5. ALWAYS measure before and after

**IRON LAW: PROFILE FIRST, OPTIMIZE SECOND**
- NO optimization without profiling first
- ALWAYS measure impact
- Fix bottlenecks, not symptoms

"
fi

# Check for dependency updates
DEPENDENCY_PATTERN="update.*dependenc|upgrade.*package|npm.*update|vulnerabilit.*package|outdated"
if echo "$USER_PROMPT" | grep -qiE "$DEPENDENCY_PATTERN"; then
    write_active_superflow "📦 Dependencies"
    add_header
    CONTEXT="${CONTEXT}## 📦 Dependency Update Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"📦 Dependency Update Workflow activated

I will follow systematic update process:
1. Check current state (npm outdated, npm audit)
2. Use dependency-management skill for strategy
3. Review changelogs for breaking changes
4. Update incrementally (one at a time)
5. Run test suite after each update
6. Verify with /check-integration

Starting with dependency audit...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Run npm audit and npm outdated
3. Use dependency-management skill for risk assessment
4. Update ONE package at a time
5. Test after EACH update
6. Don't batch updates - isolate failures

**IRON LAW: INCREMENTAL UPDATES**
- ONE package at a time
- TEST after each update
- NEVER batch security + feature updates

"
fi

# Check for learning/explanation requests
LEARNING_PATTERN="learn|teach me|how does.*work|explain|understand|what is|show me how"
if echo "$USER_PROMPT" | grep -qiE "$LEARNING_PATTERN"; then
    write_active_superflow "🎓 Learning"
    add_header
    CONTEXT="${CONTEXT}## 🎓 Learning Mode Workflow

**YOU MUST START YOUR RESPONSE WITH:**
\"🎓 Learning Mode Workflow activated

I will provide comprehensive explanation:
1. Run /explain-code for historical context
2. Use /recall-pattern for similar implementations
3. Provide architectural overview
4. Show concrete examples
5. Suggest practice exercises
6. Create memory observation for future reference

Starting with code analysis...\"

**THEN IMMEDIATELY:**
1. Use TodoWrite with all 6 steps above
2. Run /explain-code for context
3. Use /recall-pattern for past patterns
4. Explain with examples, not just theory
5. Make it interactive - ask clarifying questions
6. Create memory observation when done

**LEARNING PRINCIPLES:**
- Show, don't just tell
- Use concrete examples from THIS codebase
- Build on existing knowledge
- Check understanding with questions

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
