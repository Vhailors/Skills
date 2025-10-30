#!/bin/bash
# Installation script for TodoWrite Observer Hook
# Installs globally to ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_SCRIPT="$SCRIPT_DIR/scripts/todo-workflow-observer.py"
STATUSLINE_SCRIPT="$SCRIPT_DIR/../statusline/statusline.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TodoWrite Observer Hook Installation     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check if hook script exists
if [[ ! -f "$HOOK_SCRIPT" ]]; then
    echo -e "${RED}❌ Error: Hook script not found at $HOOK_SCRIPT${NC}"
    exit 1
fi

# Create hooks directory if not exists
echo -e "${BLUE}📁 Creating ~/.claude/hooks directory...${NC}"
mkdir -p ~/.claude/hooks
chmod 755 ~/.claude/hooks

# Copy hook script
echo -e "${BLUE}📋 Installing observer hook...${NC}"
cp "$HOOK_SCRIPT" ~/.claude/hooks/todo-workflow-observer.py
chmod +x ~/.claude/hooks/todo-workflow-observer.py
echo -e "${GREEN}✅ Installed: ~/.claude/hooks/todo-workflow-observer.py${NC}"

# Update statusline if exists
if [[ -f "$STATUSLINE_SCRIPT" ]]; then
    echo -e "${BLUE}📊 Updating statusline with progress display...${NC}"
    cp "$STATUSLINE_SCRIPT" ~/.claude/statusline.sh
    chmod +x ~/.claude/statusline.sh
    echo -e "${GREEN}✅ Updated: ~/.claude/statusline.sh${NC}"
fi

# Update settings.json
SETTINGS_FILE="$HOME/.claude/settings.json"

if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo -e "${YELLOW}⚠️  Warning: $SETTINGS_FILE not found${NC}"
    echo -e "${YELLOW}   Creating minimal settings.json...${NC}"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/todo-workflow-observer.py"
          }
        ]
      }
    ]
  }
}
EOF
    echo -e "${GREEN}✅ Created: $SETTINGS_FILE${NC}"
else
    echo -e "${BLUE}⚙️  Checking settings.json...${NC}"

    # Check if PostToolUse hook already exists
    if grep -q '"PostToolUse"' "$SETTINGS_FILE"; then
        echo -e "${YELLOW}⚠️  PostToolUse hook section already exists${NC}"

        # Check if TodoWrite matcher exists
        if grep -q '"matcher".*"TodoWrite"' "$SETTINGS_FILE"; then
            echo -e "${YELLOW}⚠️  TodoWrite hook already configured${NC}"
            echo -e "${BLUE}   Updating hook command...${NC}"

            # Use Python to update JSON (safer than sed)
            python3 << PYEOF
import json
import sys
import os

settings_file = os.path.expanduser("$SETTINGS_FILE")

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)

    # Find TodoWrite hook and update command
    if 'hooks' in settings and 'PostToolUse' in settings['hooks']:
        for hook in settings['hooks']['PostToolUse']:
            if hook.get('matcher') == 'TodoWrite':
                if 'hooks' in hook and len(hook['hooks']) > 0:
                    hook['hooks'][0]['command'] = '~/.claude/hooks/todo-workflow-observer.py'
                    print("Updated TodoWrite hook command")

    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)

    print("✅ Settings updated successfully")
except Exception as e:
    print(f"❌ Error updating settings: {e}")
    sys.exit(1)
PYEOF

        else
            echo -e "${BLUE}   Adding TodoWrite hook to PostToolUse...${NC}"

            # Add TodoWrite hook to existing PostToolUse array
            python3 << PYEOF
import json
import sys
import os

settings_file = os.path.expanduser("$SETTINGS_FILE")

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)

    if 'hooks' not in settings:
        settings['hooks'] = {}

    if 'PostToolUse' not in settings['hooks']:
        settings['hooks']['PostToolUse'] = []

    # Add TodoWrite hook
    settings['hooks']['PostToolUse'].append({
        "matcher": "TodoWrite",
        "hooks": [{
            "type": "command",
            "command": "~/.claude/hooks/todo-workflow-observer.py"
        }]
    })

    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)

    print("✅ TodoWrite hook added successfully")
except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(1)
PYEOF
        fi
    else
        echo -e "${BLUE}   Adding PostToolUse hook section...${NC}"

        # Add entire PostToolUse section
        python3 << PYEOF
import json
import sys
import os

settings_file = os.path.expanduser("$SETTINGS_FILE")

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)

    if 'hooks' not in settings:
        settings['hooks'] = {}

    settings['hooks']['PostToolUse'] = [{
        "matcher": "TodoWrite",
        "hooks": [{
            "type": "command",
            "command": "~/.claude/hooks/todo-workflow-observer.py"
        }]
    }]

    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)

    print("✅ PostToolUse hook added successfully")
except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(1)
PYEOF
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Installation Complete! ✅           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 What was installed:${NC}"
echo -e "   • TodoWrite observer hook"
echo -e "   • Workflow enforcement"
echo -e "   • Sequential execution validation"
echo -e "   • Progress tracking in statusline"
echo ""
echo -e "${BLUE}🎯 Features enabled:${NC}"
echo -e "   • Auto-detects active superflow from todos"
echo -e "   • Validates workflow compliance"
echo -e "   • Warns about missing required steps"
echo -e "   • Enforces one in_progress todo at a time"
echo -e "   • Reminds to continue with pending todos"
echo -e "   • Updates statusline with progress (e.g., 🛡️ Refactoring 3/6)"
echo ""
echo -e "${YELLOW}🔄 Next steps:${NC}"
echo -e "   • Restart Claude Code to activate the hook"
echo -e "   • Create a todo list with TodoWrite"
echo -e "   • Watch the observer enforce your workflow!"
echo ""
echo -e "${BLUE}📖 Test the observer:${NC}"
echo -e "   Try saying: 'Help me refactor this code'"
echo -e "   The observer will ensure you check tests first!"
echo ""
