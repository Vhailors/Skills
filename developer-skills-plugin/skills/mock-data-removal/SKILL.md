---
name: mock-data-removal
description: Use when claiming code is ready to ship, creating PRs, or marking features complete - scans for and blocks mock data, test credentials, hardcoded values, and development-only code from reaching production through systematic negative-evidence verification
---

# Mock Data Removal

## Overview

**Mock data detection requires negative-evidence scanning, not positive-evidence validation.**

Test artifacts (mock users, test API keys, hardcoded IDs, debug flags) naturally persist from development into production code because agents focus on what's working, not what shouldn't be there.

## When to Use

**Trigger before ANY of these actions:**
- Creating pull requests
- Claiming "ready to ship"
- Marking features complete
- Running /ship-check or verification
- Merging to main/production branches
- Deploying code

**Symptoms you need this:**
- Developer claims "tests are passing"
- Code has TODO/FIXME comments about removal
- Time pressure to ship
- Authority figure already approved
- "Small change" or "bug fix" claims
- Recently debugged/tested code

**When NOT to use:**
- Actively developing/debugging (mock data expected)
- Test files themselves (mocks belong there)
- Documentation examples (clearly marked)

## Core Pattern

### ❌ Before (Natural Agent Behavior)

```typescript
// Agent sees: Tests passing ✅ Renders correctly ✅ Code works ✅
// Agent ships without detecting:

export class AuthService {
  async login(email: string, password: string) {
    // TODO: Remove before production
    const mockUser = { id: '12345', role: 'admin' };
    return mockUser;
  }
}

const API_KEY = 'sk-test-1234567890abcdef';
```

