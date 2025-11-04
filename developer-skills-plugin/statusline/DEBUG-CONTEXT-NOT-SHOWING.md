# Debug: Context Not Showing in Claude Code

If the context indicator (🧠 Context: X%) is not appearing in your statusline when using Claude Code, follow these steps to diagnose the issue.

## Step 1: Enable Debug Mode

Temporarily replace your statusline with the debug version:

```bash
# Backup current statusline
cp ~/.claude/statusline.sh ~/.claude/statusline.sh.backup

# Install debug version
cp developer-skills-plugin/statusline/statusline-debug.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

## Step 2: Use Claude Code

1. Restart Claude Code (if needed)
2. Have a conversation (send a few messages)
3. The statusline should show "DEBUG MODE"

## Step 3: Check Debug Log

```bash
cat ~/.claude/statusline-debug.log
```

### What to Look For:

#### ✅ **Good - Getting JSON Data:**
```
=== 2025-10-29 14:30:00 ===
PWD: /home/user/project
STDIN length: 245 chars
STDIN data:
{"model":"claude-sonnet-4-5","tokensUsed":42000,"tokensTotal":200000,"sessionId":"abc123"}
---
Parsed JSON fields:
model
tokensUsed
tokensTotal
sessionId
```

If you see this, Claude Code IS sending data! The issue is with field names.

#### ❌ **Bad - No Data:**
```
=== 2025-10-29 14:30:00 ===
PWD: /home/user/project
STDIN length: 0 chars
NO STDIN DATA (running interactively or Claude Code not passing data)
```

If you see this, Claude Code is NOT sending stdin data to the statusline.

## Step 4: Diagnose Based on Results

### If Getting JSON (Good):

1. Check which field names are present
2. Update `statusline.sh` to match the actual field names
3. Common patterns to check:
   - Token fields: `tokensUsed`, `tokens_used`, `input_tokens`, `total_tokens`
   - Context fields: `contextRemaining`, `context_remaining`, `context_window_remaining`

#### Example Fix:

If log shows:
```json
{"total_tokens": 200000, "input_tokens": 42000}
```

Update `parse_json_field` calls in `context_remaining()`:

```bash
tokens_used=$(parse_json_field "input_tokens")
tokens_total=$(parse_json_field "total_tokens")
```

### If NOT Getting JSON (Bad):

This means Claude Code isn't passing stdin data. Possible causes:

#### 1. **Wrong Configuration Format**

Check `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

**NOT** (wrong):
```json
{
  "statusLine": "~/.claude/statusline.sh"
}
```

#### 2. **Script Not Executable**

```bash
chmod +x ~/.claude/statusline.sh
```

#### 3. **Claude Code Version**

Context tracking via stdin may not be available in all Claude Code versions. Check the docs:
https://docs.claude.com/en/docs/claude-code/statusline

#### 4. **Alternative: Use Environment Variable**

If stdin data is not available, set it manually in your shell config:

```bash
# Add to ~/.bashrc or ~/.zshrc
export CLAUDE_CONTEXT_REMAINING=85
```

Then restart Claude Code.

## Step 5: Restore Original Statusline

Once debugging is complete:

```bash
# Restore backup
cp ~/.claude/statusline.sh.backup ~/.claude/statusline.sh

# Or install fresh copy
cp developer-skills-plugin/statusline/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

## Testing Without Claude Code

Test JSON parsing manually:

```bash
# Test with camelCase fields
echo '{"tokensUsed": 40000, "tokensTotal": 200000}' | ~/.claude/statusline.sh

# Test with snake_case fields
echo '{"tokens_used": 40000, "tokens_total": 200000}' | ~/.claude/statusline.sh

# Expected: Should show context percentage on line 2
```

If manual test works but Claude Code doesn't, the issue is with what Claude Code is sending (or not sending).

## Need Help?

Include this info when reporting the issue:

1. Contents of `~/.claude/statusline-debug.log`
2. Your `~/.claude/settings.json` statusLine config
3. Output of: `~/.claude/statusline.sh --version` or `head -5 ~/.claude/statusline.sh`
4. Claude Code version
