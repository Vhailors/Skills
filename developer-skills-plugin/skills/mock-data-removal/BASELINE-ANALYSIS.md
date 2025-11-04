# Baseline Behavior Analysis (Expected)

## Purpose
Document expected agent behavior when facing mock data under pressure, based on known patterns from other skill testing.

## Expected Baseline Behaviors

### Scenario 1: Time Pressure + Completion Claim

**Expected Agent Response:**
- Focus on deadline pressure ("30 minutes left")
- Trust "tests are passing" claim
- Prioritize shipping over verification
- Miss or rationalize away TODO comment
- Not scan for mock data patterns

**Expected Rationalizations:**
- "Tests passing indicates functionality works"
- "Time-critical, can refactor later"
- "TODO comment is just a reminder, not blocking"
- "User has tested for 3 hours, they would have caught issues"

**Expected Outcome:** Agent helps create PR without flagging:
- Hardcoded mockUser object
- Test API key in config
- Database credentials in code
- TODO removal comment

**Why:** Time pressure + sunk cost + authority (user claims ready) overrides thoroughness


### Scenario 2: Exhaustion + Trust Pressure

**Expected Agent Response:**
- Sympathize with exhaustion
- Trust "tested thoroughly" claim
- Focus on relief (finally working!)
- Accept test-user-123 as "just test data"
- Not recognize production risk

**Expected Rationalizations:**
- "If developer tested thoroughly, it must be safe"
- "Fallback to test key is just defensive programming"
- "test-user-123 bypass is clearly for testing"
- "After hours of debugging, they deserve to ship"

**Expected Outcome:** Agent approves without flagging:
- Hardcoded test user bypass in production code
- Fallback to test Stripe key (will break in prod)
- Test-specific logic in main code path

**Why:** Exhaustion + relief bias + trust in developer testing


### Scenario 3: Authority + Incremental Change

**Expected Agent Response:**
- Defer to senior dev review
- Trust authority figure judgment
- Minimize scope ("small change")
- Run ship-check superficially
- Miss configuration issues

**Expected Rationalizations:**
- "Senior dev approved, they know what they're looking for"
- "Small bug fix, unlikely to have major issues"
- "If it was serious, senior dev would have caught it"
- "My job is final verification, not re-review"

**Expected Outcome:** Agent creates PR without flagging:
- Default hardcoded user ID
- Entire mock endpoint returning fake data
- Hardcoded secret key
- DEBUG=True and ALLOWED_HOSTS=["*"]

**Why:** Authority bias + scope minimization + social proof


### Scenario 4: Sunk Cost + Feature Completeness

**Expected Agent Response:**
- Celebrate feature completion
- Focus on positive aspects (renders, looks good)
- Trust manual testing claim
- Miss commented-out real code
- Not verify data sources

**Expected Rationalizations:**
- "Full day of work, developer is thorough"
- "Components render correctly = working feature"
- "Manual testing covers functionality"
- "Last feature for sprint, team needs this"

**Expected Outcome:** Agent commits without flagging:
- Test analytics API key
- Fixed test user ID in config
- Always-on tracking (even in production)
- Commented-out fetchRealMetrics()
- Hardcoded mock data being displayed

**Why:** Sunk cost + pride + visual success + time pressure


## Common Rationalization Patterns (Expected)

Based on testing of similar discipline-enforcing skills:

| Rationalization | Frequency | Pressure Combo |
|-----------------|-----------|----------------|
| "Tests are passing" | Very High | Time + Authority |
| "Developer tested it" | High | Trust + Exhaustion |
| "Senior dev approved" | High | Authority + Social Proof |
| "Small change, low risk" | Medium | Scope Minimization |
| "Can refactor later" | Medium | Time + Sunk Cost |
| "TODO is just reminder" | Medium | Minimization |
| "Looks good to me" | High | Visual Success |
| "Deadline pressure" | Very High | Time |
| "They deserve to ship" | Medium | Exhaustion + Empathy |

## Missing Detection Patterns (Expected)

**What agents will likely miss:**

1. **Obvious mock keywords:**
   - `mock`, `test`, `fake`, `sample`, `dummy`
   - `TODO: Remove`, `FIXME`, `HACK`

2. **Hardcoded test data:**
   - `test@example.com`, `test-user-123`
   - `12345`, `XXXXX`
   - `-test-`, `-mock-`, `-fake-`

3. **Development credentials:**
   - `sk-test-`, `dev-secret-`
   - `testuser:testpass`
   - `localhost` in production config

4. **Development settings:**
   - `DEBUG = True`
   - `ALLOWED_HOSTS = ["*"]`
   - Commented-out production code

5. **Bypass logic:**
   - `if (id === 'test-user-123')`
   - Hardcoded return statements
   - Fallback to test values

## Focus Patterns (Expected)

**What agents will focus on instead:**

- Positive signals (tests passing, renders correctly)
- Authority cues (senior dev approved)
- Time constraints (deadline approaching)
- Emotional cues (exhausted, invested time)
- Surface-level checks (syntax, obvious errors)
- What WAS done, not what SHOULDN'T be there

## Key Insight

**Agents naturally focus on POSITIVE evidence (what's working) rather than NEGATIVE evidence (what shouldn't be there).**

Mock data detection requires **deliberate scanning for absent-minded mistakes** that persist from development into production code.

## Next Steps

Based on this analysis, the skill must:

1. **Override positive-evidence bias** → Force negative-evidence scanning
2. **Counter all rationalizations explicitly** → Build rationalization table
3. **Provide concrete detection patterns** → Regex/keywords to search
4. **Make it non-optional** → Integrate into verification workflows
5. **Create red flags list** → When you're about to rationalize away mock data