**Why it fails:** Agent focused on positive signals (working), not negative evidence (shouldn't exist).

### ✅ After (With Systematic Scanning)

```
BEFORE SHIPPING - Mandatory Mock Data Scan:

Scanning for mock data patterns...

❌ BLOCKING ISSUES FOUND:

1. auth.service.ts:4 - Hardcoded mockUser object
2. auth.service.ts:3 - TODO comment: "Remove before production"
3. config.ts:1 - Test API key pattern: 'sk-test-*'

CANNOT SHIP - Remove all mock data first.
```

## Quick Reference - Detection Patterns

| Category | Patterns | Examples |
|----------|----------|----------|
| **Keywords** | mock, test, fake, sample, dummy, temp, placeholder | mockUser, testData, fakeAPI |
| **Email patterns** | test@, example.com, sample@ | test@example.com, admin@test.com |
| **ID patterns** | 12345, XXXXX, 00000, test-*, -test- | user-12345, test-user-123 |
| **API keys** | -test-, -dev-, -mock-, sk-test- | sk-test-abc123, dev-api-key |
| **Credentials** | test/password, admin/admin, hardcoded passwords | testuser:testpass |
| **URLs** | localhost, 127.0.0.1, example.com in configs | localhost:3000, http://example.com |
| **Comments** | TODO: Remove, FIXME, HACK, temporary, delete this | // TODO: Remove before production |
| **Debug flags** | DEBUG=true, enabled=true in prod, VERBOSE | DEBUG = True, ALLOWED_HOSTS = ["*"] |
| **Bypass logic** | if (id === 'test-*'), hardcoded returns | if (user === 'admin') return true |
| **Names** | Test, Mock, Sample, Demo, Example, Alice/Bob | Alice Mock, Bob Test, Demo User |

## Implementation

### Mandatory Scan Before Shipping

**Run this scan BEFORE approving any PR/deploy/ship action:**

```bash
# 1. Keyword scan
rg -i "\b(mock|test|fake|sample|dummy|temp|placeholder|TODO|FIXME|HACK)\b" \
   --type-not test \
   --type-not spec \
   --glob '!*.md' \
   --glob '!test/**' \
   --glob '!*.test.*' \
   --glob '!*.spec.*'

# 2. Pattern scan
rg -i "(test@|example\.com|12345|xxxxx|sk-test-|dev-secret|localhost|127\.0\.0\.1)" \
   --type-not test \
   --glob '!test/**' \
   --glob '!*.test.*'

# 3. Development config scan
rg -i "(DEBUG\s*=\s*[Tt]rue|ALLOWED_HOSTS\s*=\s*\[.*\*.*\]|NODE_ENV.*development)" \
   --glob '*config*' \
   --glob '*settings*' \
   --glob '*.env.example'

# 4. Commented production code scan
rg "^[\s]*//.*fetch|^[\s]*//.*API|^[\s]*//.*prod|^[\s]*#.*TODO" \
   --glob '!*.md'
```

**Exit codes:**
- 0 = patterns found → **BLOCK SHIP**
- 1 = no patterns → safe to proceed
- Any findings = review each one

### Verification Workflow

```
1. Developer claims ready to ship
   ↓
2. MANDATORY: Run mock data scan
   ↓
3. If ANY matches found:
   - Flag each match with file:line
   - BLOCK shipping action
   - Require removal before proceeding
   ↓
4. If NO matches found:
   - Proceed to other checks
   - Document scan completion
```

## Common Mistakes

### ❌ Trusting "Tests Passing"

Tests passing means functionality works, NOT that test data was removed.

**Reality:** Tests often pass WITH mock data because mocks fulfill the interface.

### ❌ "Senior Dev Approved"

Authority doesn't scan for mock data automatically. They review logic, not artifacts.

**Reality:** Senior devs focus on architecture/logic, assume junior cleaned up test data.

### ❌ "Small Change, Low Risk"

Size of change doesn't correlate with presence of mock data.

**Reality:** One-line bug fixes can have `TODO: Remove this mock` two lines above.

### ❌ "Can Clean Up Later"

Later never happens. Mock data ships and causes production incidents.

**Reality:** Production deploys with test@example.com, localhost URLs, debug flags enabled.

### ❌ "Developer Tested Thoroughly"

Manual testing doesn't detect what shouldn't be there, only what's broken.

**Reality:** Developers test behavior, not code cleanliness.

## Violating the Letter = Violating the Spirit

**There is no "spirit vs letter" distinction.**

If you skip mock data scan because:
- "I looked at the code, seems fine" → Not systematic, misses patterns
- "Tests are comprehensive" → Tests don't check for test artifacts
- "Time-critical deadline" → Production incidents are more critical

**You're violating both the letter AND the spirit of production-ready code.**

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Tests are passing" | Tests don't detect test data presence, only functionality |
| "Developer tested it thoroughly" | Manual testing focuses on behavior, not artifact removal |
| "Senior dev approved" | Authority reviews logic, assumes artifacts were cleaned |
| "Small change, low risk" | Change size doesn't correlate with mock data presence |
| "Can refactor later" | Later means production incident with test credentials |
| "TODO is just a reminder" | TODO before production = code not ready to ship |
| "Deadline pressure" | Shipping mock data creates bigger deadline: production fix |
| "Looks good to me" | Visual inspection misses patterns systematic scan catches |
| "They deserve to ship after all that work" | Production users deserve working code without test data |
| "It's clearly test data, won't be used" | If it's not removed, it CAN be used (security risk) |

**All of these mean: Run the scan. No exceptions.**

## Red Flags - STOP and Scan

If you find yourself thinking:

- "Tests are passing, should be fine"
- "Developer says it's ready"
- "Senior dev already reviewed"
- "Quick bug fix, just merge it"
- "Deadline is tight"
- "I manually reviewed the code"
- "It's obvious what's test vs production"

**STOP. Run systematic mock data scan.**

These thoughts indicate you're relying on positive evidence (what's working) instead of negative evidence (what shouldn't exist).

## Integration Points

**This skill integrates into:**

1. **verification-before-completion** - Add mock scan to verification checklist
2. **ship-check** - Make mock scan mandatory before shipping
3. **refactoring-safety-protocol** - Ensure refactors don't leave test scaffolding
4. **full-stack-integration-checker** - Check frontend/backend for test data
5. **Git hooks** - Pre-commit scan for mock patterns

## Real-World Impact

**Without systematic scanning:**
- Test API keys in production config files
- Mock users with admin privileges in production databases
- localhost URLs breaking production API calls
- DEBUG=True exposing stack traces to users
- Hardcoded test@example.com in user records

**With systematic scanning:**
- Block every PR with test artifacts
- Zero production incidents from mock data
- Automated detection, no manual oversight needed
- 15-second scan prevents hours of production debugging

## The Bottom Line

**Production readiness means systematic negative-evidence scanning, not just positive-evidence validation.**

Your brain sees what's working. Grep sees what shouldn't exist.

Trust the scan, not the rationalization.
