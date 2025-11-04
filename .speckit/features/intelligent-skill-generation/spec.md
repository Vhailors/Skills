# Feature Spec: Intelligent Auto-Skill Generation System

**Created**: 2025-10-31
**Status**: Specification Phase
**Complexity**: High (Multi-component system integration)

---

## Context

### Why We're Building This

**Current Problem**:
Users repeatedly paste the same documentation (Supabase, Stripe, etc.) across multiple conversations because Claude has no project-specific memory. This wastes time (5+ minutes per paste), creates frustration, and provides generic responses without project context.

**Impact**:
- Time wasted: ~50 minutes per week on doc pasting
- Context loss: Every conversation starts from zero
- Generic guidance: No project-specific knowledge
- User frustration: Repetitive, manual process

**Solution**:
Auto-detect when users repeatedly ask about the same technology (3+ mentions), suggest creating an expert skill by scraping documentation/repos/PDFs using Skill Seekers, store project-scoped skills in `.claude/project-skills/`, and auto-load them in every session—creating a permanent, context-aware AI assistant.

### How It Works

**The System**:
1. **Pattern Detection**: Hook detects repeated tech mentions (Supabase, Stripe, etc.)
2. **Auto-Suggestion**: After 3rd mention, suggests skill creation
3. **Skill Generation**: Uses Skill Seekers to scrape docs and create SKILL.md
4. **Persistent Storage**: Stores in `.claude/project-skills/[tech-name]-expert/`
5. **Auto-Loading**: Session hook loads relevant skills automatically
6. **Workflow Integration**: Superflows (debugging, TDD, etc.) use skills for context

**Result**:
- Plugin skills provide PROCESS (how to debug, test, refactor)
- Project skills provide CONTEXT (what Supabase/Stripe APIs are)
- Combined: Context-aware, project-specific development assistance

---

## Requirements

### Functional Requirements

**FR1: Pattern Detection**
- System MUST detect when a technology is mentioned 3+ times across conversations
- System MUST track mentions in conversation history (last 50 conversations)
- System MUST NOT suggest if skill already exists
- System MUST NOT suggest if user previously dismissed that technology

**FR2: Skill Generation**
- System MUST support documentation URLs as source
- System MUST support GitHub repositories as source
- System MUST support PDF files as source
- System MUST use Skill Seekers for content extraction
- System MUST generate SKILL.md + references/ directory
- System MUST complete generation in <5 minutes

**FR3: Metadata Management**
- System MUST maintain `.claude/skill-metadata.json` registry
- Registry MUST track: name, source, type, created date, usage count
- Registry MUST track dismissals (user clicks "Never for X")
- Registry MUST update usage statistics on skill load

**FR4: Session Integration**
- System MUST load all project skills at session start
- System MUST inject available skills into Claude's context
- System MUST allow superflows to query available skills
- System MUST update last_used timestamp when skill loads

**FR5: Superflow Integration**
- Systematic-debugging MUST check for relevant project skills
- Test-driven-development MUST use project skill test patterns
- Refactoring-safety-protocol MUST reference project conventions
- All 22 superflows MUST have project skill integration section

**FR6: Skill Management**
- User MUST be able to list all project skills
- User MUST be able to refresh/regenerate skills
- User MUST be able to delete skills
- System MUST show skill statistics (usage, age, size)

### Non-Functional Requirements

**NFR1: Performance**
- Pattern detection hook MUST execute in <500ms
- Session skill loading MUST complete in <1 second for 10 skills
- Skill generation MUST not block other operations
- Metadata updates MUST be atomic (no corruption)

**NFR2: Reliability**
- System MUST work if skill files missing/corrupted (fall back gracefully)
- System MUST work if Skill Seekers unavailable (show error, continue)
- System MUST work if no project skills exist (superflows continue normally)
- Hook failures MUST NOT break superflow execution

**NFR3: Usability**
- Suggestions MUST be clear and actionable
- Skill creation MUST show progress (not silent)
- Errors MUST be user-friendly with recovery steps
- Documentation MUST explain how system works

**NFR4: Maintainability**
- Code MUST follow existing hook patterns
- Configuration MUST be JSON-based
- Skill templates MUST be extensible
- Testing MUST cover all components

---

## Acceptance Criteria

Feature is complete when ALL of the following are true:

### Pattern Detection
- [ ] Hook detects 3rd mention of "Supabase" and suggests skill
- [ ] Hook does NOT suggest if supabase-expert already exists
- [ ] Hook does NOT suggest if user dismissed Supabase before
- [ ] Hook tracks mentions in .claude/conversation-history.json
- [ ] Hook does NOT interfere with superflow invocation

