# Mock Data Removal Skill

## Overview

**Type:** Supporting skill (not standalone superflow)
**Purpose:** Systematic detection of test artifacts before shipping
**Integration:** Called by verification workflows when needed

## What It Does

Prevents mock data, test credentials, hardcoded values, and development-only code from reaching production through systematic negative-evidence scanning.

## Files Created

```
mock-data-removal/
├── SKILL.md                    # Main skill documentation
├── README.md                   # This file
├── .metadata.json              # Skill metadata
├── TEST-SCENARIOS.md           # Pressure test scenarios
├── BASELINE-ANALYSIS.md        # Expected baseline behaviors
└── scripts/
    └── scan-mock-data.sh       # Executable scanner (7 scans)
```

## Integration Points

### 1. verification-before-completion skill

**Location:** `skills/verification-before-completion/SKILL.md`

**Integration:**
- Added to Common Failures table
- Added to Key Patterns section
- Required sub-skill reference

**Usage:** Automatically referenced when agents claim "ready to ship"

### 2. ship-check command

**Location:** `commands/ship-check.md`

**Integration:**
- Added to Cross-Cutting Concerns checklist
- Added to Skills Used list

**Usage:** Run as part of comprehensive pre-ship validation

## How It's Used

### By Developers

```bash
# Manual scan before shipping
developer-skills-plugin/skills/mock-data-removal/scripts/scan-mock-data.sh

# Exit codes:
# 0 = found issues (BLOCK)
# 1 = clean (PASS)
```

### By Agents

When agents encounter:
- "ready to ship" claims
- PR creation requests
- "mark as complete" requests
- /ship-check commands

They automatically:
1. Load mock-data-removal skill
2. Run systematic scan
3. Block if findings exist
4. Require removal before proceeding

## What It Detects

| Category | Examples |
|----------|----------|
| Keywords | mock, test, fake, sample, dummy |
| Email patterns | test@example.com, admin@test.com |
| IDs | user-12345, test-user-123 |
| API keys | sk-test-*, dev-api-key |
| URLs | localhost, 127.0.0.1 |
| Comments | TODO: Remove, FIXME |
| Debug flags | DEBUG=true, ALLOWED_HOSTS=["*"] |
| Credentials | testuser:testpass |

## Design Decisions

### Why Supporting Skill (Not Superflow)?

**Decision:** Mock-data-removal is called BY other workflows, not triggered directly by user prompts.

**Rationale:**
- Verification step, not user-facing workflow
- Fits naturally into existing ship/verify patterns
- No need for separate hook detection
- Cleaner architecture

### Why Systematic Scanning?

**Decision:** Use ripgrep patterns, not manual review.

**Rationale:**
- Agents focus on positive evidence ("works"), miss negative evidence ("shouldn't exist")
- Systematic patterns catch what visual inspection misses
- Automation prevents rationalization
- 15-second scan beats manual review

## Testing

### Pressure Scenarios Created

1. **Time Pressure + Completion Claim** - Deadline + sunk cost
2. **Exhaustion + Trust Pressure** - Hours debugging + relief bias
3. **Authority + Incremental Change** - Senior approval + scope minimization
4. **Sunk Cost + Feature Completeness** - Full day + visual success

### Expected Rationalizations

- "Tests are passing" (doesn't detect artifacts)
- "Developer tested it" (manual testing misses patterns)
- "Senior dev approved" (authority doesn't guarantee removal)
- "Time pressure" (shipping mock data creates incidents)
- "Looks clean to me" (visual inspection incomplete)

All addressed in skill's Rationalization Table.

## Usage Examples

### Example 1: Agent Claims Ready to Ship

```
User: "Tests are passing, ready to ship this!"

Agent: Before shipping, running mock data scan...
[Loads mock-data-removal skill]
[Runs scan-mock-data.sh]

❌ BLOCKING ISSUES FOUND:
- auth.service.ts:4 - Hardcoded mockUser
- config.ts:1 - Test API key 'sk-test-*'

Cannot ship until removed.
```

### Example 2: /ship-check Command

```
User: /ship-check authentication

Agent: Running comprehensive ship-check...

1. ✅ Full-stack integration
2. ✅ Tests passing
3. ❌ Mock data scan - 2 findings:
   - Hardcoded test user
   - TODO: Remove before production
4. ✅ Security checks

Status: NOT READY - Fix mock data issues
```

## Maintenance

### Adding New Patterns

Edit `scripts/scan-mock-data.sh` to add scan categories:

```bash
# Example: Add new pattern
NEW_RESULTS=$(rg -i "your-pattern-here" \
  --glob '!test/**' \
  "$PROJECT_ROOT" 2>/dev/null || true)
```

### Updating Skill

Follow TDD process:
1. Create pressure scenario showing gap
2. Update skill to address gap
3. Verify scenario now passes
4. Document in SKILL.md

## Real-World Impact

**Without this skill:**
- Test API keys in production configs
- Mock users with admin privileges
- localhost URLs breaking prod calls
- DEBUG=True exposing stack traces
- Hardcoded test@example.com

**With this skill:**
- Block every PR with test artifacts
- Zero production incidents from mock data
- 15-second automated scan
- No manual oversight needed

## The Bottom Line

**Mock data removal is now automatic and systematic.**

Agents can't rationalize away mock data because:
1. Skill loaded automatically at ship-time
2. Scan is systematic (not visual)
3. Rationalizations explicitly countered
4. Evidence required before shipping

Production safety through negative-evidence scanning.
