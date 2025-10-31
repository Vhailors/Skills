# Global Setup: Statusline & Output Style

**Configure Claude Code globally to use developer-skills features in all projects**

## Quick Install

```bash
cd /path/to/developer-skills-plugin
./install-global.sh
```

This installs:
- ✅ Statusline to `~/.claude/statusline.sh`
- ✅ Hooks to `~/.claude/hooks/`
- ✅ Output style to `~/.claude/output-styles/`

## What Gets Configured

### 1. Global Statusline

**Location**: `~/.claude/statusline.sh`

**Display**:
```
📁 ~/project  🌿 branch  🛡️ Superflow  🧠 95% [=========-]
±42 lines
```

**Auto-enabled in**: All Claude Code sessions

### 2. Global Hooks

**Location**: `~/.claude/hooks/`

**Detects**:
- Refactoring requests → 🛡️ Refactoring Safety Protocol
- Bug reports → 🐛 Debugging Superflow
- Feature requests → 🏗️ Feature Development
- UI work → 🎨 UI Development
- API changes → 🔌 API Contract Design
- Completion claims → ✅ Verification Protocol
- Rapid prototyping → 🚀 Rapid Prototyping

**Auto-enabled in**: All Claude Code sessions

### 3. Global Output Style

**Location**: `~/.claude/output-styles/`

**Format**: Technical, structured responses

**Auto-enabled by**: Hooks (context injection)

## Manual Installation

If you prefer manual setup:

### Step 1: Statusline

```bash
# Copy statusline
cp statusline/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Update settings.json
# Add: "statusLine": "~/.claude/statusline.sh"
```

### Step 2: Hooks

```bash
# Copy hooks
mkdir -p ~/.claude/hooks/scripts
cp hooks/hooks.json ~/.claude/hooks/
cp hooks/scripts/* ~/.claude/hooks/scripts/
chmod +x ~/.claude/hooks/scripts/*.sh
```

### Step 3: Output Style Docs

```bash
# Copy output style documentation
mkdir -p ~/.claude/output-styles
cp output-styles/* ~/.claude/output-styles/
```

## Configuration File

After installation, `~/.claude/settings.json` will contain:

```json
{
  "statusLine": "~/.claude/statusline.sh"
}
```

## Environment Variables

### Context Tracking (Optional)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# For statusline context display
export CLAUDE_CONTEXT_REMAINING=95  # Set by Claude Code automatically
```

Or install `ccusage` for automatic context detection:

```bash
npm install -g ccusage
```

## Per-Project Override

To override globally-configured features in a specific project:

### Override Statusline

Create `.claude/settings.json` in project:

```json
{
  "statusLine": "./.claude/custom-statusline.sh"
}
```

### Override Hooks

Create `.claude/hooks/hooks.json` in project:

```json
{
  "UserPromptSubmit": {
    "callback": "./.claude/hooks/custom-script.sh"
  }
}
```

### Disable Features

Create `.claude/settings.json`:

```json
{
  "statusLine": null
}
```

Create empty `.claude/hooks/hooks.json`:

```json
{}
```

## Verification

### Test Statusline

```bash
# Should show directory, git branch, etc.
~/.claude/statusline.sh
```

### Test Hooks

In Claude Code, try:
- "Refactor this code" → Should see 🛡️ Refactoring Safety Protocol
- "Fix this bug" → Should see 🐛 Debugging Superflow
- "I'm done" → Should see ✅ Verification Protocol

### Test Output Style

Response should be structured:
```markdown
## 🛡️ Refactoring Safety Protocol

**Status**: Active
**Target**: code.ts

### 🎯 Next Steps
- Check tests
- Create missing tests
- Execute refactoring
```

## Troubleshooting

### Statusline not appearing

1. Check settings.json:
   ```bash
   cat ~/.claude/settings.json
   ```

2. Verify script is executable:
   ```bash
   ls -la ~/.claude/statusline.sh
   ```

3. Test manually:
   ```bash
   ~/.claude/statusline.sh
   ```

4. Restart Claude Code

### Hooks not triggering

1. Check hooks directory:
   ```bash
   ls ~/.claude/hooks/
   ```

2. Verify scripts are executable:
   ```bash
   ls -la ~/.claude/hooks/scripts/
   ```

3. Test hook manually:
   ```bash
   echo '{"prompt": "refactor this"}' | ~/.claude/hooks/scripts/analyze-prompt.sh
   ```

4. Restart Claude Code

### Output style not working

1. Hooks must be working first (see above)
2. Try explicit trigger: "refactor", "bug", "implement"
3. Check hook output for context injection

## Uninstallation

```bash
# Remove statusline
rm ~/.claude/statusline.sh

# Remove hooks
rm -rf ~/.claude/hooks/

# Remove output style docs
rm -rf ~/.claude/output-styles/

# Update settings.json (remove statusLine entry)
# Manually edit ~/.claude/settings.json
```

## Migration from Project-Specific

If you previously installed per-project:

1. Run global install:
   ```bash
   ./install-global.sh
   ```

2. Remove project-specific installations:
   ```bash
   rm -rf .claude/statusline.sh
   rm -rf .claude/hooks/
   rm -rf .claude/output-styles/
   ```

3. Keep project settings if customized, otherwise remove

## Files Installed

```
~/.claude/
├── settings.json              # Updated with statusLine
├── statusline.sh              # Statusline script
├── hooks/
│   ├── hooks.json            # Hook configuration
│   └── scripts/
│       ├── analyze-prompt.sh # Main hook script
│       └── session-start.sh  # Session initialization
└── output-styles/
    ├── README.md
    └── developer-skills-technical.md
```

## Benefits of Global Setup

**Consistency**: Same features in all projects
**Maintenance**: Update once, applies everywhere
**Zero-config**: New projects work immediately
**Override**: Can still customize per-project
**Portable**: Easy to share via dotfiles

## Next Steps

After installation:

1. ✅ Restart Claude Code
2. ✅ Test statusline appears
3. ✅ Try a refactoring request
4. ✅ Verify structured output
5. ✅ Check git changes counter
6. ✅ Test context remaining (if env var set)

Enjoy technical, structured Claude Code sessions! 🚀
