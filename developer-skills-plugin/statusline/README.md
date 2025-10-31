# Developer-Skills Statusline

**Technical, concise status display for Claude Code**

## What It Shows

### Line 1: Session State
```
📁 project  🌿 branch  🛡️ Active-Superflow  🧠 95% [=========-]
```

### Line 2: Changes & Memory
```
📝 +102/-45  🧠 Memory: 271 obs  📝 Last: Hook blocking fix (#267)
```

## Installation

### Option 1: Manual Setup

1. **Copy statusline script**
   ```bash
   cp developer-skills-plugin/statusline/statusline.sh ~/.claude/statusline.sh
   chmod +x ~/.claude/statusline.sh
   ```

2. **Configure Claude Code**

   Edit `~/.claude/settings.json`:
   ```json
   {
     "statusLine": "~/.claude/statusline.sh"
   }
   ```

3. **Restart Claude Code**

### Option 2: Project-Specific

1. **Copy to project**
   ```bash
   mkdir -p .claude
   cp developer-skills-plugin/statusline/statusline.sh .claude/statusline.sh
   chmod +x .claude/statusline.sh
   ```

2. **Configure for project**

   Edit `.claude/settings.json`:
   ```json
   {
     "statusLine": "./.claude/statusline.sh"
   }
   ```

## Components

### Always Displayed
- 📁 Current directory (last folder name only)
- 🌿 Git branch (if in repo)

### Conditional Display (Line 1)
- 🛡️/🐛/🏗️/🎨 Active superflow (when triggered by hooks)
- 🧠 Context remaining with progress bar
  - **Source**: Claude Code JSON stdin (automatic when running in Claude Code)
  - **Fallbacks**: `CLAUDE_CONTEXT_REMAINING` env var or `ccusage` command
  - Green: >50%
  - Yellow: 25-50%
  - Red: <25%

### Conditional Display (Line 2)
- 📝 +N/-M: Git changes (insertions/deletions, unstaged + staged)
- 🧠 Memory stats (if claude-mem MCP active)
- 📝 Last observation (if claude-mem MCP active)

## Superflow Indicators

| Emoji | Superflow |
|-------|-----------|
| 🛡️ | Refactoring Safety Protocol |
| 🐛 | Debugging Superflow |
| 🏗️ | Feature Development |
| 🎨 | UI Development |
| 🔌 | API Contract Design |
| ✅ | Verification Protocol |
| 🚀 | Rapid Prototyping |

## Testing

```bash
# Test in current directory (interactive mode)
./statusline.sh
# Expected output (in git repo with changes):
# 📁 project  🌿 main
# 📝 +42/-15

# Test with JSON stdin (simulates Claude Code)
echo '{"tokensUsed": 40000, "tokensTotal": 200000}' | ./statusline.sh
# 📁 project  🌿 main  🧠 80% [========--] ✓
# 📝 +42/-15

# Test with snake_case field names
echo '{"tokens_used": 120000, "tokens_total": 200000}' | ./statusline.sh
# 📁 project  🌿 main  🧠 40% [====------] ⚠
# 📝 +42/-15

# Test with env var fallback
CLAUDE_CONTEXT_REMAINING=95 ./statusline.sh
# 📁 project  🌿 main  🧠 95% [=========-] ✓
# 📝 +42/-15

# Test with active superflow
echo "ACTIVE_SUPERFLOW=🛡️ Refactoring" > .claude-session
echo '{"tokensUsed": 30000, "tokensTotal": 200000}' | ./statusline.sh
# 📁 project  🌿 main  🛡️ Refactoring  🧠 85% [========--] ✓
# 📝 +42/-15
```

## Customization

### Add Custom Component

Edit `statusline.sh`:

```bash
custom_component() {
    # Your logic here
    printf "🔧 Custom"
}

build_line1() {
    local components=()
    components+=("$(directory)")
    components+=("$(custom_component)")  # Add here
    printf "%b%s%b\n" "$CYAN" "${components[*]}" "$RESET"
}
```

### Change Colors

Edit color constants at top of script:

```bash
readonly CYAN='\033[36m'    # Change to your preference
readonly DIM='\033[2m'      # Dimmed text for line 2
```

## Requirements

- Bash 4.0+
- Git (for branch and changes display)
- Claude Code

### JSON Parsing (one of the following)
Context tracking requires parsing JSON from stdin. The script tries these in order:
1. **jq** (recommended - fastest and most reliable)
2. **python3** (common fallback)
3. **grep/sed** (basic fallback, less reliable)

Install jq for best results:
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# Windows (WSL)
sudo apt-get install jq
```

### Optional
- `CLAUDE_CONTEXT_REMAINING` env var (fallback if JSON parsing unavailable)
- `ccusage` command (alternative fallback)
- `claude-mem` MCP server for memory stats

## How Context Tracking Works

Claude Code passes session data as JSON via stdin to the statusline script. The script automatically parses this data to display context remaining.

### Supported JSON Field Names

The script tries multiple field name patterns for maximum compatibility:

**Token Usage (used/total)**:
- `tokensUsed` / `tokensTotal` (camelCase)
- `tokens_used` / `tokens_total` (snake_case)
- `context_used` / `context_total` (alternative)

**Direct Percentage**:
- `contextRemaining`
- `context_remaining`

The script calculates remaining percentage from used/total if available, or uses the percentage directly if provided.

### Priority Order

1. **JSON stdin** from Claude Code (automatic)
2. **`CLAUDE_CONTEXT_REMAINING`** env var (manual override)
3. **`ccusage`** command (legacy fallback)

## Performance

- Execution time: <50ms
- Memory: <1MB
- Dependencies: git (required), jq/python3/grep (one required for context tracking)

## Troubleshooting

### Statusline not showing
1. Check script is executable: `chmod +x ~/.claude/statusline.sh`
2. Check path in settings.json is correct
3. Restart Claude Code

### Colors not displaying
- Ensure terminal supports ANSI colors
- WSL users: Use Windows Terminal, not cmd.exe

### Git branch not showing
- Must be in git repository
- Git must be in PATH

### Context remaining not showing

**Quick fixes to try:**

1. **Install jq** for reliable JSON parsing:
   ```bash
   sudo apt-get install jq  # Ubuntu/Debian
   brew install jq          # macOS
   ```

2. **Test manually** to verify script works:
   ```bash
   echo '{"tokensUsed": 40000, "tokensTotal": 200000}' | ~/.claude/statusline.sh
   # Should show: 🧠 Context: 80% on line 2
   ```

3. **Check configuration** in `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.claude/statusline.sh"
     }
   }
   ```

4. **Use debug mode** to see what Claude Code sends:
   ```bash
   cp developer-skills-plugin/statusline/statusline-debug.sh ~/.claude/statusline.sh
   # Use Claude Code, then check:
   cat ~/.claude/statusline-debug.log
   ```

**See [DEBUG-CONTEXT-NOT-SHOWING.md](./DEBUG-CONTEXT-NOT-SHOWING.md) for detailed troubleshooting.**

**Fallback if stdin not available:**
- Set `CLAUDE_CONTEXT_REMAINING` env var with percentage (0-100)
- Or use `ccusage` command

### Git changes showing 0 when there are changes
- Check `git diff --numstat` output
- Ensure awk is available in PATH

### JSON parsing errors
- Install jq: `sudo apt-get install jq` (Ubuntu/Debian) or `brew install jq` (macOS)
- Or ensure python3 is installed: `which python3`
- Test JSON parsing:
  ```bash
  echo '{"test": "value"}' | jq -r '.test'
  # Should output: value
  ```
