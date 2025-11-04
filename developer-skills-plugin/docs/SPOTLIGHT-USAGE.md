# Spotlight MCP Integration: Usage Guide

## Overview

Spotlight integration enhances your debugging and verification workflows by providing real-time access to runtime errors, traces, and logs captured during development. This guide explains how Spotlight integrates with the developer-skills superflows.

## How It Works

```
Your App (with Sentry SDK) → Captures Errors/Traces/Logs
         ↓
Spotlight Sidecar (localhost:8969) → Stores telemetry locally
         ↓
Spotlight MCP Server (stdio) → Exposes data via MCP protocol
         ↓
Claude Code + developer-skills → Queries data in workflows
         ↓
Enhanced Debugging → Uses actual error data for better fixes
```

## Automatic Integration Points

### 1. 🐛 Debugging Superflow (Automatic)

When you report a bug or error, the debugging superflow automatically checks Spotlight:

**Trigger words:**
- "bug", "error", "issue", "problem", "broken", "not working", "crash", "debug"

**What happens:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🐛 DEBUGGING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔎 SPOTLIGHT INTEGRATION ACTIVE:
Spotlight MCP server is configured. Querying for:
- Recent runtime errors with full stack traces
- Error context (request data, user state, etc.)
- Error frequency and patterns

[Claude queries Spotlight automatically]
[Uses error details to search memory]
[Proposes fix based on actual error data]
```

**Example conversation:**

```
You: "There's an error when users try to log in"

Claude:
🔎 Checking Spotlight for recent errors...

Found 1 error in the last 5 minutes:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Error: Cannot read property 'email' of undefined
Location: auth/middleware.ts:42
Timestamp: 2025-10-31T09:30:15Z
Stack trace:
  at authenticateUser (auth/middleware.ts:42)
  at POST /api/login (routes/auth.ts:15)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Searching memory for similar "undefined property" errors...
[Applies known fix or debugs systematically]
```

**Benefits:**
- ✅ No need to manually describe the error
- ✅ Exact stack trace and line numbers
- ✅ Full error context (request data, user state)
- ✅ Better memory search with specific error details
- ✅ Faster debugging with actual data

### 2. ✅ Post-Test Error Detection (Automatic)

After running tests, Spotlight automatically checks for runtime errors:

**Triggers:**
- Any test command: `npm test`, `yarn test`, `jest`, `vitest`, `pytest`, etc.

**What happens:**

```
You: "Run the tests"

[Claude runs: npm test]
[Tests complete - all pass ✓]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🔎 Spotlight Post-Test Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tests passed, but Spotlight detected runtime errors:
- 2 console.error calls during test execution
- 1 unhandled promise rejection
- 1 React render error (caught by error boundary)

These errors didn't fail tests but indicate issues.
Investigating...
```

**Why this matters:**

Tests may pass while producing errors that Spotlight catches:
- **Unhandled promise rejections** - API calls that fail silently
- **Console errors** - Errors logged but not asserted
- **Render errors** - React errors caught by boundaries
- **Network failures** - Failed requests not checked by tests
- **Memory warnings** - Resource leaks during tests

**Example scenario:**

```javascript
// Test passes ✓
test('fetches user data', async () => {
  const result = await fetchUser(123);
  expect(result).toBeDefined();  // Passes even if error occurred
});

// But Spotlight captures:
// Error: Network request failed (500)
// Warning: Memory leak detected in UserProfile component
```

Without Spotlight: Test passes, you ship the code
With Spotlight: Error detected, you fix before shipping

### 3. 🏗️ Verification Workflow (Manual)

Before marking work as complete, check Spotlight manually:

**Commands:**
- `/check-integration` - Includes Spotlight error check
- `/ship-check` - Comprehensive pre-ship validation

**What happens:**

```
You: "I'm done with the login feature"

Claude:
Before marking complete, I'll run verification...

Running /check-integration...
✓ Database schema complete
✓ API endpoints complete
✓ Frontend UI complete

Checking Spotlight for errors...
⚠️ Found 1 error during integration testing:
- TypeError in login validation
- Location: validators/auth.ts:28

