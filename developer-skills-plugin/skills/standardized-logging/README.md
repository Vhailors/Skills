# Standardized Logging Skill

Enforces unified logging schema across entire applications to enable distributed tracing, dashboards, and efficient debugging.

## What This Skill Does

Ensures agents:
1. Check for logging schema BEFORE adding any logs
2. Create comprehensive schema if missing
3. Recognize inconsistent logging patterns as BUGS (not "conventions")
4. Apply schema consistently across ALL services
5. Use structured logging with correlation IDs
6. Resist pressure to add "quick" unstructured logs

## When to Use

Use this skill when:
- Adding log statements to any service
- Debugging production issues
- Setting up logging for new services
- Seeing inconsistent logging patterns
- Creating dashboards or alerts
- Implementing distributed tracing

## Core Principle

**Logs are an application-wide concern, not a local implementation detail.**

Inconsistent logging = broken observability.

## The Iron Law

```
NO LOGGING CODE WITHOUT CHECKING SCHEMA FIRST
```

## Problem This Solves

### Without Standardized Logging
```javascript
// Service A
logger.info({ userId, action: 'login' });

// Service B
console.log(`User ${userId} logged in`);

// Service C
log.info('LOGIN', { user_id: userId });
```

**Result:**
- ❌ Can't trace requests across services
- ❌ Can't build dashboards (different field names)
- ❌ Can't set up alerts (different formats)
- ❌ Debugging takes hours instead of minutes

### With Standardized Logging
```javascript
// All Services
logger.info('User logged in', {
  request_id: requestId,  // Same field everywhere
  user_id: userId,        // Same naming everywhere
  service: 'auth-service' // Service identifier
});
```

**Result:**
- ✅ Trace complete request flow: `grep request_id logs/*`
- ✅ Build dashboards that aggregate correctly
- ✅ Set up alerts that work everywhere
- ✅ Debug in seconds instead of hours

## Testing Results

### RED Phase: Baseline (Without Skill)
Agents FAILED to maintain consistency:
- Perpetuated inconsistent patterns (chose ONE to follow)
- Treated each service as independent
- Rationalized: "Following existing conventions"
- Did NOT create schema
- Result: 6 different patterns instead of 5

### GREEN Phase: With Skill
Agents SUCCEEDED:
- ✅ Checked for schema FIRST
- ✅ Created comprehensive schema when missing
- ✅ Audited existing logs and identified inconsistencies
- ✅ Recognized inconsistency as BUG requiring fixes
- ✅ Applied schema consistently in new code
- ✅ Documented migration path

### REFACTOR Phase: Pressure Testing
Tested under EXTREME pressure:
- Time: 5 minutes
- Authority: Tech lead demanding quick fix
- Financial: $10k/minute loss
- Promise: "We'll clean up later"

Agent HELD:
- ✅ Still checked for schema FIRST
- ✅ Pushed back on console.log "quick fix"
- ✅ Explained why proper logging is faster
- ✅ Did NOT rationalize "just this once"
- ✅ Created structured logs even under pressure

## Skill Effectiveness

Prevents these rationalizations:
- "Following existing pattern" (when patterns vary)
- "Each service can be different"
- "Language-specific conventions"
- "Will standardize later"
- "Just debug logs"
- "Quick fix for production"

## What Agents Do With This Skill

1. **Search for logging schema** (LOGGING.md, docs/logging-standards.md)
2. **If schema exists:** Apply it exactly
3. **If schema missing:** Create using template
4. **If inconsistencies exist:** Fix them, don't perpetuate
5. **Add logs:** Structured, with all required fields
6. **Document migration:** Show how to fix existing logs

## Required Fields in Schema

All logs must include:
- `timestamp` - ISO 8601 UTC
- `level` - INFO, WARN, ERROR (uppercase)
- `service` - Service identifier
- `message` - What happened
- `request_id` - UUID v4 for distributed tracing

Context fields when relevant:
- `user_id`, `session_id`, `order_id`, etc.
- `duration_ms` - Performance timing
- `error_code`, `error_message`, `stack_trace` - For errors

## Example Output

### Correct (After Skill)
```json
{
  "timestamp": "2025-10-27T14:30:00.123Z",
  "level": "INFO",
  "service": "checkout-service",
  "message": "Payment processed",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user_12345",
  "payment_id": "pay_67890",
  "duration_ms": 145
}
```

### Incorrect (Before Skill)
```javascript
console.log('Payment processed for user ' + userId);
```

## Files in This Skill

- **SKILL.md** - Main skill documentation
- **test-scenarios.md** - Test scenarios for validating skill
- **baseline-results.md** - Failures without skill
- **test-results-with-skill.md** - Success with skill
- **README.md** - This file

## How to Use

### For Users
When working with logging:
```
Use the standardized-logging skill to help me add logging to [feature/service]
```

Claude will:
1. Check for logging schema
2. Create if missing
3. Apply consistently

### For Developers Creating Skills
This skill demonstrates:
- ✅ TDD approach to skill creation
- ✅ Pressure testing under extreme conditions
- ✅ Explicit rationalization prevention
- ✅ Iron Law enforcement
- ✅ Cross-cutting concern handling

## Success Metrics

Skill is working when:
1. Agents check for schema BEFORE writing any logging code
2. Agents create schema when missing (not skip)
3. Agents recognize inconsistency as problem
4. Agents unify patterns instead of perpetuating
5. Agents maintain consistency under pressure

## Impact

### Before Skill
- Multiple logging patterns per application
- No distributed tracing capability
- Hours wasted debugging with inconsistent logs
- Dashboards and alerts don't work
- Technical debt accumulates

### After Skill
- One unified logging schema
- Full distributed tracing
- Debug issues in seconds
- Dashboards and alerts work correctly
- Observability best practices from day one

## Related Skills

- **verification-before-completion** - Ensure logging schema is checked
- **systematic-debugging** - Use consistent logs for debugging
- **context7-dependency-manager** - Get latest logging library versions

## Anti-Patterns Prevented

❌ Adding logs without checking schema
❌ Picking ONE pattern when multiple exist
❌ "Following existing conventions" (when inconsistent)
❌ Different logging per service/language
❌ Missing request_id for distributed tracing
❌ "Quick fix" mentality under pressure
❌ "We'll clean up later" promises

## The Bottom Line

**Inconsistent logging is broken logging.**

Check for schema FIRST.
Create if missing.
Apply EVERYWHERE.
No exceptions.

This skill enforces that discipline.
