#!/usr/bin/env bash
# Global installation script for developer-skills statusline and output style
# This configures Claude Code to use these features in all projects

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

echo "🚀 Installing Developer-Skills features globally..."
echo

# 1. Create .claude directory if it doesn't exist
echo "📁 Setting up Claude directory..."
mkdir -p "$CLAUDE_DIR"

# 2. Install statusline
echo "📊 Installing statusline..."
cp "${SCRIPT_DIR}/statusline/statusline.sh" "${CLAUDE_DIR}/statusline.sh"
chmod +x "${CLAUDE_DIR}/statusline.sh"
echo "   ✅ Statusline installed to ~/.claude/statusline.sh"

# 3. Create or update settings.json
echo "⚙️  Configuring settings.json..."

if [ -f "$SETTINGS_FILE" ]; then
    echo "   Found existing settings.json"

    # Backup existing settings
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup"
    echo "   ✅ Backed up to settings.json.backup"

    # Check if jq is available for JSON manipulation
    if command -v jq &>/dev/null; then
        # Use jq to update settings
        jq '. + {"statusLine": "~/.claude/statusline.sh"}' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp"
        mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
        echo "   ✅ Updated statusLine setting"
    else
        echo "   ⚠️  jq not found - manual update needed"
        echo "   Add this to ${SETTINGS_FILE}:"
        echo '   "statusLine": "~/.claude/statusline.sh"'
    fi
else
    # Create new settings.json
    cat > "$SETTINGS_FILE" <<EOF
{
  "statusLine": "~/.claude/statusline.sh"
}
EOF
    echo "   ✅ Created settings.json with statusLine"
fi

# 4. Install hooks for output style enforcement
echo "🎨 Installing output style hooks..."

HOOKS_DIR="${CLAUDE_DIR}/hooks"
mkdir -p "${HOOKS_DIR}/scripts"

# Copy hooks
cp "${SCRIPT_DIR}/hooks/hooks.json" "${HOOKS_DIR}/hooks.json"
cp -r "${SCRIPT_DIR}/hooks/scripts/"* "${HOOKS_DIR}/scripts/"
chmod +x "${HOOKS_DIR}/scripts/"*.sh

echo "   ✅ Hooks installed to ~/.claude/hooks/"

# 5. Copy output style documentation
echo "📖 Installing output style documentation..."
mkdir -p "${CLAUDE_DIR}/output-styles"
cp "${SCRIPT_DIR}/output-styles/"* "${CLAUDE_DIR}/output-styles/"
echo "   ✅ Output style guide installed"

# 6. Summary
echo
echo "✅ Installation complete!"
echo
echo "📋 What was installed:"
echo "   • Statusline: ~/.claude/statusline.sh"
echo "   • Hooks: ~/.claude/hooks/"
echo "   • Output style: ~/.claude/output-styles/"
echo
echo "🎯 Features enabled globally:"
echo "   • Technical statusline with context & git changes"
echo "   • Structured output style (enforced by hooks)"
echo "   • All 7 superflows with automatic detection"
echo
echo "📝 Next steps:"
echo "   1. Restart Claude Code"
echo "   2. Test statusline: ~/.claude/statusline.sh"
echo "   3. Test superflows: Try 'refactor this code' or 'fix this bug'"
echo
echo "🔧 Environment variable (optional):"
echo "   export CLAUDE_CONTEXT_REMAINING=95  # For context tracking"
echo "   Add to ~/.bashrc or ~/.zshrc for persistence"
echo
echo "📚 Documentation:"
echo "   • Statusline: ${SCRIPT_DIR}/statusline/README.md"
echo "   • Output style: ${SCRIPT_DIR}/output-styles/README.md"
echo "   • Summary: ${SCRIPT_DIR}/STATUSLINE-OUTPUTSTYLE-SUMMARY.md"
echo
