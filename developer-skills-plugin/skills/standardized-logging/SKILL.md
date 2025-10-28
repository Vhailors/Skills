---
name: standardized-logging
description: Use when adding logs, debugging with logs, or seeing inconsistent logging patterns across services - enforces unified logging schema application-wide with consistent field names, formats, and correlation IDs
---

# Standardized Logging

## Overview

**Logs are an application-wide concern, not a local implementation detail.**

Inconsistent logging makes distributed systems undebuggable. Different field names, formats, or schemas per service = broken observability.

**Core principle:** Check for logging schema FIRST. Create if missing. Apply EVERYWHERE.

## The Iron Law

```
NO LOGGING CODE WITHOUT CHECKING SCHEMA FIRST
```

Before adding ANY log statement:
1. Check for logging schema (LOGGING.md, logging-standards.md, etc.)
2. If schema exists → Apply it exactly
3. If schema missing → Create it, THEN log

**No exceptions:**
- Not for "quick debug logs"
- Not for "just one service"
- Not for "temporary logging"
- Not when "following existing patterns" (if patterns are inconsistent)

## When to Use

**Use this skill when:**
- Adding new log statements to any service
- Debugging production issues with logging
- Setting up logging for a new service/component
- Seeing different logging patterns across services
- Creating dashboards or alerts based on logs
- Implementing distributed tracing

## The Gate Function

```
BEFORE adding any logging code:

1. SEARCH: Does logging schema exist?
   - Look for: LOGGING.md, docs/logging-standards.md, .github/LOGGING.md
   - Search codebase for "logging schema" or "logging standards"

2. IF SCHEMA EXISTS:
   - READ it completely
   - VERIFY current logs follow it (check 3-5 existing log statements)
   - IF inconsistencies found → FIX THEM, don't perpetuate
   - APPLY schema to new logs exactly

3. IF NO SCHEMA:
   - CREATE logging schema using template below
   - AUDIT existing logs and unify them
   - THEN add new logs

4. IF MULTIPLE PATTERNS EXIST:
   - This is a BUG, not "existing conventions"
   - STOP and unify before adding more logs
   - Do NOT pick one pattern and perpetuate others

5. CROSS-SERVICE PROJECTS:
   - Schema MUST work across all services
   - Field names IDENTICAL everywhere
   - Timestamp formats IDENTICAL everywhere
   - No "per-service" or "per-language" exceptions
```

## Logging Schema Template

When no schema exists, create this document:

```markdown
# Logging Schema

## Required Fields (ALL logs must include)

| Field | Type | Format | Example | Purpose |
|-------|------|--------|---------|---------|
| timestamp | string | ISO 8601 UTC | "2025-10-27T14:30:00.123Z" | When |
| level | string | uppercase | "INFO", "WARN", "ERROR" | Severity |
| service | string | kebab-case | "payment-service" | Which service |
| message | string | sentence case | "Payment processed successfully" | What happened |
| request_id | string | UUID v4 | "550e8400-e29b-41d4-a716-446655440000" | Trace requests |

## Context Fields (Include when relevant)

| Field | Type | When to Include | Example |
|-------|------|-----------------|---------|
| user_id | string | User actions | "user_12345" |
| session_id | string | Session-scoped operations | "sess_abc123" |
| duration_ms | number | Operation timing | 145 |
| error_code | string | Errors | "PAY_001" |
| error_message | string | Errors | "Insufficient funds" |
| stack_trace | string | Exceptions | Full stack trace |

## Log Levels

- **DEBUG**: Development details, not in production
- **INFO**: Normal operation events (user actions, system events)
- **WARN**: Unexpected but recoverable situations
- **ERROR**: Failures requiring attention
- **FATAL**: Application crashes

## Examples

### Successful Operation
```json
{
  "timestamp": "2025-10-27T14:30:00.123Z",
  "level": "INFO",
  "service": "payment-service",
  "message": "Payment processed successfully",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user_12345",
  "payment_id": "pay_67890",
  "amount": 99.99,
  "currency": "USD",
  "duration_ms": 145
}
```

### Error
```json
{
  "timestamp": "2025-10-27T14:30:00.123Z",
  "level": "ERROR",
  "service": "payment-service",
  "message": "Payment processing failed",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user_12345",
  "payment_id": "pay_67890",
  "error_code": "PAY_INSUFFICIENT_FUNDS",
  "error_message": "Insufficient funds in account",
  "duration_ms": 89
}
```

## Correlation ID Propagation

**Request ID must flow through ALL services:**

1. **Entry point** generates request_id (UUID v4)
2. **All services** log with same request_id
3. **HTTP headers**: Pass as `X-Request-ID`
4. **Message queues**: Include in message metadata
5. **Database calls**: Include in query comments

## Language-Specific Implementation

Use structured logging libraries:
- **JavaScript/TypeScript**: winston, pino
- **Python**: structlog, python-json-logger
- **Go**: zap, zerolog
- **Java**: logback with logstash-encoder
- **Rust**: slog, tracing

**Configuration MUST produce identical JSON output across all languages.**
```

