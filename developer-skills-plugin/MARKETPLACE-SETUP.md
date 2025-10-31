# Developer Skills Plugin - Marketplace Installation Guide

**Status**: ✅ Ready for Claude Code Marketplace
**Version**: 1.1 (Bundled Skill Seekers)

---

## 🚀 For Users: Zero Setup Required!

**When you install this plugin via Claude Code marketplace**, everything works immediately:

### What's Included ✅
- ✅ **30 built-in technology patterns** (Supabase, Stripe, Next.js, etc.)
- ✅ **Skill Seekers bundled** (no separate installation needed!)
- ✅ **All 22 superflows** (debugging, TDD, refactoring, etc.)
- ✅ **Pattern detection hooks** (auto-suggests skills after 3 mentions)
- ✅ **Custom pattern support** (add your own technologies)

### Installation Steps
```bash
# In Claude Code:
1. Open Plugin Marketplace
2. Search "Developer Skills"
3. Click "Install"
4. Done! ✅

# Plugin works immediately in ANY project
# No configuration needed
# No additional tools to install
```

### ⚠️ Only Requirement: Python Dependencies

The plugin needs these Python packages (one-time, global):
```bash
pip3 install requests beautifulsoup4
```

**That's it!** Plugin works in all projects after this one-time setup.

---

## 📁 How It Works (Marketplace Installation)

### Plugin Location
```
~/.claude/plugins/developer-skills-plugin/  (or similar)
├── skills/                    # 22 superflows
├── hooks/                     # Pattern detection
├── commands/                  # Skill generation
└── vendor/                    # Bundled dependencies
    └── Skill_Seekers/         # ← Included! No separate install
```

### Project Data (Per-Project)
```
/your-project/
└── .claude/
    ├── project-skills/        # Auto-created when first skill generated
    ├── skill-metadata.json    # Auto-created by hooks
    └── conversation-history.json  # Auto-created by hooks
```

**Key Point**: Plugin is installed once, works in all projects. Each project gets its own skills.

---

## 🎯 Usage in Different Projects

### Project A
```bash
cd ~/projects/project-a

# Mention "Supabase" 3 times
# → Auto-suggests creating supabase-expert skill
# → Skill created in ~/projects/project-a/.claude/project-skills/
```

### Project B (Different Tech Stack)
```bash
cd ~/projects/project-b

# Mention "Django" 3 times
# → Auto-suggests creating django-expert skill
# → Skill created in ~/projects/project-b/.claude/project-skills/
```

**Result**: Each project has its own tech-specific skills. Plugin is shared, skills are not.

---

## 🔧 Path Resolution (Technical Details)

### How Plugin Finds Its Resources
```bash
# Plugin uses CLAUDE_PLUGIN_ROOT (set by Claude Code)
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"

# Bundled Skill Seekers location (fixed, relative to plugin)
SKILL_SEEKERS_DIR="$PLUGIN_ROOT/vendor/Skill_Seekers"

# Project data location (current working directory)
PROJECT_ROOT="$(pwd)"
PROJECT_SKILLS_DIR="$PROJECT_ROOT/.claude/project-skills"
```

**Result**:
- Plugin resources: Always found (bundled)
- Project data: Created in current project directory
- Works from any directory

---

## 📦 What's Bundled

### Skill Seekers (MIT Licensed)
```
vendor/Skill_Seekers/
├── cli/                      # Scraping tools
│   ├── doc_scraper.py       # Main scraper
│   ├── enhance_skill_local.py  # AI enhancement
│   └── package_skill.py     # Packaging
├── configs/                  # 15+ presets
│   ├── react.json
│   ├── django.json
│   └── ...
└── requirements.txt          # Python dependencies
```

**Size**: ~2MB (compressed)
**License**: MIT (bundling allowed)

---

## 🎓 First-Time User Experience

### Day 1: Install Plugin
```
1. Install via marketplace → 30 seconds
2. Run: pip3 install requests beautifulsoup4 → 1 minute
3. Plugin ready in ALL projects → Forever! ✅
```

### Day 2: Use in Project A
```
User: "How do I set up Supabase auth?"
System: [Tracks mention #1]

User: "Supabase database queries?"
System: [Tracks mention #2]

User: "Supabase realtime?"
System: [Tracks mention #3, triggers suggestion]

💡 Auto-Skill Suggestion
I've noticed you've mentioned **supabase** 3 times.
Would you like me to create a **supabase-expert** skill?

User: "Yes"
System: [Generates skill using bundled Skill Seekers]
        [Saves to project-a/.claude/project-skills/]
✅ Done!
```

