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
COPY_SITE_PATTERN="copy.*site|clone.*site|replicate.*site|clone.*website|copy.*website|replicate.*website|pixel.*perfect.*copy|pixel.*perfect.*clone|extract.*styl|copy.*this.*page|clone.*this.*page|replicate.*this.*page"
REFACTOR_PATTERN="refactor|rewrite|restructure|clean up|cleanup|improve.*code|modernize|simplify|tidy|organize|reorganize|optimize.*code|make.*better|make.*cleaner"
BUG_PATTERN="bug|error|issue|problem|fail|broken|not working|crash|exception|debug|incorrect|wrong|unexpected|doesn't work|won't work|fix.*error|fix.*issue|not responding"
FEATURE_PATTERN="implement|build|create|add.*(feature|functionality|component|system)|develop|make.*new|new.*feature|want to add|need to build|add support for"
UI_PATTERN="ui|component|interface|design|hero|pricing|testimonial|navbar|form|modal|dialog|card|button|page|layout|screen|view|dashboard|header|footer|sidebar|menu|dropdown|table|list|grid"
API_PATTERN="api|endpoint|route|controller.*(change|modify|update|add|remove)|rest.*api|graphql|webhook|request|response"
COMPLETE_PATTERN="done|complete|finished|ready|ship it|deploy|push.*prod|release"
MVP_PATTERN="mvp|prototype|poc|proof of concept|quick|fast|rapid|minimum viable|quick build|basic version|simple version|fast.*implementation"
EXPLAIN_PATTERN="what does.*(function|class|method|code|file)|explain.*(function|class|method|code|file|module|middleware|handler)|how does.*(function|class|code|work)"
PATTERN_RECALL="how did we|how do we|what's the pattern|what pattern|similar.*before|did we.*before|recall.*pattern"

# Helper function to write active superflow to session file
write_active_superflow() {
    local flow_indicator="$1"
    local workflow_key=$(echo "$flow_indicator" | tr ' ' '_' | tr -d '🛡️🐛🏗️🎨🔌✅🚀🔐⚡📦🎓')

    # Read existing session data
    local violations=0
    if [ -f .claude-session ]; then
        violations=$(grep -oP "${workflow_key}_VIOLATIONS=\K\d+" .claude-session 2>/dev/null || echo "0")
    fi

    # Write to .claude-session
    {
        echo "ACTIVE_SUPERFLOW=$flow_indicator"
        echo "${workflow_key}_VIOLATIONS=$violations"
        echo "LAST_WORKFLOW_CHECK=$(date -Iseconds)"
    } > .claude-session
}

# Helper function to get enforcement level based on violations
get_enforcement_level() {
    local workflow_key="$1"
    local violations=0

    if [ -f .claude-session ]; then
        violations=$(grep -oP "${workflow_key}_VIOLATIONS=\K\d+" .claude-session 2>/dev/null || echo "0")
    fi

    # Return enforcement level: SUGGEST(0), WARN(1), REQUIRE(2), BLOCK(3+)
    if [ "$violations" -eq 0 ]; then
        echo "SUGGEST"
    elif [ "$violations" -eq 1 ]; then
        echo "WARN"
    elif [ "$violations" -eq 2 ]; then
        echo "REQUIRE"
    else
        echo "BLOCK"
    fi
}

# Helper function to add header once
add_header() {
    if [ -z "$CONTEXT" ]; then
        CONTEXT="

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🎯 SUPERFLOW SYSTEM ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**System Status**: ✅ Hooks Operational | 🔧 Context Injected | 🎭 Workflow Enforced

"
    fi
}