### Skill Generation
- [ ] `/generate-skill --source URL --name NAME` creates skill successfully
- [ ] Generated skill has SKILL.md with enhanced content
- [ ] Generated skill has references/ directory with categorized docs
- [ ] Generated skill has .metadata.json with source info
- [ ] Registry .claude/skill-metadata.json updates correctly
- [ ] Generation completes in <5 minutes for typical docs

### Session Loading
- [ ] Session-start hook lists all available project skills
- [ ] Session-start hook injects skill names into context
- [ ] Claude can query skill-metadata.json from superflows
- [ ] Loading 10 skills completes in <1 second

### Superflow Integration
- [ ] systematic-debugging checks for and loads relevant skills
- [ ] test-driven-development uses project skill patterns
- [ ] All 22 superflows have "Project Skill Integration" section
- [ ] Superflows work WITHOUT skills (backwards compatible)
- [ ] Superflows provide enhanced guidance WITH skills

### Skill Management
- [ ] `/list-skills` shows all skills with usage stats
- [ ] `/refresh-skill [name]` regenerates from source
- [ ] `/delete-skill [name]` removes skill + updates registry
- [ ] `/skill-stats` shows analytics (most used, acceptance rate)

### User Experience
- [ ] Suggestion appears after 3rd mention with clear benefits
- [ ] User can click [Create] [Not Now] [Never]
- [ ] "Never" adds to dismissals, prevents future suggestions
- [ ] Skill creation shows progress (scraping, enhancing, saving)
- [ ] Errors show helpful messages with recovery options

### Edge Cases
- [ ] System handles corrupted metadata.json gracefully
- [ ] System handles missing skill files (shows warning, continues)
- [ ] System handles Skill Seekers failure (error message, continues)
- [ ] System handles multiple mentions in single prompt
- [ ] System handles user deleting skill during active session

---

## Technical Constraints

**TC1: Dependencies**
- MUST integrate with Skill Seekers (github.com/yusufkaraaslan/Skill_Seekers)
- MUST use existing hook system (hooks/hooks.json)
- MUST not conflict with analyze-prompt.sh hook
- MUST follow developer-skills-plugin directory structure

**TC2: File Structure**
- Project skills MUST live in `.claude/project-skills/`
- Metadata MUST be `.claude/skill-metadata.json`
- History MUST be `.claude/conversation-history.json`
- Plugin skills remain in `developer-skills-plugin/skills/`

**TC3: Compatibility**
- MUST work with existing 22 superflows
- MUST not break existing hook system
- MUST support both bash and PowerShell hooks
- MUST handle projects without `.claude/` directory

**TC4: Data Format**
- skill-metadata.json MUST be valid JSON
- conversation-history.json MUST be valid JSON
- SKILL.md MUST be valid Markdown
- All timestamps MUST be ISO 8601 format

**TC5: Security**
- MUST NOT store API keys in metadata
- MUST validate URLs before fetching
- MUST sanitize filenames (no path traversal)
- MUST handle malicious documentation gracefully

---

## Out of Scope

**Explicitly NOT included in this feature:**

❌ **Multi-project skill sharing**
- Skills are project-scoped only
- No cross-project skill registry
- Reason: Different projects have different tech stacks

❌ **Automatic skill updates**
- No automatic refresh when source docs change
- User must manually refresh skills
- Reason: Avoid breaking changes without user awareness

❌ **Skill versioning system**
- No version history or rollback
- Only current version stored
- Reason: Adds complexity, rare use case

❌ **Cloud storage/sync**
- Skills stored locally only
- No cloud backup or sync
- Reason: Privacy, simplicity

❌ **AI-based skill merging**
- No automatic combining of multiple sources into one skill
- User must manually specify multi-source skills
- Reason: Complex, error-prone

❌ **Real-time documentation tracking**
- No live monitoring of source doc changes
- No automatic notifications
- Reason: Performance overhead, rare benefit

❌ **Skill marketplace/discovery**
- No sharing skills with other users
- No skill templates library
- Reason: Different scope, future feature

---

## Technical Design Notes

### Architecture

**2-Layer System**:
```
LAYER 1: Plugin Skills (Workflows - Portable)
  developer-skills-plugin/skills/
    ├── systematic-debugging/
    ├── test-driven-development/
    └── ... (22 total)

LAYER 2: Project Skills (Knowledge - Project-Specific)
  .claude/project-skills/
    ├── supabase-expert/
    ├── stripe-expert/
    └── internal-api-expert/
```

**Hook Priority**:
```json
{
  "hooks": {
    "user_prompt_submit": [
      {"script": "analyze-prompt.sh", "priority": 1},
      {"script": "detect-skill-gaps.sh", "priority": 2}
    ]
  }
}
```

