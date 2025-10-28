# Test Scenarios for Standardized Logging Skill

## Purpose
Test whether agents maintain consistent logging schema across an application without explicit guidance.

## Pressure Types
1. **Time pressure** - "Quick fix needed"
2. **Context switching** - Working across multiple files/components
3. **Feature addition** - Adding new functionality with logs
4. **Bug fixing** - Adding debug logs under pressure
5. **Different tech stacks** - Frontend vs backend vs microservices

## Test Scenarios

### Scenario 1: Academic Test (Understanding)
**Goal:** Does the agent understand what logging consistency means?

**Prompt:**
```
You're working on an application. Explain what it means to maintain a consistent logging schema across the entire application and why it matters.
```

**Success criteria:**
- Mentions structured logging
- Mentions consistent field names
- Mentions log levels
- Mentions why it helps (searching, monitoring, debugging)

---

### Scenario 2: New Feature Under Time Pressure
**Goal:** Will agent maintain consistency when adding feature quickly?

**Setup:**
Create a mock project with existing logs like:
```javascript
// existing-service.js
logger.info('User login successful', {
  userId: user.id,
  timestamp: Date.now(),
  source: 'auth-service',
  action: 'login'
});
```

**Prompt:**
```
URGENT: Add logging to the new payment processing feature in payment-service.js.
Need this deployed in 20 minutes. Just get it working quickly.
```

**Expected violations:**
- Different field names (user_id vs userId)
- Different timestamp formats
- Missing fields (source, action)
- Inconsistent log levels
- Plain string logs vs structured

---

### Scenario 3: Bug Fix Across Multiple Services
**Goal:** Will agent maintain schema when adding debug logs?

**Setup:**
Three services with different logging patterns:
```python
# service_a.py - structured
logger.info("request_received", extra={"request_id": req_id, "endpoint": "/api/users"})

# service_b.js - string format
console.log(`[INFO] Processing order ${orderId}`);

# service_c.go - different structure
log.Printf("level=info msg=database_query duration=%d", duration)
```

**Prompt:**
```
There's a bug where requests are timing out across these three services.
Add logging to help debug the issue. Focus on getting the logs in quickly to debug production.
```

**Expected violations:**
- Adopting the local pattern instead of maintaining consistency
- Adding ad-hoc fields without standardization
- Mixing structured and unstructured logs
- Not defining schema for new fields

---

### Scenario 4: Context Switching (Frontend + Backend)
**Goal:** Does agent maintain schema across different tech stacks?

**Setup:**
```typescript
// backend/api.ts
logger.info('API request', {
  requestId: req.id,
  method: req.method,
  path: req.path,
  duration: 45
});

// frontend/app.tsx
console.log('User clicked button', { userId: user.id });
```

**Prompt:**
```
Add error tracking logs to both the frontend React app and the backend Express API.
The frontend should log when API calls fail, and the backend should log when database queries fail.
```

**Expected violations:**
- Different schemas for frontend vs backend
- Missing correlation IDs between frontend/backend
- Inconsistent error field names (error vs err vs errorMessage)
- No shared timestamp format

---

### Scenario 5: Sunk Cost + Authority Pressure
**Goal:** Will agent maintain consistency when lots of code already written?

**Setup:**
Agent has written 200 lines of new feature code. At the end:

**Prompt:**
```
Great work! Before we ship, add logging throughout the feature you just built.
My tech lead wants logs for monitoring. Make it quick so we can deploy.
```

**Expected violations:**
- Inconsistent schema within the new feature itself
- Not checking existing logging patterns first
- Ad-hoc field names chosen per function
- "Good enough" mentality due to sunk cost

---

### Scenario 6: Multiple Developers Pattern (Implicit)
**Goal:** Will agent notice inconsistency and fix vs perpetuate?

**Setup:**
Codebase with 5 different logging patterns:
```javascript
// Pattern 1 - structured with context
logger.info({ userId, action: 'login', timestamp: Date.now() });

// Pattern 2 - message + object
logger.info('User logged in', { userId });

// Pattern 3 - plain string
console.log(`User ${userId} logged in`);

// Pattern 4 - different field names
logger.log('info', { user_id: userId, event: 'LOGIN' });

// Pattern 5 - minimal
log('login', userId);
```

**Prompt:**
```
Add logging to the new shopping cart feature. Make sure you follow the existing patterns in the codebase.
```

**Expected violations:**
- Following ONE pattern instead of creating consistency
- Not recognizing the inconsistency as a problem
- Rationalizing: "I'm following existing patterns"

---

## Baseline Testing Protocol

For each scenario:
1. Create minimal test project with setup code
2. Run scenario with subagent WITHOUT standardized-logging skill
3. Document exact behavior:
   - What logging code did they write?
   - What rationalizations did they use?
   - Did they recognize inconsistency?
   - Did they attempt to fix or perpetuate?
4. Capture verbatim quotes of rationalizations

## Success Metrics for Baseline

**We want to see agents FAIL at:**
- Maintaining consistent field names across contexts
- Using consistent timestamp formats
- Checking existing patterns before adding logs
- Creating a schema when one doesn't exist
- Recognizing inconsistency as a problem

**Rationalizations to capture:**
- "This matches the local pattern"
- "Good enough for debugging"
- "Quick logs for now, will standardize later"
- "Following existing conventions"
- "Frontend and backend can be different"

## Next Steps

1. Run Scenario 1 (academic) to verify agent understands concept
2. Run Scenarios 2-6 with subagents to capture baseline violations
3. Document all rationalizations verbatim
4. Identify patterns in failures
5. THEN write skill addressing those specific failures
