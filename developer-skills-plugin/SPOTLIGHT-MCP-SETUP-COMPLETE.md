# ✅ Spotlight MCP Setup - Complete Guide

**Status**: Fully configured and ready to test
**Date**: November 2, 2025
**Spotlight Version**: 3.0.0

---

## 🎯 What's Been Set Up

### 1. MCP Server Configuration

**Location**: `developer-skills-plugin/.mcp.json`

```json
{
  "mcpServers": {
    "sentry-spotlight": {
      "command": "npx",
      "args": [
        "-y",
        "--prefer-online",
        "@spotlightjs/spotlight@latest",
        "mcp"
      ],
      "env": {
        "SPOTLIGHT_PORT": "8969",
        "NODE_ENV": "development"
      }
    }
  }
}
```

✅ **Verified**: Spotlight MCP v3.0.0 is accessible via npx

### 2. VedereLMS Test App Configuration

**Sentry SDK**: Already installed (`@sentry/nextjs`)

**Configuration Files**:
- `sentry.client.config.ts` - Line 26: `spotlight: process.env.NODE_ENV === 'development'`
- `sentry.server.config.ts` - Line 16: `spotlight: process.env.NODE_ENV === 'development'`

**Environment Variables** (`.env.local`):
```bash
SENTRY_ENABLED=1           # Line 35 - Enables Sentry in development
SENTRY_SPOTLIGHT=1         # Line 38 - Enables Spotlight sidecar
```

✅ **Status**: VedereLMS is fully configured for Spotlight

### 3. Available MCP Tools

When Spotlight is running and connected, you have access to:

| Tool | Purpose |
|------|---------|
| `spotlight.errors.search` | Search for errors with stack traces and context |
| `spotlight.logs.search` | Query application logs to understand behavior |
| `spotlight.traces.search` | List recent performance traces with summary info |
| `spotlight.traces.get` | Get detailed span timing for specific traces |

---

## 🚀 How to Use Spotlight MCP

### Step 1: Start VedereLMS with Spotlight

```bash
cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS
npm run dev
```

**Expected Console Output**:
```
🔎 [Spotlight] Spotlight by Sentry
🔎 [Spotlight] Sidecar running on http://localhost:8969
```

### Step 2: Trigger an Error (For Testing)

Add this to any page component temporarily:

```typescript
// In a React component
useEffect(() => {
  console.error('Test error for Spotlight MCP');
  throw new Error('Test error for Spotlight MCP integration');
}, []);
```

Or trigger an API error:

```typescript
// In an API route
export async function GET(request: Request) {
  throw new Error('API test error for Spotlight');
}
```

### Step 3: Query Spotlight from Claude Code

When running Claude Code in the `developer-skills-plugin` directory, Spotlight MCP will be automatically available.

**Example queries**:

```
"Debug the error I just triggered"
"Show me recent errors"
"What traces were captured in the last minute?"
"Search logs for authentication"
```

Claude will automatically:
1. Detect the debugging pattern
2. Query Spotlight for recent errors/logs/traces
3. Show actual runtime data
4. Suggest fixes based on real error context

---

## 🧪 Testing the Integration

### Test 1: Verify Spotlight MCP Package

```bash
npx -y --prefer-online @spotlightjs/spotlight@latest mcp --help
```

**Expected**: Help output showing MCP mode is available ✅ (Verified)

### Test 2: Verify VedereLMS Configuration

```bash
cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS
cat .env.local | grep SENTRY
```

**Expected**:
```
SENTRY_ENABLED=1
SENTRY_SPOTLIGHT=1
```

### Test 3: Start App and Capture an Error

1. Start the app: `npm run dev`
2. Verify Spotlight console output appears
3. Trigger a test error (see Step 2 above)
4. Open Spotlight UI: http://localhost:8969 (optional - for manual verification)

### Test 4: Query from Claude Code

Start Claude Code in the developer-skills-plugin directory:

```bash
cd /mnt/c/Users/Dominik/Documents/Skills/developer-skills-plugin
claude
```

Then ask: "Search for errors in Spotlight from the last 60 seconds"

Claude should use the `spotlight.errors.search` MCP tool automatically.

---

## 📊 MCP Tool Usage Examples

### Search for Errors

**User**: "Show me errors from the last 5 minutes"

**Claude executes**:
```
spotlight.errors.search({ filters: { timeWindow: 300 } })
```

**Returns**: Error list with stack traces, file locations, context

### Search Logs

**User**: "Search logs for authentication"

**Claude executes**:
```
spotlight.logs.search({ filters: { /* search params */ } })
```