This must be fixed before completion.
```

**Manual Spotlight check:**

```bash
# Check status
bash developer-skills-plugin/hooks/scripts/spotlight-query.sh status

# Get error summary
bash developer-skills-plugin/hooks/scripts/spotlight-query.sh summary
```

## Manual MCP Queries

You can explicitly ask Claude to query Spotlight:

### Query Recent Errors

```
You: "Query Spotlight for errors in the last 10 minutes"

Claude: [Queries Spotlight MCP server]
[Shows errors with details]
```

### Filter by Type

```
You: "Check Spotlight for any JavaScript errors"
You: "Show me console.error calls from Spotlight"
You: "Get trace data from Spotlight for the login flow"
```

### Time-Based Queries

```
You: "What errors occurred in the last hour?"
You: "Check Spotlight since I started the app"
You: "Show recent errors after timestamp 2025-10-31T09:00:00Z"
```

## Workflow Examples

### Example 1: Debugging an Unknown Error

**Without Spotlight:**
```
You: "The app crashed but I don't know why"
Claude: "Can you share the error message?"
You: "I don't have it, the console cleared"
Claude: "Can you reproduce it?"
[Back and forth, time wasted]
```

**With Spotlight:**
```
You: "The app crashed but I don't know why"
Claude: [Queries Spotlight immediately]
       "I see the error in Spotlight:
        TypeError: Cannot read property 'map' of undefined
        Location: components/UserList.tsx:56
        Occurred at: 2025-10-31T09:45:22Z

        This is because the API returned null instead of an array.
        Fixing now..."
```

### Example 2: Post-Test Validation

**Without Spotlight:**
```
You: "Run the tests"
Claude: [Runs tests]
       "All 47 tests passed ✓
        Work is complete!"
[Ships code with hidden errors]
```

**With Spotlight:**
```
You: "Run the tests"
Claude: [Runs tests]
       "All 47 tests passed ✓

        However, Spotlight captured 3 errors during tests:
        1. Unhandled promise rejection in UserService
        2. React warning: setState on unmounted component
        3. Failed API call: 500 response from /api/users

        These need to be fixed before shipping.
        Investigating the first error..."
```

### Example 3: Feature Completion Validation

**Standard flow:**
```
You: "Is the comments feature done?"
Claude: [Runs /check-integration]
       ✓ Database schema complete
       ✓ API endpoints implemented
       ✓ Frontend UI working
       ✓ Tests passing

       [Checks Spotlight]
       ✓ No runtime errors detected

       Feature is complete and verified!
```

**With Spotlight finding issues:**
```
You: "Is the comments feature done?"
Claude: [Runs /check-integration]
       ✓ Database schema complete
       ✓ API endpoints implemented
       ✓ Frontend UI working
       ✓ Tests passing

       [Checks Spotlight]
       ⚠️ Spotlight detected 2 issues:

       1. Warning: Memory leak in CommentList component
          → Needs useEffect cleanup

       2. Error: Rate limit not enforced
          → POST /api/comments allows spam

       Fixing these issues before marking complete...
```

## Best Practices

### 1. Keep Your App Running

Spotlight only captures data while your app is running:

```bash
# Terminal 1: Run your app with Spotlight
SENTRY_SPOTLIGHT=1 npm run dev

# Terminal 2: Use Claude Code for development
# Claude can now query Spotlight for errors
```

### 2. Trigger Test Errors Intentionally

When testing the integration:

```javascript
// Temporarily add a test error
console.error('Test error for Spotlight integration');
throw new Error('Testing Spotlight capture');
```

Then ask Claude: "Debug this error"

### 3. Clear Old Errors

Spotlight accumulates errors. To start fresh:

```bash
# Restart your app (clears Spotlight data)
# Or restart Spotlight sidecar
```

### 4. Use Spotlight During Code Review

Before committing changes:

```
You: "Review my changes and check for errors"

Claude: [Reviews code]
       [Queries Spotlight for errors during review]
       [Reports any issues found]