# Check for copy-site requests (HIGHEST PRIORITY - very specific pattern)
if echo "$USER_PROMPT" | grep -qiE "$COPY_SITE_PATTERN"; then
    write_active_superflow "🎨 Pixel-Perfect Site Copy"
    add_header

    CONTEXT="${CONTEXT}## 🎨 PIXEL-PERFECT SITE COPY SUPERFLOW: ACTIVE

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
BEFORE ANY OTHER ACTION, execute this command:
\`\`\`
Skill(command: 'pixel-perfect-site-copy')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🎨 PIXEL-PERFECT SITE COPY: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete pixel-perfect site copy workflow:
1. Verify Chrome DevTools MCP is available
2. Connect to target URL and extract computed styles
3. Organize screenshot storage with standardized structure
4. Capture screenshots at multiple breakpoints
5. Generate comprehensive 17-section style guide
6. Implement pixel-perfect replica using Tailwind CSS
7. Validate visual equivalence against screenshots

**Extended Thinking**: Enabled for complex visual hierarchies, measurement validation, and responsive behavior analysis.

Starting with Chrome DevTools MCP verification...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all workflow steps:
- Verify Chrome DevTools MCP availability (run verify-chrome-devtools-mcp.sh)
- Connect to target URL using DevTools MCP
- Extract computed styles for all major components
- Organize screenshot storage (run organize_screenshots.py)
- Capture screenshots at breakpoints (320px, 768px, 1024px, 1440px)
- Generate STYLE_GUIDE.md with 17 sections
- Implement HTML/Tailwind replica
- Validate pixel-perfect quality against screenshots
- Deliver complete package (style guide, implementation, screenshots)

**IMMEDIATE ACTION #3b - CONSIDER AGENT FOR COMPLEX SITES:**
For large/complex sites (e.g., Stripe, Vercel), consider using Task tool with subagent_type='Explore' to:
- Systematically map all sections and components
- Extract styles methodically across the entire site
- Handle multi-page extraction (homepage, pricing, docs, etc.)

**IMMEDIATE ACTION #4 - VERIFY CHROME DEVTOOLS MCP:**
Check if Chrome DevTools MCP is configured and available.
If not available, inform user: \"This workflow requires Chrome DevTools MCP. Please configure it in .mcp.json\"

**IRON LAW: PIXEL-PERFECT QUALITY**
- Measure, don't estimate (use DevTools Computed values)
- Extract, don't approximate (exact hex codes, exact fonts)
- Compare, don't assume (validate against screenshots)
- Document, don't omit (complete style guide)
- Replicate, don't redesign (preserve original design)

**QUALITY STANDARDS:**
❌ \"This looks about right\" → ✅ \"Matches computed value of 16.8px line-height\"
❌ \"The spacing feels good\" → ✅ \"Margin-bottom is 24px from DevTools\"
❌ \"It's close enough\" → ✅ \"It's pixel-perfect\"

**DELIVERABLES:**
1. STYLE_GUIDE.md (17 sections with extracted values)
2. index.html (complete HTML/Tailwind implementation)
3. Screenshots (visual comparison original vs. replica)
4. Documentation (challenges, limitations, deviations)

**WORKFLOW PHASES:**
Phase 1: Site Inspection & Style Extraction
Phase 2: Style Guide Generation
Phase 3: Implementation
Phase 4: Quality Assurance

"
fi

# Check for refactoring (ENFORCED - Iron Law)
if echo "$USER_PROMPT" | grep -qiE "$REFACTOR_PATTERN"; then
    write_active_superflow "🛡️ Refactoring"
    enforcement=$(get_enforcement_level "Refactoring")
    add_header

    # Adaptive enforcement message based on violation history
    enforcement_msg=""
    case "$enforcement" in
        "SUGGEST")
            enforcement_msg="**RECOMMENDATION**: Consider using the refactoring safety protocol"
            ;;
        "WARN")
            enforcement_msg="⚠️ **WARNING**: You've skipped safety checks before. Please follow the protocol this time."
            ;;
        "REQUIRE")
            enforcement_msg="🔴 **REQUIRED**: Multiple violations detected. You MUST follow the safety protocol."
            ;;
        "BLOCK")
            enforcement_msg="🛑 **BLOCKING ENFORCEMENT**: Pattern of violations detected. This is now mandatory."
            ;;
    esac

    CONTEXT="${CONTEXT}## 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)

**IRON LAW: NO REFACTORING WITHOUT TESTS**

$enforcement_msg

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
BEFORE ANY OTHER ACTION, you MUST execute this command:
\`\`\`
Skill(command: 'refactoring-safety-protocol')
\`\`\`

Do NOT describe what you will do. Execute the skill tool NOW.

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
After invoking the skill, output this EXACT text with clear visual indicator:

\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🛡️ REFACTORING SAFETY PROTOCOL: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow these mandatory steps:
1. Check if tests exist for the code to be refactored
2. Create tests FIRST if missing (non-negotiable)
3. Run /explain-code to understand historical context
4. Execute refactoring with tests as safety net
5. Verify all tests still pass\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**BLOCKING REQUIREMENTS:**
- You CANNOT proceed without invoking the skill first
- You CANNOT skip test creation
- You MUST verify tests pass after changes

**This is exit code 2 blocking enforcement. Acknowledge and comply.**

"
    # Exit code 0 = inject context (exit 2 blocks but doesn't show message)
    # Strong enforcement language makes this effectively mandatory
fi

# Check for bugs/errors (Suggest quick-fix + Spotlight integration)
if echo "$USER_PROMPT" | grep -qiE "$BUG_PATTERN"; then
    write_active_superflow "🐛 Debugging"
    add_header

    # Check if Spotlight MCP is available and query for recent errors
    SPOTLIGHT_CONTEXT=""
    if [ -f "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/spotlight-query.sh" ]; then
        # Check Spotlight status
        if bash "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/spotlight-query.sh" status &> /dev/null; then
            SPOTLIGHT_CONTEXT="

**🔎 SPOTLIGHT INTEGRATION ACTIVE:**
Spotlight MCP server is configured. AI should query Spotlight for:
- Recent runtime errors with full stack traces
- Error context (request data, user state, etc.)
- Error frequency and patterns
- Exact timestamps for correlation

Use these MCP tools if available:
- Query Spotlight for errors in last 10 minutes
- Get full error details including stack trace
- Use error data to inform memory search

"
        fi
    fi

    CONTEXT="${CONTEXT}## 🐛 Debugging Superflow Activated
$SPOTLIGHT_CONTEXT
**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
BEFORE ANY OTHER ACTION, execute this command:
\`\`\`
Skill(command: 'memory-assisted-debugging')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🐛 DEBUGGING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Before investigating, I will check for real-time error data:
- If Spotlight MCP is available, query for recent errors FIRST
- Use actual error details (stack trace, context) for investigation
- Search memory with specific error details
- If not found, running /recall-bug for similar past bugs

Then I will:
1. Query Spotlight for actual runtime errors (if available)
2. Search memory for similar bugs using error details
3. If known fix exists → Apply it (saves 2-5 min)
4. If new issue → Use systematic-debugging (4 phases)
5. Verify the fix actually works\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**IMMEDIATE ACTION #4 - CHECK SPOTLIGHT (if available):**
Query Spotlight MCP for recent errors to get actual error data.

**IMMEDIATE ACTION #5 - RUN MEMORY SEARCH:**
Run /quick-fix or /recall-bug using error details from Spotlight.

**PROACTIVE REQUIREMENTS:**
- Check Spotlight for real-time errors FIRST (if available)
- Always check memory BEFORE attempting new solutions
- Always suggest the fast path first
- Use actual error context for better debugging

"
fi

# Check for feature implementation (Spec-kit workflow)
if echo "$USER_PROMPT" | grep -qiE "$FEATURE_PATTERN"; then
    write_active_superflow "🏗️ Feature Dev"
    add_header
    CONTEXT="${CONTEXT}## 🏗️ Feature Development Superflow

**IMMEDIATE ACTION #1 - INVOKE SKILLS NOW:**
Execute these commands in order:
\`\`\`
Skill(command: 'memory-assisted-spec-kit')
\`\`\`
\`\`\`
Skill(command: 'spec-kit-orchestrator')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🏗️ FEATURE DEVELOPMENT SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete spec-kit workflow:
1. Run /recall-feature to check for similar past implementations
2. Follow Constitution → Specify → Clarify → Plan phases
3. Implement following the plan
4. Before marking complete: Run /check-integration + /ship-check

Starting with memory search to avoid reinventing solutions...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all workflow steps.

**IMMEDIATE ACTION #4 - RUN MEMORY SEARCH:**
Actually run /recall-feature BEFORE planning (don't skip memory).

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

**IMMEDIATE ACTION #1 - INVOKE SKILLS NOW:**
Execute these commands:
\`\`\`
Skill(command: 'ui-inspiration-finder')
\`\`\`
\`\`\`
Skill(command: 'using-shadcn-ui')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🎨 UI DEVELOPMENT SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Before building from scratch, I will search existing resources:
1. Running /find-ui to search premium UI library
2. If found → Adapt existing component (saves significant time)
3. If not found → Use shadcn/ui blocks (829 production components)
4. Plan error handling patterns
5. Implement with loading states, error states, and proper UX

Let me search the premium library first...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps.

**IMMEDIATE ACTION #4 - RUN LIBRARY SEARCH:**
Actually suggest /find-ui with a specific pattern (don't skip this).

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
    CONTEXT="${CONTEXT}## 🔌 API Contract Design Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'api-contract-design')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔌 API CONTRACT DESIGN SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete API design process:
1. Analyze existing API contracts and dependencies
2. Check for breaking changes
3. Consider API versioning strategy
4. Ensure backward compatibility
5. Validate request/response schemas
6. Document all changes clearly

Starting with contract analysis...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 6 steps above.

**IRON LAW: CONTRACTS ARE SACRED**
- ALWAYS check for breaking changes
- ALWAYS consider versioning
- NEVER break existing integrations

"
fi

# Check for completion claims (Verification required)
if echo "$USER_PROMPT" | grep -qiE "$COMPLETE_PATTERN"; then
    write_active_superflow "✅ Verifying"
    add_header
    CONTEXT="${CONTEXT}## ✅ Verification Before Completion (ENFORCED)

**THIS IS BLOCKING ENFORCEMENT - YOU MUST RESPOND TO THIS MESSAGE**

**IRON LAW: NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE**

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'verification-before-completion')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## ✅ VERIFICATION BEFORE COMPLETION SUPERFLOW: ACTIVE (ENFORCED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will NOT mark work as complete until I:
1. Run /check-integration for full-stack verification (DB → API → Frontend)
2. Run /ship-check for comprehensive validation
3. Gather FRESH evidence from actual command execution
4. Confirm ALL tests pass with real output

I will NOT rely on cached results or assumptions.\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 4 verification steps.

**IMMEDIATE ACTION #4 - RUN VERIFICATION COMMANDS:**
Actually run /check-integration and /ship-check.

**BLOCKING REQUIREMENTS:**
- You CANNOT claim work is complete without running verification
- You CANNOT use cached/old test results
- You MUST provide actual command output as evidence

"
fi

# Check for MVP/rapid prototyping
if echo "$USER_PROMPT" | grep -qiE "$MVP_PATTERN"; then
    write_active_superflow "🚀 Rapid Proto"
    add_header
    CONTEXT="${CONTEXT}## 🚀 Rapid Prototyping Superflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'rapid-prototyping')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🚀 RAPID PROTOTYPING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the MVP development strategy:
1. Determine Build vs Buy vs Integrate for each component
2. Use /find-ui to search for existing UI solutions
3. Leverage shadcn/ui for rapid UI development
4. Implement with quality gates (fast ≠ broken)
5. Run verification-before-completion

Starting with component analysis...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**Strategic Principles:**
- Focus on what NOT to build
- Build vs Buy vs Integrate decision matrix
- Leverage existing resources maximally
- Fast ≠ Broken (maintain quality)

"
fi

# Check for security concerns
SECURITY_PATTERN="security|vulnerability|hack|exploit|attack|auth.*issue|inject|xss|csrf|secure|unsafe|permission|access control|sanitize|escape|validate.*input|sql.*inject|authorization|authentication"
if echo "$USER_PROMPT" | grep -qiE "$SECURITY_PATTERN"; then
    write_active_superflow "🔐 Security"
    add_header
    CONTEXT="${CONTEXT}## 🔐 Security Hardening Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'security-patterns')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔐 SECURITY PATTERNS SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow the complete security review process:
1. Run /security-scan for comprehensive vulnerability analysis
2. Check authentication and authorization
3. Validate all input handling
4. Review secrets management
5. Verify security headers and configuration

Starting with security scan...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**IMMEDIATE ACTION #4 - RUN SECURITY SCAN:**
Actually run /security-scan to identify vulnerabilities.

**IRON LAW: SECURITY FIRST**
- ALWAYS scan before implementing fixes
- NEVER trust client-side data
- ALWAYS validate all user input

"
fi

# Check for performance issues
PERF_PATTERN="slow|performance|latency|optimize.*speed|bottleneck|takes.*long|faster|speed up|improve.*performance|lag|delay|loading.*slow|response.*time|inefficient|sluggish"
if echo "$USER_PROMPT" | grep -qiE "$PERF_PATTERN"; then
    write_active_superflow "⚡ Performance"
    add_header
    CONTEXT="${CONTEXT}## ⚡ Performance Optimization Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'performance-optimization')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## ⚡ PERFORMANCE OPTIMIZATION SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow systematic profiling and optimization:
1. Run /perf-check to identify bottlenecks
2. Profile current performance (before metrics)
3. Optimize highest-impact bottlenecks first
4. Measure improvements (after metrics)
5. Verify no regressions with tests

Starting with performance analysis...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**IMMEDIATE ACTION #4 - RUN PROFILING:**
Actually run /perf-check to profile.

**IRON LAW: PROFILE FIRST, OPTIMIZE SECOND**
- NO optimization without profiling first
- ALWAYS measure impact
- Fix bottlenecks, not symptoms

"
fi

# Check for dependency updates
DEPENDENCY_PATTERN="update.*dependenc|upgrade.*package|npm.*update|vulnerabilit.*package|outdated|install.*package|add.*dependency|library.*update|package.*version|yarn.*upgrade|pnpm.*update"
if echo "$USER_PROMPT" | grep -qiE "$DEPENDENCY_PATTERN"; then
    write_active_superflow "📦 Dependencies"
    add_header
    CONTEXT="${CONTEXT}## 📦 Dependency Update Workflow

**IMMEDIATE ACTION #1 - INVOKE SKILL NOW:**
\`\`\`
Skill(command: 'dependency-management')
\`\`\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 📦 DEPENDENCY MANAGEMENT SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will follow systematic update process:
1. Check current state (npm outdated, npm audit)
2. Use dependency-management skill for strategy
3. Review changelogs for breaking changes
4. Update incrementally (one at a time)
5. Run test suite after each update
6. Verify with /check-integration

Starting with dependency audit...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 6 steps above.

**IMMEDIATE ACTION #4 - RUN AUDIT:**
Actually run npm audit and npm outdated.

**IRON LAW: INCREMENTAL UPDATES**
- ONE package at a time
- TEST after each update
- NEVER batch security + feature updates
- Isolate failures immediately

"
fi

# Check for code explanation requests (HIGHER PRIORITY - more specific than learning)
if echo "$USER_PROMPT" | grep -qiE "$EXPLAIN_PATTERN"; then
    write_active_superflow "📖 Code Explanation"
    add_header
    CONTEXT="${CONTEXT}## 📖 Code Explanation Workflow

**IMMEDIATE ACTION #1 - RUN COMMAND:**
Execute: \`SlashCommand(command: '/explain-code')\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 📖 CODE EXPLANATION SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will provide comprehensive code explanation:
1. Run /explain-code for historical context
2. Show design rationale and architecture decisions
3. Provide concrete examples from the codebase
4. Explain dependencies and relationships
5. Create memory observation for future reference

Starting with code analysis...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 5 steps above.

**EXPLANATION PRINCIPLES:**
- Show, don't just tell
- Historical context (why code exists)
- Design rationale (why this approach)
- Concrete examples from THIS codebase

"
fi

# Check for pattern recall (HIGHER PRIORITY - specific memory query)
if echo "$USER_PROMPT" | grep -qiE "$PATTERN_RECALL"; then
    write_active_superflow "🔍 Pattern Recall"
    add_header
    CONTEXT="${CONTEXT}## 🔍 Pattern Recall Workflow

**IMMEDIATE ACTION #1 - RUN COMMAND:**
Execute: \`SlashCommand(command: '/recall-pattern')\`

**IMMEDIATE ACTION #2 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔍 PATTERN RECALL SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will search project memory for implementation patterns:
1. Run /recall-pattern to query memory
2. Find similar past implementations
3. Show what worked (and what didn't)
4. Apply learnings to current situation

Starting with memory search...\"

**IMMEDIATE ACTION #3 - CREATE TODO LIST:**
Use TodoWrite with all 4 steps above.

**MEMORY PRINCIPLES:**
- Search before implementing
- Learn from past solutions
- Avoid repeating mistakes

"
fi

# Check for learning/explanation requests (LOWER PRIORITY - catches broader patterns)
LEARNING_PATTERN="learn|teach me|how does.*work|explain|understand|what is|show me how|tutorial|guide|documentation|best practice|how to|walk.*through|show.*example"
if echo "$USER_PROMPT" | grep -qiE "$LEARNING_PATTERN"; then
    write_active_superflow "🎓 Learning"
    add_header
    CONTEXT="${CONTEXT}## 🎓 Learning Mode Workflow

**IMMEDIATE ACTION #1 - OUTPUT ACTIVATION MESSAGE:**
\"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🎓 LEARNING/ONBOARDING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will provide comprehensive explanation:
1. Run /explain-code for historical context
2. Use /recall-pattern for similar implementations
3. Provide architectural overview
4. Show concrete examples from THIS codebase
5. Suggest practice exercises
6. Create memory observation for future reference

Starting with code analysis...\"

**IMMEDIATE ACTION #2 - CREATE TODO LIST:**
Use TodoWrite with all 6 steps above.

**IMMEDIATE ACTION #3 - RUN CONTEXT COMMANDS:**
Actually run /explain-code and /recall-pattern for context.

**LEARNING PRINCIPLES:**
- Show, don't just tell
- Use concrete examples from THIS codebase
- Build on existing knowledge
- Make it interactive - ask clarifying questions
- Create memory observation when done

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
