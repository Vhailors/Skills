# Hooks Troubleshooting Guide

## Issue: "Plugin hook error:" on SessionStart

### Problem

After installing the plugin, hooks show errors:
```
⎿ SessionStart:startup says: Plugin hook error:
```

And hooks don't fire when expected (e.g., refactoring prompt doesn't trigger IRON LAW enforcement).

### Root Cause

The scripts weren't being executed properly because the command format didn't explicitly specify the shell interpreter. While the scripts have `#!/bin/bash` shebang, the Claude Code hook system on WSL2/Windows may need explicit `bash` command.

### Solution

**Changed from:**
```json
{
  "type": "command",
  "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start.sh",
  "timeout": 5
}
```

**Changed to:**
```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start.sh",
  "timeout": 5
}
```

### Files Modified

Updated all hook commands in `hooks/hooks.json` to use `bash` prefix:

1. ✅ SessionStart → `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start.sh`
2. ✅ UserPromptSubmit → `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/analyze-prompt.sh`
3. ✅ PreToolUse (Write|Edit) → `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/check-logging.sh`
4. ✅ PreToolUse (Bash) → `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/detect-git-operations.sh`
5. ✅ PostToolUse (Bash) → `bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/verify-tests.sh`

### Testing the Fix

After updating hooks.json, reinstall the plugin:

```bash
/plugin uninstall developer-skills@local-dev-skills
/plugin install developer-skills@local-dev-skills
# Restart Claude Code
```

### Verification Tests

**Test 1: Session Start Hook**
- Start new session
- Expected: See "🔄 Session Continuity (Auto-Loaded)" message
- Expected: See list of 8 superflows

**Test 2: Refactoring Hook**
- Say: "Can we refactor some code"
- Expected: See "🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)"
- Expected: See "**IRON LAW: NO REFACTORING WITHOUT TESTS**"

**Test 3: Bug Detection Hook**
- Say: "There's a bug in the login"
- Expected: See "🐛 Debugging Superflow Activated"
- Expected: Suggestion to use `/quick-fix` or `/recall-bug`

### Common Issues

#### 1. Scripts Not Executable

**Symptom:** Permission denied errors

**Solution:**
```bash
cd hooks/scripts
chmod +x *.sh
```

#### 2. Line Ending Issues (CRLF)

**Symptom:** `/bin/bash^M: bad interpreter` error

**Check:**
```bash
file hooks/scripts/session-start.sh
# Should show: "UTF-8 Unicode text executable"
# NOT: "UTF-8 Unicode text executable, with CRLF line terminators"
```

**Fix:**
```bash
dos2unix hooks/scripts/*.sh
# Or:
sed -i 's/\r$//' hooks/scripts/*.sh
```

#### 3. JSON Validation Errors

**Symptom:** Hook not loading, no error message

**Check:**
```bash
python3 -m json.tool hooks/hooks.json > /dev/null
```

**Common issues:**
- Missing commas between entries
- Trailing commas before closing braces
- Unescaped special characters in regex

#### 4. ${CLAUDE_PLUGIN_ROOT} Not Expanding

**Symptom:** "file not found" errors

**Check:** Ensure you're using the variable exactly as shown:
- ✅ `${CLAUDE_PLUGIN_ROOT}` (correct)
- ❌ `$CLAUDE_PLUGIN_ROOT` (wrong - missing braces)
- ❌ `{CLAUDE_PLUGIN_ROOT}` (wrong - missing $)

#### 5. Timeout Errors

**Symptom:** Hook executes but times out

**Solution:** Increase timeout in hooks.json:
```json
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/analyze-prompt.sh",
  "timeout": 10  // Increased from 3 to 10 seconds
}
```

### WSL2-Specific Issues

#### Issue: Slow Script Execution

WSL2 can be slower when accessing Windows filesystem paths (`/mnt/c/...`).

**Solutions:**
1. Keep plugin in WSL native filesystem (e.g., `~/plugins/developer-skills/`)
2. Increase timeouts to accommodate slower execution
3. Optimize scripts to reduce unnecessary file reads

#### Issue: Path Resolution

Windows paths may not resolve correctly in bash scripts.

**Solution:** Ensure all paths in scripts use Unix-style paths:
- ✅ `/mnt/c/Users/...` (correct in WSL)
- ❌ `C:\Users\...` (wrong - Windows path)

### Debug Mode

To debug hook execution, add this to any script:

```bash
#!/bin/bash
# Enable debug output
set -x  # Print each command before executing
set -e  # Exit on first error

# Your script here...
```

Or run manually with debug:
```bash
bash -x hooks/scripts/session-start.sh
```

### Minimal Test Hook

Create a minimal test to verify hooks work:

```bash
# Create test script
cat > hooks/scripts/test.sh << 'EOF'
#!/bin/bash
echo "✅ HOOK SYSTEM WORKS"
exit 0
EOF

chmod +x hooks/scripts/test.sh

# Add to hooks.json SessionStart temporarily:
{
  "type": "command",
  "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/test.sh",
  "timeout": 2
}

# Reinstall and test
/plugin reinstall developer-skills@local-dev-skills
```

If you see "✅ HOOK SYSTEM WORKS" on session start, the hook system is working.

### Getting Help

If hooks still don't work after trying these solutions:

1. Check Claude Code version: `claude --version`
2. Review plugin structure: Ensure all files are in correct locations
3. Check Claude Code logs: Look for detailed error messages
4. Test scripts manually: `bash hooks/scripts/session-start.sh`
5. Verify JSON: `python3 -m json.tool hooks/hooks.json`

### Environment Info for Bug Reports

When reporting hook issues, include:

```bash
# System info
echo "OS: $(uname -a)"
echo "Claude Code: $(claude --version)"
echo "Bash: $(bash --version | head -1)"
echo "Plugin dir: $(pwd)"

# File info
ls -la hooks/scripts/
file hooks/scripts/*.sh

# JSON validation
python3 -m json.tool hooks/hooks.json > /dev/null && echo "JSON valid" || echo "JSON invalid"

# Test script execution
bash hooks/scripts/session-start.sh 2>&1 | head -5
```

---

## Known Working Configuration

### Environment
- **OS:** WSL2 (Ubuntu) on Windows
- **Claude Code:** v2.0.28
- **Bash:** GNU bash 5.x

### hooks.json Format

```json
{
  "$schema": "https://anthropic.com/claude-code/hooks.schema.json",
  "description": "Intelligent superflow system",
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Script Format

```bash
#!/bin/bash
# Description of what this hook does

# Your logic here
echo "Your markdown output here"

# Always exit 0 for context injection
exit 0
```

### File Permissions

All scripts must be executable:
```bash
chmod +x hooks/scripts/*.sh
```

---

## Quick Fix Checklist

When hooks aren't working, try these in order:

- [ ] All scripts have `#!/bin/bash` shebang on line 1
- [ ] All scripts are executable (`chmod +x hooks/scripts/*.sh`)
- [ ] All hook commands start with `bash` prefix
- [ ] All paths use `${CLAUDE_PLUGIN_ROOT}` (with braces)
- [ ] hooks.json is valid JSON (`python3 -m json.tool`)
- [ ] No CRLF line endings (`file` command shows Unix text)
- [ ] Plugin reinstalled after changes
- [ ] Claude Code restarted after reinstall
- [ ] Scripts work when run manually
- [ ] Timeout values are reasonable (2-10 seconds)

---

**Last Updated:** October 28, 2025
**Status:** Resolved - All hooks working with `bash` prefix