**Data Flow**:
```
User Prompt
  ↓
Hook: detect-skill-gaps.sh (tracks mentions)
  ↓
Pattern Detected (3rd mention)
  ↓
Suggestion UI: [Create] [Not Now] [Never]
  ↓
User clicks [Create]
  ↓
Run Skill Seekers (scrape + enhance)
  ↓
Save to .claude/project-skills/[name]/
  ↓
Update skill-metadata.json
  ↓
Next Session: Auto-load in session-start.sh
  ↓
Superflows query and use skill
```

### File Structure

```
.claude/
├── project-skills/
│   ├── supabase-expert/
│   │   ├── SKILL.md                 (main knowledge)
│   │   ├── references/
│   │   │   ├── auth.md
│   │   │   ├── database.md
│   │   │   └── storage.md
│   │   └── .metadata.json           (skill-specific metadata)
│   └── stripe-expert/
│       ├── SKILL.md
│       ├── references/
│       └── .metadata.json
│
├── skill-metadata.json               (master registry)
├── conversation-history.json         (for pattern detection)
└── commands/                         (slash commands)

developer-skills-plugin/
├── hooks/
│   ├── scripts/
│   │   ├── detect-skill-gaps.sh     (NEW)
│   │   └── session-start.sh         (ENHANCED)
│   └── hooks.json                    (UPDATED)
│
└── commands/
    └── generate-skill.sh             (NEW)
```

---

## Dependencies

**Required Tools**:
- Skill Seekers (Python script for doc scraping)
- jq (JSON parsing in bash hooks)
- curl (URL fetching)

**Required Permissions**:
- Read/write access to `.claude/` directory
- Execute permission for hooks
- Network access for doc scraping

**Blocking Issues**:
- If Skill Seekers not installed → Cannot generate skills (show error)
- If jq not available → Pattern detection fails (show error)
- If `.claude/` not writable → Cannot save skills (show error)

---

## Risks

**Risk 1: Skill Seekers Dependency**
- **Impact**: High (core functionality)
- **Likelihood**: Low (open source, stable)
- **Mitigation**: Include installation docs, error handling

**Risk 2: Hook Execution Overhead**
- **Impact**: Medium (slow responses)
- **Likelihood**: Medium (depends on skill count)
- **Mitigation**: Lazy loading, caching, performance testing

**Risk 3: Metadata Corruption**
- **Impact**: High (system breaks)
- **Likelihood**: Low (JSON validated)
- **Mitigation**: Atomic writes, validation, backups

**Risk 4: Superflow Conflicts**
- **Impact**: High (breaks existing features)
- **Likelihood**: Medium (integration complexity)
- **Mitigation**: Priority ordering, extensive testing

**Risk 5: User Confusion**
- **Impact**: Medium (poor adoption)
- **Likelihood**: Medium (new concept)
- **Mitigation**: Clear UI, documentation, examples

---

## Success Metrics

**Adoption**:
- Target: 75%+ of suggestions accepted
- Measure: acceptance_rate in statistics

**Usage**:
- Target: 60%+ of questions use project skills
- Measure: skill usage_count

**Time Savings**:
- Target: 80%+ reduction in doc pasting time
- Measure: User survey, usage analytics

**Quality**:
- Target: 95%+ accuracy with skills vs 70% without
- Measure: User feedback, answer quality

**Reliability**:
- Target: <1% hook failure rate
- Measure: Error logs, monitoring

---

## Open Questions

**Q1: Skill Seekers Integration**
- Where should Skill Seekers be installed?
- Options: (A) Bundled with plugin, (B) User installs separately
- Decision needed: User convenience vs bundle size

**Q2: Multi-Source Skills**
- Should we support combining docs + repo + PDF in one skill?
- Options: (A) Yes (complex), (B) No (simple, one source per skill)
- Decision needed: Feature richness vs complexity

**Q3: Skill Update Frequency**
- How often should we check if source docs changed?
- Options: (A) Never (manual), (B) Weekly, (C) On-demand
- Decision needed: Freshness vs performance

**Q4: Dismissal Permanence**
- Should "Never for X" be permanent or temporary?
- Options: (A) Permanent, (B) Reset after 30 days, (C) User can undo
- Decision needed: Respect user choice vs allow reconsideration

**Q5: GitHub Token Requirement**
- Should we require GitHub token for repo skills?
- Options: (A) Required (higher rate limit), (B) Optional (may hit limits)
- Decision needed: Setup friction vs reliability

---

## Next Steps

1. **Clarification Phase**: Review this spec, answer open questions
2. **Implementation Planning**: Create detailed phase-by-phase plan
3. **Task Breakdown**: Break each phase into concrete tasks
4. **Implementation**: Build Phase 1 (MVP) first
5. **Validation**: Test, verify integration, gather feedback

---

**Spec Version**: 1.0
**Last Updated**: 2025-10-31
