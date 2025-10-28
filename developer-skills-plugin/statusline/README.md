# Developer-Skills Statusline

**Technical, concise status display for Claude Code**

## What It Shows

### Line 1: Session State
```
📁 ~/project  🌿 branch  🛡️ Active-Superflow  🧠 95% [=========-]
```

### Line 2: Changes & Memory
```
±102 lines  🧠 Memory: 271 obs  📝 Last: Hook blocking fix (#267)
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
- 📁 Current directory (abbreviated with ~)
- 🌿 Git branch (if in repo)

### Conditional Display (Line 1)
- 🛡️/🐛/🏗️/🎨 Active superflow (when triggered)
- 🧠 Context remaining with progress bar (if env var set)
  - Green: >50%
  - Yellow: 25-50%
  - Red: <25%

### Conditional Display (Line 2)
- ±N lines: Git changes count (unstaged + staged)
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
# Test in current directory
./statusline.sh

# Expected output (in git repo with changes):
# 📁 ~/project  🌿 main
# ±42 lines

# Test with context remaining
CLAUDE_CONTEXT_REMAINING=95 ./statusline.sh
# 📁 ~/project  🌿 main  🧠 95% [=========-]
# ±42 lines

# Test with active superflow
echo "ACTIVE_SUPERFLOW=🛡️ Refactoring" > .claude-session
CLAUDE_CONTEXT_REMAINING=95 ./statusline.sh
# 📁 ~/project  🌿 main  🛡️ Refactoring  🧠 95% [=========-]
# ±42 lines
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

### Optional
- `CLAUDE_CONTEXT_REMAINING` env var for context tracking
- `ccusage` for automatic context detection
- `claude-mem` MCP server for memory stats

## Performance

- Execution time: <50ms
- Memory: <1MB
- Zero external dependencies (except git)

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
- Set `CLAUDE_CONTEXT_REMAINING` env var with percentage (0-100)
- Or install `ccusage` for automatic detection

### Git changes showing 0 when there are changes
- Check `git diff --numstat` output
- Ensure awk is available in PATH
