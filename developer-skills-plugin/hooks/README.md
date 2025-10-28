# Developer Skills Plugin: Hooks System

## Overview

This hooks system implements **intelligent context injection** to enable all 8 superflows defined in [SUPERFLOWS.md](../SUPERFLOWS.md). Using Claude Code's native hook system, we inject workflow instructions that guide Claude's behavior automatically.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     USER INTERACTION                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              HOOK LAYER (5 Bash Scripts)                     │
│                                                               │
│  SessionStart Hook     → session-start.sh                    │
│  UserPromptSubmit Hook → analyze-prompt.sh                   │
│  PreToolUse Hook       → check-logging.sh                    │
│  PreToolUse Hook       → detect-git-operations.sh            │
│  PostToolUse Hook      → verify-tests.sh                     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼ (stdout becomes Claude's context)
┌─────────────────────────────────────────────────────────────┐
│           INJECTED SUPERFLOW INSTRUCTIONS                    │
│                                                               │
│  Pattern: "refactor" → Inject refactoring safety protocol    │
│  Pattern: "bug"      → Inject debugging superflow            │
│  Pattern: "feature"  → Inject spec-kit workflow              │
│  Pattern: "ui"       → Inject UI library check               │
│  Pattern: "complete" → Inject verification requirements      │
│  Pattern: "git"      → Inject pre-ship validation            │
│  Pattern: "test"     → Inject test verification protocol     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              CLAUDE ORCHESTRATION                            │
│                                                               │
│  Reads injected instructions + Skills + Commands             │
│  Reasons about which workflow to follow                      │
│  Executes superflow steps automatically                      │
└─────────────────────────────────────────────────────────────┘
```

## Hook Configuration

All hooks are configured in `hooks.json` using plugin-scoped paths with `${CLAUDE_PLUGIN_ROOT}`:

```json
{
  "hooks": {
    "SessionStart": [...],       // Loads superflow system awareness
    "UserPromptSubmit": [...],   // Pattern detection for all workflows
    "PreToolUse": [
      {...},                     // Logging schema enforcement (Write|Edit)
      {...}                      // Git operation detection (Bash)
    ],
    "PostToolUse": [...]         // Test verification (Bash)
  }
}
```

## Active Hooks

### 1. Session Start Hook (`session-start.sh`)

**Event:** `SessionStart`
**Triggers:** Every time a Claude Code session starts
**Purpose:** Auto-loads superflow system awareness

**What it does:**
- Lists all 8 available superflows
- Suggests checking recent context
- Prepares Claude to use memory-based commands

**Superflows activated:** Session Start Superflow

---

### 2. User Prompt Analysis Hook (`analyze-prompt.sh`)

**Event:** `UserPromptSubmit`
**Triggers:** Every user message submission
**Purpose:** Pattern detection and workflow injection

**Patterns detected:**

| Pattern | Superflow Injected | Enforcement Level |
|---------|-------------------|-------------------|
| `refactor\|rewrite\|clean up` | Refactoring Safety Protocol | **IRON LAW** (Enforced) |
| `bug\|error\|issue\|broken` | Debugging Superflow | Suggest |
| `implement\|build.*feature` | Feature Development Superflow | Remind |
| `ui\|component\|hero\|card` | UI Development Superflow | Suggest |
| `api.*change\|modify` | API Contract Design | Remind |
| `done\|complete\|finished` | Verification Before Completion | **IRON LAW** (Enforced) |
| `mvp\|prototype\|poc\|quick` | Rapid Prototyping Superflow | Remind |
| `what does\|explain` | Code Explanation | Suggest |
| `how did we\|pattern` | Pattern Recall | Suggest |

**Superflows activated:**
- Feature Development
- Debugging
- Refactoring
- UI Development
- API Contract Design
- Pre-Ship Validation
- Rapid Prototyping

---

### 3. Logging Schema Enforcement Hook (`check-logging.sh`)

**Event:** `PreToolUse`
**Matcher:** `Write|Edit`
**Triggers:** Before Write/Edit operations containing logging code
**Purpose:** Enforce standardized logging schema

**Detection:** Regex match for `log|logger|console.`

**What it enforces:**
- Check project's logging schema first
- Use consistent field names
- Include correlation IDs
- Follow structured logging format

**Enforcement level:** **IRON LAW** (Strong reminder)

**Related skill:** `standardized-logging`

---

### 4. Git Operation Detection Hook (`detect-git-operations.sh`)

**Event:** `PreToolUse`
**Matcher:** `Bash`
**Triggers:** Before `git commit`, `git push`, or `git add` commands
**Purpose:** Trigger pre-ship validation superflow

**What it suggests:**
- Run `/check-integration` for full-stack verification
- Run `/ship-check` for comprehensive validation
- Use `verification-before-completion` skill
- Generate changelog with `changelog-generator`

**Enforcement level:** Strong reminder (not blocking)

**Superflows activated:** Pre-Ship Validation Superflow

---

### 5. Test Verification Hook (`verify-tests.sh`)

**Event:** `PostToolUse`
**Matcher:** `Bash`
**Triggers:** After test/build/lint commands execute
**Purpose:** Ensure test results are properly interpreted

**Detection patterns:**
- Test commands: `npm test`, `pytest`, `jest`, `cargo test`, etc.
- Build commands: `npm build`, `cargo build`, `mvn package`, etc.
- Lint commands: `eslint`, `prettier`, `black`, `rustfmt`, etc.

**What it enforces:**
- Read actual test output (don't assume)
- Interpret results correctly (all must pass)
- Provide evidence of success
- Use `systematic-debugging` if tests fail

**Enforcement level:** **IRON LAW** (Evidence required)

**Related skill:** `verification-before-completion`

---

## Enforcement Levels

### Iron Laws (Strongest)

Using **bold directive language** to create psychological enforcement:

- **Refactoring Safety:** "**IRON LAW: NO REFACTORING WITHOUT TESTS**"
- **Logging Schema:** "**IRON LAW: NO LOGGING CODE WITHOUT CHECKING SCHEMA FIRST**"
- **Verification:** "**NO COMPLETION CLAIMS WITHOUT FRESH EVIDENCE**"

These create effective enforcement through strong instruction-following.

### Suggestions (Medium)

Using "Suggest" language:
- "Should I check `/find-ui` for existing components?"
- "Running `/recall-bug` to check if this is a known issue..."
- "Would you like me to run `/explain-code` for comprehensive understanding?"

### Reminders (Gentle)

Using contextual awareness:
- "🎯 **Feature Development Superflow**: Steps..."
- "⚠️ **Error Handling**: Plan error handling upfront..."
- "🔌 **API Contract Design**: Consider versioning..."

---

## How Context Injection Works

### Input Sources

Hooks receive information through environment variables:

- `$CLAUDE_TOOL_NAME` - The tool being used (Write, Edit, Bash, etc.)
- `$CLAUDE_TOOL_PARAMS` - Parameters passed to the tool
- `$CLAUDE_PROJECT_DIR` - Project root directory
- stdin - JSON data for some hook types (UserPromptSubmit)

### Output Method

All hooks use **stdout for context injection**:

```bash
echo "## 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)"
echo "**IRON LAW: NO REFACTORING WITHOUT TESTS**"
echo "1. Check if tests exist"
echo "2. Create tests first if missing"
```

This markdown-formatted output becomes part of Claude's context.

### Exit Codes

- `0` - Success, inject context (most hooks use this)
- `2` - Blocking error, stderr fed to Claude (not currently used)

---

## Superflow Coverage

All 8 superflows from [SUPERFLOWS.md](../SUPERFLOWS.md) are covered:

| Superflow | Hook(s) | Status |
|-----------|---------|--------|
| 1. Feature Development | analyze-prompt.sh | ✅ Active |
| 2. Debugging | analyze-prompt.sh | ✅ Active |
| 3. Refactoring | analyze-prompt.sh | ✅ Active (Enforced) |
| 4. UI Development | analyze-prompt.sh | ✅ Active |
| 5. Pre-Ship Validation | detect-git-operations.sh, verify-tests.sh | ✅ Active |
| 6. Rapid Prototyping | analyze-prompt.sh | ✅ Active |
| 7. Session Start | session-start.sh | ✅ Active (Auto) |
| 8. Skill Creation | analyze-prompt.sh | ✅ Active |

**Additional enforcement:**
- Logging schema enforcement via check-logging.sh
- Test verification enforcement via verify-tests.sh

---

## Plugin Installation

### For Users

The hooks system is automatically available when you install the plugin:

```bash
/plugin install developer-skills@local-dev-skills
```

Hooks are loaded from the plugin directory using `${CLAUDE_PLUGIN_ROOT}`.

### For Developers

To test hook changes:

1. Modify scripts in `hooks/scripts/`
2. Ensure scripts are executable: `chmod +x hooks/scripts/*.sh`
3. Reinstall plugin to reload hooks:
   ```bash
   /plugin uninstall developer-skills@local-dev-skills
   /plugin install developer-skills@local-dev-skills
   ```
4. Restart Claude Code

---

## Testing Hooks

### Test Scenarios

**Test 1: Refactoring Enforcement**
```
User: "Can we refactor some code on FE side"
Expected: Claude receives IRON LAW message, checks for tests first
```

**Test 2: Debugging Fast Path**
```
User: "Login is broken"
Expected: Claude suggests /quick-fix or /recall-bug, checks memory first
```

**Test 3: Feature Development**
```
User: "Implement user profile feature"
Expected: Claude suggests /recall-feature, mentions spec-kit workflow
```

**Test 4: UI Library Check**
```
User: "Build a pricing component"
Expected: Claude suggests /find-ui before building from scratch
```

**Test 5: Completion Verification**
```
User: "I'm done with the feature"
Expected: Claude suggests /check-integration and /ship-check
```

**Test 6: Pre-Commit Validation**
```
User/Claude: Runs "git commit -m 'message'"
Expected: Hook suggests /ship-check before committing
```

**Test 7: Test Verification**
```
User/Claude: Runs "npm test"
Expected: Hook reminds to read output and verify all tests pass
```

**Test 8: Logging Enforcement**
```
User/Claude: Writes code with console.log()
Expected: Hook reminds to check logging schema
```

---

## Script Reference

### session-start.sh

- **Lines of code:** 42
- **Timeout:** 5 seconds
- **Output:** Markdown list of 8 superflows + context check suggestion
- **Exit:** Always 0 (success)

### analyze-prompt.sh

- **Lines of code:** 153
- **Timeout:** 3 seconds
- **Patterns:** 9 regex patterns for workflow detection
- **Output:** Conditional markdown based on pattern matches
- **Exit:** Always 0 (success)

### check-logging.sh

- **Lines of code:** 38
- **Timeout:** 2 seconds
- **Detection:** `log|logger|console\.` in Write/Edit params
- **Output:** IRON LAW enforcement message
- **Exit:** 0 (currently non-blocking)

### detect-git-operations.sh

- **Lines of code:** 51
- **Timeout:** 3 seconds
- **Detection:** `git commit|push|add` in Bash commands
- **Output:** Pre-ship validation checklist
- **Exit:** Always 0 (success)

### verify-tests.sh

- **Lines of code:** 55
- **Timeout:** 2 seconds
- **Detection:** Test/build/lint commands
- **Output:** Post-test verification protocol
- **Exit:** Always 0 (success)

---

## Maintenance

### Adding New Patterns

To add new workflow patterns to `analyze-prompt.sh`:

1. Define pattern variable at top:
   ```bash
   NEW_PATTERN="keyword1|keyword2|phrase"
   ```

2. Add detection block:
   ```bash
   if echo "$USER_PROMPT" | grep -qiE "$NEW_PATTERN"; then
       output_instructions
       echo "## Your Superflow Here"
       echo "Instructions..."
   fi
   ```

3. Test with sample user prompts

### Adjusting Enforcement Strength

To change enforcement level, modify the language:

- **Enforce:** Use "**IRON LAW:**", "**MUST**", "non-negotiable"
- **Suggest:** Use "Suggest:", "Would you like...", "Consider..."
- **Remind:** Use "Remember:", "Don't forget...", "Keep in mind..."

### Debugging Hooks

Use the included `debug-env.sh` to inspect hook environment variables:

```bash
# Add to any hook for debugging
source ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/debug-env.sh
```

---

## Advantages

### ✅ Preserved Intelligence
- All 8 superflows maintained
- Pattern detection intact
- Enforcement mechanisms preserved

### ✅ Works Within Constraints
- Uses only bash commands (Claude Code limitation)
- Context injection (allowed by stdout)
- No unsupported features attempted

### ✅ Maintainable
- Scripts are simple bash
- Easy to add new patterns
- Easy to adjust instruction strength

### ✅ Transparent
- User sees nothing (runs in background)
- Claude sees helpful context
- No confusing errors

### ✅ Extensible
- Add new patterns to analyze-prompt.sh
- Add new hooks for other events
- Create specialized scripts for specific workflows

---

## Future Enhancements

### Possible Additions

1. **Pre-Notification Hook** - Respond to permission requests
2. **Pre-Compact Hook** - Prepare context before compaction
3. **SubagentStop Hook** - Post-process agent results
4. **Project-Specific Patterns** - Detect project conventions from config

### Dynamic Pattern Detection

Could enhance analyze-prompt.sh to:
- Read `.claude/patterns.json` for custom patterns
- Learn from claude-mem what patterns matter
- Adjust enforcement strength based on project phase

---

## Comparison: Before vs After

### Before (Didn't Work)
```json
{
  "action": {
    "type": "auto-run",           // ❌ Not supported
    "command": "/continue-work"   // ❌ Slash commands don't work in hooks
  }
}
```

### After (Works!)
```bash
# Hook script outputs to stdout
echo "## 🔄 Session Continuity"
echo "Would you like to continue where you left off?"
# Claude reads this and acts on it naturally
exit 0
```

---

## Conclusion

The hooks system successfully implements all 8 superflows through intelligent context injection. What initially seemed like a limitation (bash-only hooks) became an advantage—simpler, more transparent, and equally effective.

**The system now:**
- ✅ Detects all the same patterns
- ✅ Enforces iron laws through strong language
- ✅ Suggests commands at the right moments
- ✅ Reminds about workflows when appropriate
- ✅ Works reliably within Claude Code's architecture

**No intelligence was lost—it was transformed into a more robust form.**

---

## Related Documentation

- [SUPERFLOWS.md](../SUPERFLOWS.md) - Complete superflow definitions
- [SUPERFLOWS-IMPLEMENTATION.md](../SUPERFLOWS-IMPLEMENTATION.md) - Implementation strategy
- [HOOK-MAPPING.md](./HOOK-MAPPING.md) - Original to implementation mapping
- [Claude Code Hooks Documentation](https://docs.claude.com/en/docs/claude-code/hooks)

---

## Metadata

- **Total Hooks:** 5 scripts
- **Total Superflows:** 8
- **Total Patterns:** 9+ detection patterns
- **Enforcement Hooks:** 4 (refactoring, logging, pre-commit, tests)
- **Suggestion Hooks:** 5+ (debug, UI, explain, pattern recall, etc.)
- **Auto-Triggered:** 1 (session-start on every session)
- **Lines of Code:** ~339 lines across all scripts
