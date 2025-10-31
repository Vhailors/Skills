#!/bin/bash
# Session continuity - Auto-loads recent context and suggests continuing work
# This provides awareness of the superflows system

# Build the context message
CONTEXT="

# 🔄 Session Continuity (Auto-Loaded)

## ⚠️ CRITICAL INSTRUCTIONS - Proactive Superflow Usage

**YOU MUST FOLLOW THESE RULES FOR EVERY SESSION:**

1. **WHEN A SUPERFLOW IS ACTIVATED (via hooks):**
   - You MUST immediately output the exact activation message shown in the hook
   - You MUST immediately use TodoWrite with all workflow steps
   - You MUST follow the complete workflow (don't skip steps)
   - You MUST use the suggested commands and skills proactively

2. **PROACTIVE TOOL USAGE:**
   - When hooks suggest /quick-fix, /recall-bug, /recall-feature → ACTUALLY RUN THEM
   - When hooks mention skills → ACTUALLY USE THEM (not just mention them)
   - When hooks suggest /find-ui → ACTUALLY SUGGEST IT with a pattern
   - Memory commands are not optional suggestions - use them

3. **BLOCKING ENFORCEMENT:**
   - Refactoring pattern → EXIT CODE 2 BLOCKING (must acknowledge)
   - Completion pattern → EXIT CODE 2 BLOCKING (must verify)
   - You CANNOT proceed without acknowledging these

4. **VISIBILITY REQUIREMENT:**
   - Every superflow activation MUST be visible to the user
   - Format: \"[Icon] [Superflow Name] activated\" + explanation
   - Then TodoWrite, then execute the workflow
   - This is NOT optional

## Active Superflows System

You have access to 8 intelligent superflows through the developer-skills plugin:

1. **Feature Development** 🏗️ - Spec-kit → Implementation → Verification
2. **Debugging** 🐛 - Memory search → Systematic investigation → Fix
3. **Refactoring** 🛡️ - Tests required → Safety protocol → Verification
4. **UI Development** 🎨 - Library search → shadcn/ui → Error handling
5. **Pre-Ship Validation** ✅ - Integration check → Ship check → Changelog
6. **Rapid Prototyping** 🚀 - Build vs buy → Fast implementation → Quality
7. **Session Start** 🔄 - Load context → Resume work (this one!)
8. **Skill Creation** 📝 - TDD enforcement → Test → Write → Verify

## 📋 Pattern-Based Activation

The system automatically detects patterns in user prompts and injects relevant workflow guidance:
- **\"refactor\"** → 🛡️ Refactoring Safety Protocol (ENFORCED)
- **\"bug/error\"** → 🐛 Debugging Superflow with memory search
- **\"implement feature\"** → 🏗️ Feature Development with spec-kit
- **\"ui/component\"** → 🎨 UI Development with library search
- **\"done/complete\"** → ✅ Verification enforcement
- **\"mvp/prototype\"** → 🚀 Rapid Prototyping guidance

## 🎯 Key Principles

- **Memory First**: Always search claude-mem for similar past work
- **Tests Required**: NO refactoring without tests (IRON LAW)
- **Verify Before Complete**: NO completion claims without evidence
- **Library Before Build**: Check /find-ui and shadcn/ui first
- **Visibility**: Always show which superflow is active
"

# For SessionStart hooks, we can output directly as markdown
# SessionStart doesn't need the JSON format like UserPromptSubmit
echo "$CONTEXT"

# === PROJECT SKILLS LOADING ===
# Load project-specific skills from .claude/project-skills/

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
PROJECT_ROOT="$(pwd)"  # Current working directory = actual project

PROJECT_SKILLS_DIR="$PROJECT_ROOT/.claude/project-skills"
METADATA_FILE="$PROJECT_ROOT/.claude/skill-metadata.json"

# Check if project-skills directory exists
if [[ -d "$PROJECT_SKILLS_DIR" ]]; then
  # Check if there are any skills
  SKILL_COUNT=$(find "$PROJECT_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)

  if [[ "$SKILL_COUNT" -gt 0 ]]; then
    echo ""
    echo "# 📚 Project Skills Available ($SKILL_COUNT)"
    echo ""
    echo "The following project-specific skills are available:"
    echo ""

    for SKILL_DIR in "$PROJECT_SKILLS_DIR"/*; do
      if [[ -d "$SKILL_DIR" ]]; then
        SKILL_NAME=$(basename "$SKILL_DIR")

        # Get skill description from SKILL.md if available
        SKILL_FILE="$SKILL_DIR/SKILL.md"
        if [[ -f "$SKILL_FILE" ]]; then
          DESCRIPTION=$(grep "^description:" "$SKILL_FILE" | head -1 | sed 's/description: *//')
          if [[ -n "$DESCRIPTION" ]]; then
            echo "- **$SKILL_NAME**: $DESCRIPTION"
            echo "  - Location: \`.claude/project-skills/$SKILL_NAME/SKILL.md\`"
          else
            echo "- **$SKILL_NAME**: Located at \`.claude/project-skills/$SKILL_NAME/SKILL.md\`"
          fi
        else
          echo "- **$SKILL_NAME**: Located at \`.claude/project-skills/$SKILL_NAME/\`"
        fi

        # Update last_used timestamp in metadata
        if [[ -f "$METADATA_FILE" ]] && command -v jq &> /dev/null; then
          TEMP_FILE=$(mktemp)
          NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
          jq --arg name "$SKILL_NAME" --arg now "$NOW" \
            '(.skills[] | select(.name == $name) | .last_used) = $now' \
            "$METADATA_FILE" > "$TEMP_FILE" 2>/dev/null && mv "$TEMP_FILE" "$METADATA_FILE" 2>/dev/null || rm -f "$TEMP_FILE" 2>/dev/null
        fi
      fi
    done

    echo ""
    echo "**When user asks about these technologies, read the corresponding SKILL.md file for project-specific context.**"
    echo ""
  fi
fi

exit 0