### Day 3: Use in Project B
```
Same plugin, different project, different tech stack.
Pattern detection works immediately.
No setup needed.
```

---

## 🆚 Comparison: Before vs After Bundling

### Before (Manual Installation)
```
❌ User installs plugin
❌ User clones Skill_Seekers to each project
❌ User installs Python dependencies per project
❌ Path resolution issues
❌ 10+ minutes setup per project
```

### After (Bundled)
```
✅ User installs plugin once
✅ Skill Seekers included
✅ Python dependencies once (global)
✅ Path resolution automatic
✅ 2 minutes setup total (all projects)
```

---

## 🔄 Updates

### Plugin Updates (Via Marketplace)
```
User: Update plugin in Claude Code
  ↓
Marketplace: Downloads new version
  ↓
Includes: Latest Skill Seekers
  ↓
All projects: Use updated version automatically
```

**No per-project updates needed!**

---

## ⚙️ Custom Patterns (Optional)

**If you want to add your own technology patterns**:

1. Create file in your project:
```bash
# In your project root
mkdir -p .claude
cat > .claude/custom-skill-patterns.json <<'EOF'
{
  "custom_patterns": [
    {
      "pattern": "htmx",
      "skill_name": "htmx-expert",
      "description": "HTMX hypermedia library expert",
      "docs_url": "https://htmx.org/docs",
      "enabled": true
    }
  ]
}
EOF
```

2. Pattern detection now includes your custom patterns!

**Per-project customization** - add patterns specific to your tech stack.

---

## 🐛 Troubleshooting

### "Skill Seekers not found"
```bash
# This should NEVER happen with bundled version
# If you see this, check:
ls ~/.claude/plugins/developer-skills-plugin/vendor/Skill_Seekers/

# Should show cli/, configs/, etc.
```

### "Python module not found"
```bash
# Install dependencies:
pip3 install requests beautifulsoup4

# Or check installation:
pip3 list | grep -E "(requests|beautifulsoup4)"
```

### ".claude directory not created"
```bash
# Auto-created on first use
# If needed, create manually:
mkdir -p .claude/project-skills

# Hooks will populate it automatically
```

---

## 📊 Storage & Performance

### Plugin Size
```
Unpacked: ~2MB
  - Skill Seekers: ~1.5MB
  - Skills: ~300KB
  - Hooks: ~50KB
  - Docs: ~150KB
```

### Per-Project Storage
```
First skill: ~2-5MB
  - SKILL.md: 5-20KB
  - references/: 2-5MB (depends on doc size)
  - metadata: <10KB

Each additional skill: +2-5MB
```

### Performance
```
Pattern detection: <200ms
Skill generation: 20-40 minutes (first time, doc-dependent)
Session loading: <500ms (10 skills)
```

---

## ✅ Ready for Marketplace

**This plugin is production-ready**:
- ✅ Self-contained (Skill Seekers bundled)
- ✅ Zero project setup
- ✅ Path resolution automatic
- ✅ Works in any project
- ✅ MIT licensed (bundling compliant)
- ✅ Comprehensive documentation
- ✅ Error handling with helpful messages
- ✅ Backwards compatible

**Dependencies**: Only `requests` and `beautifulsoup4` (user installs once)

---

## 📝 For Plugin Developers

### Building for Distribution
```bash
# Plugin is ready as-is
cd developer-skills-plugin/

# Contents:
ls -la
# skills/          ← 22 superflows
# hooks/           ← Pattern detection
# commands/        ← Skill generation
# vendor/          ← Bundled Skill Seekers
# MARKETPLACE-SETUP.md  ← This file
```

### Testing Multi-Project
```bash
# Test in different directories
cd /tmp/project-test-1
# Use plugin commands

cd /tmp/project-test-2
# Same plugin, different project data ✅
```

---

## 🎉 Summary

**For Users**: Install once → Works everywhere → Zero configuration per project

**For Developers**: Skill Seekers bundled → Path resolution automatic → Marketplace ready

**Status**: ✅ **PRODUCTION READY FOR CLAUDE CODE MARKETPLACE**
