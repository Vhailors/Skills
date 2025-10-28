# Developer-Skills Statusline

**Technical, concise status display for Claude Code**

## What It Shows

### Line 1: Session State
```
📁 ~/project  🌿 branch  🛡️ Active-Superflow  ✅ 3/6 todos
```

### Line 2: Memory Context (Optional)
```
🧠 Memory: 271 obs  📝 Last: Hook blocking fix (#267)
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

### Conditional Display
- 🛡️/🐛/🏗️/🎨 Active superflow (when triggered)
- ✅ Todo progress (if available)
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

# Expected output (in git repo):
# 📁 ~/project  🌿 main
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
- Git (for branch display)
- Claude Code

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