**Returns**: Log entries matching criteria

### Get Trace Details

**User**: "Show me details for trace ID abc123"

**Claude executes**:
```
spotlight.traces.get({ traceId: "abc123" })
```

**Returns**: Complete span tree with timing breakdown

---

## 🔧 Troubleshooting

### Issue: "Spotlight not available"

**Symptom**: MCP tools don't appear or fail to connect

**Solutions**:
1. Verify VedereLMS is running: `cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS && npm run dev`
2. Check Spotlight console output: Should see "Sidecar running on http://localhost:8969"
3. Verify .mcp.json exists: `ls developer-skills-plugin/.mcp.json`
4. Restart Claude Code to reload MCP configuration

### Issue: "No errors captured"

**Symptom**: App is running but Spotlight doesn't capture errors

**Solutions**:
1. Verify SENTRY_ENABLED=1: `cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS && cat .env.local | grep SENTRY_ENABLED`
2. Check NODE_ENV is "development": `echo $NODE_ENV` (should be "development" or unset)
3. Verify Sentry.init() is called: Check sentry.client.config.ts line 3
4. Look for Spotlight console output when app starts
5. Open http://localhost:8969 to see Spotlight UI

### Issue: "Port 8969 already in use"

**Symptom**: Spotlight fails to start

**Solutions**:
1. Check what's using the port:
   ```bash
   lsof -i :8969  # Mac/Linux
   netstat -ano | findstr :8969  # Windows
   ```
2. Kill the process or change port in `.mcp.json`:
   ```json
   {
     "env": {
       "SPOTLIGHT_PORT": "8970"
     }
   }
   ```

### Issue: "MCP connection failed"

**Symptom**: Claude Code can't connect to Spotlight MCP

**Solutions**:
1. Restart Claude Code to reload MCP configuration
2. Verify .mcp.json syntax is valid: `cat developer-skills-plugin/.mcp.json | jq`
3. Test manual MCP connection: `npx -y @spotlightjs/spotlight@latest mcp`
4. Check logs in Claude Code output panel

---

## 🎓 How It Works

### Architecture

```
VedereLMS App (Next.js)
    ↓
Sentry SDK (@sentry/nextjs)
    ↓
Spotlight Sidecar (http://localhost:8969)
    ↓
Spotlight MCP Server
    ↓
Claude Code (via .mcp.json)
    ↓
AI-Assisted Debugging
```

### Data Flow

1. **Error occurs** in VedereLMS → Sentry SDK captures it
2. **Sentry SDK** sends telemetry to Spotlight Sidecar (localhost:8969)
3. **Spotlight Sidecar** stores errors/logs/traces in memory
4. **Claude Code** connects to Spotlight via MCP server
5. **Claude** queries Spotlight for debugging data via MCP tools
6. **User** gets AI-assisted debugging with real runtime context

### Privacy & Security

✅ **All data stays local**:
- Spotlight runs on localhost only
- No data sent to Sentry cloud (DSN is optional for local dev)
- MCP connection is local-only
- Only captures during development (disabled in production)

---

## 📝 Next Steps

1. **Start VedereLMS**: `cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS && npm run dev`
2. **Verify Spotlight**: Look for "Sidecar running on http://localhost:8969"
3. **Test error capture**: Trigger a test error in the app
4. **Use Claude Code**: Ask Claude to debug errors using Spotlight data
5. **Explore Spotlight UI**: Open http://localhost:8969 (optional)

---

## 📚 References

- **Spotlight Docs**: https://spotlightjs.com/docs/
- **Spotlight MCP Docs**: https://spotlightjs.com/docs/mcp/
- **Sentry SDK Docs**: https://docs.sentry.io/platforms/javascript/guides/nextjs/
- **Plugin Spotlight Setup**: `docs/SPOTLIGHT-SETUP.md`
- **Plugin Spotlight Usage**: `docs/SPOTLIGHT-USAGE.md`

---

## ✅ Verification Checklist

- [x] Spotlight MCP package accessible (v3.0.0)
- [x] `.mcp.json` created in plugin directory
- [x] `@sentry/nextjs` installed in VedereLMS
- [x] Sentry configs have `spotlight: true` for development
- [x] `SENTRY_ENABLED=1` in `.env.local`
- [x] `SENTRY_SPOTLIGHT=1` in `.env.local`
- [ ] VedereLMS app running with Spotlight sidecar active
- [ ] Test error triggered and captured
- [ ] Claude Code queried Spotlight successfully via MCP
- [ ] Verified error data appears in Claude's responses

**Status**: Ready to test! Start VedereLMS and ask Claude to search for errors.
