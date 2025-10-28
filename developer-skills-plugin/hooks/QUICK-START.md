# Quick Start: Activating Superflows

## What Changed

The hooks have been updated to use **proper JSON output format** that Claude Code requires to inject context into the AI's system prompt.

**Before:** Hooks output markdown to stdout (didn't work)
**After:** Hooks output JSON with `additionalContext` field (works!)

## Installation Steps

### 1. Reinstall the Plugin

Since the hook scripts were updated, you need to reinstall the plugin:

```bash
claude plugin uninstall developer-skills@local-dev-skills
claude plugin install /mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin
```

Or if using Windows path:
```powershell
claude plugin uninstall developer-skills@local-dev-skills
claude plugin install C:\Users\Dominik\Documents\Skills\developer-skills-plugin
```

### 2. Restart Claude Code

After reinstalling, **completely restart Claude Code** (not just a new session).

### 3. Test the Superflows

Try these prompts in a new session to verify the hooks are working:

**Test 1: Refactoring (IRON LAW enforcement)**
```
Can we refactor some code?
```

**Expected:** You should see in Claude's response that it mentions:
- 🛡️ REFACTORING SAFETY PROTOCOL (ENFORCED)
- **IRON LAW: NO REFACTORING WITHOUT TESTS**
- Steps to check for tests first

**Test 2: Bug Detection**
```
There's a bug in the login system
```

**Expected:** Claude should mention:
- 🐛 Debugging Superflow
- Suggests `/quick-fix` or `/recall-bug`
- Memory search for similar bugs

**Test 3: Feature Development**
```
Let's implement a new dashboard feature
```

**Expected:** Claude should mention:
- 🏗️ Feature Development Superflow
- `/recall-feature` command
- Spec-kit workflow

**Test 4: UI Development**
```
Build a pricing component
```

**Expected:** Claude should mention:
- 🎨 UI Development Superflow
- `/find-ui` command
- shadcn/ui blocks

## How It Works

### Pattern Detection

The `analyze-prompt.sh` hook watches for keywords in your prompts:

| Pattern | Keywords | Superflow Activated |
|---------|----------|---------------------|
| Refactoring | refactor, rewrite, restructure | Safety Protocol (ENFORCED) |
| Debugging | bug, error, issue, broken | Debugging with memory |
| Features | implement, build, create feature | Spec-kit workflow |
| UI | ui, component, hero, pricing | Library search first |
| Completion | done, complete, finished | Verification required |
| MVP | mvp, prototype, poc, quick | Rapid prototyping |

### Context Injection

When a pattern is detected, the hook outputs JSON:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "... intelligent workflow instructions ..."
  }
}
```

Claude Code injects this context into my system prompt **before** I see your message, so I automatically know which workflow to follow.

## Verification Checklist

After reinstalling and restarting, verify:

- [ ] Scripts are executable: `ls -la hooks/scripts/*.sh` shows `-rwxr-xr-x`
- [ ] JSON is valid: `python3 -m json.tool hooks/hooks.json > /dev/null`
- [ ] Plugin is installed: `claude plugin list` shows `developer-skills@local-dev-skills`
- [ ] Hooks are registered: Check sessionStart callback success messages
- [ ] Pattern detection works: Test with "Can we refactor some code?"
- [ ] Context is injected: Claude mentions IRON LAW and protocol steps

## Troubleshooting

**Problem:** Hooks still not working after reinstall

1. Check script permissions:
   ```bash
   chmod +x /mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin/hooks/scripts/*.sh
   ```

2. Test manually to verify output:
   ```bash
   echo '{"prompt": "Can we refactor"}' | bash analyze-prompt.sh
   ```

3. Verify plugin path in hooks.json uses `${CLAUDE_PLUGIN_ROOT}`

4. Check for CRLF line endings (WSL issue):
   ```bash
   file hooks/scripts/analyze-prompt.sh
   # Should NOT show "CRLF line terminators"
   ```

5. See `TROUBLESHOOTING.md` for detailed debugging

## Success Indicators

When working correctly, you'll notice:

✅ **Immediate Awareness** - I know about superflows when session starts
✅ **Smart Suggestions** - I suggest commands like `/quick-fix` when appropriate
✅ **Enforcement** - I refuse to refactor without checking tests first
✅ **Workflow Guidance** - I follow structured workflows automatically
✅ **Memory Integration** - I search past work before starting new work

## Next Steps

Once verified working:

1. **Use naturally** - Just describe what you want, hooks activate automatically
2. **Watch for suggestions** - I'll recommend slash commands at the right time
3. **Trust enforcement** - Iron laws prevent mistakes (tests, verification)
4. **Leverage memory** - Past solutions speed up current work

The superflows are now **active and automated** - no manual invocation needed!