## Common Violations

| Violation | Fix |
|-----------|-----|
| "Following existing pattern" (when patterns vary) | Recognize inconsistency as BUG. Unify all patterns first. |
| Different schemas per service | ONE schema for entire application, no exceptions |
| Different field names (user_id vs userId vs UserId) | Pick ONE format, apply everywhere |
| Plain string logs (console.log) | Always structured (JSON object) |
| Missing request_id | ALL logs need correlation ID |
| Timestamp as epoch integer | ISO 8601 string for human+machine readability |
| Log level as lowercase | Uppercase for easy filtering |
| Service-specific patterns for "quick fixes" | Quick fixes become permanent. Do it right. |

## Red Flags - STOP

- Adding logs without checking for schema first
- Seeing 2+ different logging patterns and picking one
- "Following existing conventions" when conventions are inconsistent
- "I would standardize..." (conditional = not doing it)
- "Easy to grep" (only true if formats are identical everywhere)
- Different logging per language/framework
- Request_id in some services but not others
- Any sentence starting with "For now..." or "Quick..."

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Following existing pattern" | If patterns vary, following one perpetuates the problem |
| "Each service can be different" | Distributed tracing requires identical schemas |
| "Language-specific conventions" | Observability > language conventions |
| "Will standardize later" | Later never happens. Do it now. |
| "Just debug logs" | Debug logs become permanent |
| "Quick fix for production" | Bad logs make debugging harder, not easier |
| "Per-service schemas are fine" | You can't correlate logs with different schemas |
| "I'll grep for the request_id" | Only works if field names and formats match |

## Quick Reference

### Before Adding Logging

```
[ ] Check for logging schema document
[ ] If exists → verify existing logs follow it
[ ] If inconsistencies → unify before proceeding
[ ] If missing → create schema first
[ ] Ensure request_id propagation works
```

### Adding a Log Statement

```javascript
// ✅ CORRECT: Structured, all required fields, matches schema
logger.info('Payment processed', {
  request_id: req.id,  // Correlation
  user_id: user.id,    // Context
  payment_id: payment.id,
  amount: payment.amount,
  duration_ms: elapsed
});

// ❌ WRONG: String format, no structure
console.log(`Payment ${payment.id} processed for user ${user.id}`);

// ❌ WRONG: Different field names
logger.info({
  reqId: req.id,        // Should be request_id
  userId: user.id,      // Should be user_id (check schema!)
  paymentId: payment.id // Inconsistent with schema
});
```

### Distributed Tracing

```
1. Generate request_id at entry point:
   const requestId = crypto.randomUUID();

2. Log with request_id in FIRST service:
   logger.info('Request received', { request_id: requestId, ... });

3. Propagate via HTTP header:
   headers: { 'X-Request-ID': requestId }

4. Extract in SECOND service:
   const requestId = req.headers['x-request-id'];

5. Log with SAME request_id:
   logger.info('Processing order', { request_id: requestId, ... });

6. Query logs across ALL services:
   grep "request_id.*550e8400-e29b-41d4-a716-446655440000" logs/*.log
```

## Implementation Checklist

**When setting up logging:**

- [ ] Create LOGGING.md in repository root
- [ ] Define required fields (timestamp, level, service, message, request_id)
- [ ] Define context fields (user_id, session_id, etc.)
- [ ] Specify field name conventions (snake_case vs camelCase)
- [ ] Document correlation ID propagation
- [ ] Choose structured logging library per language
- [ ] Configure libraries to produce identical JSON
- [ ] Audit existing logs for inconsistencies
- [ ] Fix all inconsistencies before adding new logs
- [ ] Add logging schema check to code review checklist

## Why This Matters

**Without unified logging:**
- ❌ Can't trace requests across services
- ❌ Can't build dashboards (field names differ)
- ❌ Can't set up alerts (log formats vary)
- ❌ Can't debug production issues efficiently
- ❌ Observability tools can't parse logs
- ❌ Team wastes hours grepping with different field names

**With unified logging:**
- ✅ One query works across all services
- ✅ Dashboards aggregate correctly
- ✅ Alerts work consistently
- ✅ Trace requests end-to-end
- ✅ Faster debugging (consistent format)
- ✅ Observability tools parse automatically

## The Bottom Line

**Logs are not code-local. They're application-wide.**

Check for schema FIRST.
Create if missing.
Apply EVERYWHERE.
No exceptions.

Inconsistent logging is broken logging.