```

### 5. Combine with Memory Search

Spotlight + Memory = Powerful debugging:

```
1. Spotlight provides actual error details
2. Memory search finds similar past errors
3. Claude applies known fix or debugs systematically
```

## Limitations & Fallbacks

### When Spotlight Isn't Available

If Spotlight isn't running or configured, workflows gracefully fall back:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## 🐛 DEBUGGING SUPERFLOW: ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ️ Spotlight not available (app not running or not configured).
Proceeding with standard debugging workflow...
```

**Standard debugging still works:**
- Memory-assisted debugging
- Systematic debugging (4 phases)
- Manual error description
- Code analysis

### Spotlight Limitations

**What Spotlight CAN'T do:**
- ❌ Capture errors from closed apps (real-time only)
- ❌ Capture errors before Sentry SDK initialized
- ❌ Capture errors in non-instrumented code
- ❌ Time-travel to past sessions (use Sentry cloud for history)

**What Spotlight CAN do:**
- ✅ Capture all errors while app is running
- ✅ Provide full stack traces and context
- ✅ Show distributed traces across services
- ✅ Log all console output
- ✅ Track performance metrics

## Troubleshooting

### "No errors in Spotlight"

If Spotlight isn't capturing errors:

1. **Verify Spotlight is running:**
   ```bash
   curl http://localhost:8969
   # Should return Spotlight UI
   ```

2. **Check Sentry SDK is initialized:**
   ```javascript
   // Should be at top of your app
   Sentry.init({ spotlight: true });
   ```

3. **Trigger a test error:**
   ```javascript
   console.error('Test error');
   ```

4. **Check environment variable:**
   ```bash
   echo $SENTRY_SPOTLIGHT  # Should be "1"
   ```

### "Claude doesn't query Spotlight"

If debugging superflow doesn't mention Spotlight:

1. **Use clear trigger words:**
   - "debug this error"
   - "fix this bug"
   - "there's an error"

2. **Check hook is active:**
   - Look for "🔎 SPOTLIGHT INTEGRATION ACTIVE" in response
   - If missing, hooks might not be enabled

3. **Verify MCP configuration:**
   ```bash
   cat developer-skills-plugin/.mcp.json
   ```

### "Spotlight data is stale"

If errors are old or not recent:

1. **Restart your app** (clears Spotlight data)
2. **Reproduce the error** while app is running
3. **Query immediately** after error occurs

## Advanced Usage

### Custom MCP Queries

If you understand the MCP protocol, you can query specific tools:

```
You: "Use the Spotlight MCP tool 'get_errors' with parameter since='5m'"
```

(Tool names depend on what Spotlight MCP server exposes)

### Integration with Other Tools

Combine Spotlight with other debugging tools:

```
You: "Check Spotlight for errors, then check browser DevTools logs, then debug"

Claude: [Comprehensive multi-source debugging]
```

### CI/CD Integration (Future)

Spotlight is development-only, but you can:

1. Capture Spotlight data during local testing
2. Include Spotlight checks in pre-commit hooks
3. Block commits if Spotlight shows errors

## Getting Help

**Workflow Issues:**
- Review [SPOTLIGHT-SETUP.md](./SPOTLIGHT-SETUP.md)
- Check [TROUBLESHOOTING.md](../hooks/TROUBLESHOOTING.md)
- Verify hooks are active: Should see superflow activation messages

**Spotlight Issues:**
- Spotlight docs: https://spotlightjs.com/docs/
- GitHub issues: https://github.com/getsentry/spotlight/issues

**Plugin Issues:**
- Check hook logs in Claude Code output
- File issue in developer-skills repo

## Summary

**Automatic integrations:**
- 🐛 Debugging: Queries Spotlight for error details
- ✅ Post-test: Checks for errors after tests run
- 🏗️ Verification: Includes Spotlight in completion checks

**Benefits:**
- Real-time error data
- Full stack traces and context
- Catches errors tests miss
- Faster debugging with actual data
- Better quality before shipping

**Best practices:**
- Keep app running with Spotlight enabled
- Use SENTRY_SPOTLIGHT=1 in development
- Check Spotlight before marking work complete
- Combine with memory search for powerful debugging

**Next steps:**
- Try the debugging workflow with a test error
- Run tests and observe post-test error detection
- Use `/ship-check` to see comprehensive validation

Happy debugging! 🔎
