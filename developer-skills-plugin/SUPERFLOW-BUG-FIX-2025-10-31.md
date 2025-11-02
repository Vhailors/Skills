# Superflow Not Triggering - Root Cause & Fix

**Date:** October 31, 2025
**Issue:** Pixel-perfect site copy superflow was not injecting context into Claude Code sessions
**Status:** ✅ FIXED

## Problem

When users typed "copy site [URL]", the superflow hook was:
1. ✅ Running successfully (hook callbacks showed "Success")
2. ✅ Detecting the pattern correctly
3. ✅ Generating the context markdown
4. ❌ **Outputting invalid JSON** that Claude Code couldn't parse

## Root Cause

In `hooks/scripts/analyze-prompt.sh` at **line 169**, the copy-site pattern handler had:

```bash
echo "$CONTEXT"
exit 0
```

This caused the script to:
- Output raw markdown directly (not wrapped in JSON)
- Exit early before reaching the JSON wrapper (lines 696-709)
- Return invalid output that Claude Code couldn't parse

**All other patterns** (refactoring, debugging, feature dev, etc.) correctly let the context flow to the JSON wrapper at the bottom of the script.

## The Fix

**Removed lines 169-170:**
```diff
"
-    echo "$CONTEXT"
-    exit 0
fi
```

Now the copy-site pattern behaves like all other patterns:
1. Sets the `$CONTEXT` variable
2. Lets execution continue to the bottom
3. Gets properly wrapped in JSON at lines 696-709

## Verification

**Before fix:**
```bash
echo '{"prompt":"copy site https://gitingest.com/"}' | bash analyze-prompt.sh | python3 -m json.tool
# Result: "Expecting value: line 3 column 1 (char 2)" - INVALID JSON
```

**After fix:**
```bash
echo '{"prompt":"copy site https://gitingest.com/"}' | bash analyze-prompt.sh | python3 -m json.tool
# Result: Valid JSON with hookSpecificOutput.additionalContext containing the superflow instructions
```

## How to Apply

Users need to reinstall the plugin for the fix to take effect:

```bash
/plugin uninstall developer-skills@local-dev-skills
/plugin install developer-skills@local-dev-skills
# Restart Claude Code if needed
```

## Testing

After applying the fix, test with:
```
copy site https://example.com
```

**Expected behavior:**
1. You should see the superflow activation message with the emoji banner
2. Claude should output: "🎨 PIXEL-PERFECT SITE COPY: ACTIVE"
3. Claude should create a TodoWrite with all workflow steps
4. Claude should invoke the pixel-perfect-site-copy skill

## Impact

This bug affected ONLY the pixel-perfect site copy superflow. All other superflows (refactoring, debugging, feature dev, UI dev, etc.) were working correctly because they didn't have the early echo/exit.

## Related Issues

- Session #S61: "Investigate why superflow wasn't triggered"
- Session #S50: "Investigation into why superflow wasn't triggered from the local dev plugin"
- Observation #173: "SDK Plugin Loading Not Configured in Worker Service"

## Prevention

Added verification to check that all pattern handlers in `analyze-prompt.sh`:
- Set `$CONTEXT` variable
- Do NOT echo context directly
- Do NOT exit early
- Let execution flow to JSON wrapper at bottom

---

**Fixed by:** Claude Code debugging session
**Files Modified:**
- `hooks/scripts/analyze-prompt.sh` (line 169-170 removed)
