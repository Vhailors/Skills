#!/bin/bash
# Session continuity - Auto-loads recent context and suggests continuing work
# This provides awareness of the superflows system

# Build the context message
CONTEXT="

# 🔄 Session Continuity (Auto-Loaded)

## Active Superflows System

You have access to 8 intelligent superflows through the developer-skills plugin:

1. **Feature Development** - Spec-kit → Implementation → Verification
2. **Debugging** - Memory search → Systematic investigation → Fix
3. **Refactoring** - Tests required → Safety protocol → Verification
4. **UI Development** - Library search → shadcn/ui → Error handling
5. **Pre-Ship Validation** - Integration check → Ship check → Changelog
6. **Rapid Prototyping** - Build vs buy → Fast implementation → Quality
7. **Session Start** - Load context → Resume work (this one!)
8. **Skill Creation** - TDD enforcement → Test → Write → Verify

## 📋 Pattern-Based Activation

The system automatically detects patterns in user prompts and injects relevant workflow guidance:
- **\"refactor\"** → Refactoring Safety Protocol (ENFORCED)
- **\"bug/error\"** → Debugging Superflow with memory search
- **\"implement feature\"** → Feature Development with spec-kit
- **\"ui/component\"** → UI Development with library search
- **\"done/complete\"** → Verification enforcement
- **\"mvp/prototype\"** → Rapid Prototyping guidance

## 🎯 Key Principles

- **Memory First**: Always search claude-mem for similar past work
- **Tests Required**: NO refactoring without tests (IRON LAW)
- **Verify Before Complete**: NO completion claims without evidence
- **Library Before Build**: Check /find-ui and shadcn/ui first
"

# For SessionStart hooks, we can output directly as markdown
# SessionStart doesn't need the JSON format like UserPromptSubmit
echo "$CONTEXT"

exit 0
