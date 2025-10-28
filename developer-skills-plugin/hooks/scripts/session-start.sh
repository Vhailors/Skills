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

exit 0
