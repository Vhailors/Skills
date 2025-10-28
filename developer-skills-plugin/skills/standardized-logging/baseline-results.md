# Baseline Test Results (Without Skill)

## Summary

Agents UNDERSTAND logging consistency intellectually but FAIL to enforce it in practice under pressure.

## Key Findings

### ✅ What Agents Do Well
- Understand the concept of structured logging
- Can explain why consistency matters
- Follow consistent patterns when only ONE pattern exists
- Include relevant context fields

### ❌ Where Agents Fail

#### 1. Perpetuating Inconsistency (Scenario 6)
**Violation:** When seeing multiple inconsistent patterns, agents pick ONE they like best and use it for their code, but DON'T fix the existing inconsistency.

**Observed behavior:**
- Analyzed 5 different logging patterns
- Chose Pattern 2 as "best"
- Applied it consistently in their new code
- Result: Now 6 different patterns exist instead of 5

**Rationalizations captured:**
> "Pattern 1 and Pattern 2 are the most production-ready"
> "I would recommend Pattern 2 as it provides both human readability and structured data"
> "If I were to standardize the entire codebase, I would refactor..." (BUT DIDN'T)

**Root cause:** Treating logging as code-specific rather than application-wide concern.

---

#### 2. Service-Specific Schemas (Scenario 3)
**Violation:** Agents maintain DIFFERENT logging schemas per service/language instead of enforcing cross-service consistency.

**Observed behavior:**
- Python service: Kept Python's structured logging format
- JavaScript service: Kept JS string format
- Go service: Kept Go's Printf format
- Added timing and request_id but in DIFFERENT formats per service

**Rationalizations captured:**
> "The key is to track request flow, timing, and identify where the bottleneck occurs"
> "After deploying these logs, grep for a specific request_id across all three services"

**Problem:** You CAN'T easily grep across services because:
- Python: `"request_id": req_id` (JSON with underscore)
- JavaScript: `request_id: reqId` (key-value with camelCase)
- Go: `request_id=%s` (Printf format)

**Root cause:** Not defining a logging schema FIRST before implementing.

---

#### 3. "Follow Existing Patterns" Trap
**Violation:** Agents rationalize inconsistency as "following existing conventions."

**Rationalizations captured:**
> "Followed the existing pattern to minimize risk"
> "Uses the same pattern as checkout.js"
> "The descriptive message strings make it easy to grep/search logs"

**Problem:** Following inconsistent patterns perpetuates the problem.

---

#### 4. No Schema Definition
**Violation:** Agents add logs without first defining or checking for a logging schema.

**What's missing:**
- No check for logging schema document
- No definition of required fields
- No standardization of field names across services
- No timestamp format specification
- No log level guidelines

**Root cause:** Treating logs as local implementation detail, not cross-cutting concern.

---

#### 5. Missing Cross-Service Correlation
**Violation:** Even when agents add request_id for tracing, they don't ensure it works ACROSS services.

**Observed in Scenario 3:**
- Each service logs request_id
- But in different formats and locations
- No guidance on propagating request_id between services
- No standard for correlation IDs

---

## Rationalization Patterns

| Rationalization | Reality |
|----------------|---------|
| "Followed existing pattern" | Perpetuates inconsistency when patterns vary |
| "Uses Pattern X like service Y" | Local consistency ≠ application-wide consistency |
| "Easy to grep/search logs" | Only if field names and formats are identical across services |
| "If I were to standardize..." | Conditional statements = not actually doing it |
| "Production-ready" | Inconsistent logs are NOT production-ready |
| "Both human-readable and structured" | Doesn't matter if each service does it differently |

## Red Flags Observed

- ✅ Agents check existing logs before adding new ones (GOOD)
- ❌ But they pick ONE pattern to follow instead of unifying all patterns
- ❌ No check for logging schema documentation
- ❌ No attempt to standardize existing logs
- ❌ Service boundaries treated as logging boundaries
- ❌ "Would standardize" language (conditional, not imperative)

## What Skill Must Address

1. **FIRST CHECK** for logging schema before adding ANY logs
2. **RECOGNIZE** inconsistency as a problem requiring fixes, not perpetuation
3. **UNIFY** logging across services/components, not just within new code
4. **DEFINE** schema if none exists (required fields, formats, conventions)
5. **CROSS-SERVICE** consistency is non-negotiable for distributed systems
6. **PROPAGATE** correlation IDs in standardized format
7. **RESIST** "follow local pattern" when patterns are inconsistent

## Success Metrics for Skill

After skill is applied, agents should:
1. Check for logging schema FIRST (before any logging code)
2. Create schema if missing
3. Identify inconsistencies in existing logs
4. Propose unification plan
5. Apply consistent schema across ALL services
6. Use same field names and formats everywhere
7. Document correlation ID propagation

## Next Steps

Write skill that:
1. Makes checking for schema the FIRST step (before any logging)
2. Provides schema template
3. Explicitly forbids perpetuating inconsistency
4. Requires cross-service consistency
5. Addresses each rationalization directly
