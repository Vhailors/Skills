# Spotlight MCP Integration Setup Guide

## Overview

Spotlight is a local development debugging tool by Sentry that captures real-time telemetry (errors, traces, logs) from your application. This plugin integrates Spotlight via MCP (Model Context Protocol) to provide AI-assisted debugging with actual runtime error data.

## Prerequisites

### 1. Node.js and NPM

Spotlight requires Node.js to run:

```bash
node --version  # Should be v16+
npm --version
```

### 2. Sentry SDK in Your Application

Your application needs a Sentry SDK installed (free, open-source):

**JavaScript/TypeScript:**
```bash
npm install @sentry/node @sentry/browser
# or
npm install @sentry/nextjs  # For Next.js
npm install @sentry/react    # For React
```

**Python:**
```bash
pip install sentry-sdk
```

**Other Languages:**
See [Sentry SDK docs](https://docs.sentry.io/platforms/) for your platform.

## Installation Steps

### Step 1: Verify Plugin Configuration

The developer-skills plugin should already have `.mcp.json` configured:

```bash
cat developer-skills-plugin/.mcp.json
```

You should see:
```json
{
  "mcpServers": {
    "sentry-spotlight": {
      "command": "npx",
      "args": ["-y", "--prefer-online", "@spotlightjs/spotlight@latest", "mcp"],
      "env": {
        "SPOTLIGHT_PORT": "8969",
        "NODE_ENV": "development"
      }
    }
  }
}
```

**Important**: Use `mcp` argument (NOT `--stdio-mcp`) as per Spotlight v3.0+ documentation.

✅ If this exists, the MCP server is configured.

### Step 2: Enable Spotlight in Your Application

Add Spotlight initialization to your app's entry point:

**JavaScript/Node.js:**
```javascript
// At the top of your main file (e.g., index.js, app.js)
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: 'https://example@sentry.io/123', // Optional for local dev
  environment: 'development',
  // Enable Spotlight for local development
  spotlight: process.env.NODE_ENV === 'development',
});
```

**Next.js:**
```javascript
// In sentry.client.config.js or sentry.server.config.js
export function register() {
  Sentry.init({
    dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
    spotlight: process.env.NODE_ENV === 'development',
  });
}
```

**Python/Flask:**
```python
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration

sentry_sdk.init(
    dsn="https://example@sentry.io/123",  # Optional for local dev
    integrations=[FlaskIntegration()],
    environment="development",
    spotlight=True  # Enable Spotlight
)
```

### Step 3: Set Environment Variable

Enable Spotlight with an environment variable:

**Option A: In your start script (package.json):**
```json
{
  "scripts": {
    "dev": "SENTRY_SPOTLIGHT=1 next dev",
    "dev:spotlight": "SENTRY_SPOTLIGHT=1 npm start"
  }
}
```

**Option B: In .env file:**
```bash
# .env.local or .env.development
SENTRY_SPOTLIGHT=1
NODE_ENV=development
```

**Option C: In terminal:**
```bash
export SENTRY_SPOTLIGHT=1
npm run dev
```

### Step 4: Start Your Application

Run your application with Spotlight enabled:

```bash
npm run dev
# or
SENTRY_SPOTLIGHT=1 npm start
```

You should see Spotlight console output:
```
🔎 [Spotlight] Spotlight by Sentry
🔎 [Spotlight] Sidecar running on http://localhost:8969
```

### Step 5: Verify MCP Connection

Check that Claude Code can connect to Spotlight:

**Option A: Check plugin status:**
```bash
bash developer-skills-plugin/hooks/scripts/spotlight-query.sh status
```

Expected output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔎 Spotlight MCP Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ .mcp.json configuration exists
✓ Spotlight MCP server configured
✓ npx available
✓ @spotlightjs/spotlight package accessible
```

**Option B: Trigger an error in your app:**

Add a test error:
```javascript
// In your app code
console.error('Test error for Spotlight');
throw new Error('Test error for Spotlight integration');
```

Then ask Claude Code: "Debug the error I just triggered"

Claude should automatically:
1. Detect debugging pattern
2. Query Spotlight for recent errors
3. Show you the actual error details
4. Search memory for similar issues

## Verification Checklist

- [ ] Sentry SDK installed in your application
- [ ] Spotlight enabled in Sentry.init()
- [ ] SENTRY_SPOTLIGHT=1 environment variable set
- [ ] Application running in development mode
- [ ] Spotlight sidecar running on port 8969
- [ ] `.mcp.json` exists in plugin directory
- [ ] `spotlight-query.sh status` shows all green checks
- [ ] Test error is captured and visible to Claude

## Troubleshooting

### Issue: "Spotlight not available"

**Symptom:** spotlight-query.sh status shows errors

**Solutions:**
1. Check Node.js is installed: `node --version`
2. Verify npx works: `npx --version`
3. Test Spotlight package: `npx -y @spotlightjs/spotlight@latest --help`
4. Check .mcp.json exists: `ls developer-skills-plugin/.mcp.json`

### Issue: "No errors captured"

**Symptom:** App is running but Spotlight doesn't capture errors

**Solutions:**
1. Verify SENTRY_SPOTLIGHT=1 is set: `echo $SENTRY_SPOTLIGHT`
2. Check Sentry SDK is initialized (see Step 2)
3. Ensure `spotlight: true` in Sentry.init()
4. Look for Spotlight console output when app starts
5. Check Spotlight sidecar is running: `curl http://localhost:8969`

### Issue: "Port 8969 already in use"

**Symptom:** Spotlight fails to start

**Solutions:**
1. Check what's using the port: `lsof -i :8969` (Mac/Linux) or `netstat -ano | findstr :8969` (Windows)
2. Kill the process or change the port in `.mcp.json`:
   ```json
   {
     "env": {
       "SPOTLIGHT_PORT": "8970"  // Use different port
     }
   }
   ```

### Issue: "MCP connection failed"

**Symptom:** Claude Code can't connect to Spotlight MCP

**Solutions:**
1. Restart Claude Code to reload MCP configuration
2. Check `.mcp.json` syntax is valid: `cat .mcp.json | jq`
3. Verify plugin is loaded: Check plugin settings in Claude Code
4. Try manual MCP test: `npx -y @spotlightjs/spotlight@latest mcp`

### Issue: "Spotlight works but Claude doesn't query it"

**Symptom:** Spotlight captures errors but Claude doesn't mention them

**Solutions:**
1. Use explicit debugging triggers: "Debug this error", "Fix this bug"
2. Check hook is active: Debugging superflow should show "🔎 SPOTLIGHT INTEGRATION ACTIVE"
3. Verify hooks are enabled in Claude Code settings
4. Check hook script exists: `ls -l developer-skills-plugin/hooks/scripts/spotlight-query.sh`

## Advanced Configuration

### Custom Port

To use a different port:

1. Update `.mcp.json`:
   ```json
   {
     "env": {
       "SPOTLIGHT_PORT": "3030"
     }
   }
   ```

2. Update your app if needed:
   ```javascript
   Sentry.init({
     spotlight: process.env.NODE_ENV === 'development'
       ? { sidecarUrl: 'http://localhost:3030' }
       : false,
   });
   ```

### Multiple Projects

If you have multiple projects, you can:

**Option A: Share one Spotlight instance (recommended):**
- Use default port 8969 across all projects
- All apps send to same Spotlight sidecar

**Option B: Use different ports per project:**
- Project A: port 8969
- Project B: port 8970
- Update `.mcp.json` per project

### Docker/Remote Development

If running in Docker:

```yaml
# docker-compose.yml
services:
  app:
    environment:
      - SENTRY_SPOTLIGHT=1
    ports:
      - "8969:8969"  # Expose Spotlight port
```

Update `.mcp.json` for remote connection:
```json
{
  "mcpServers": {
    "sentry-spotlight": {
      "url": "http://localhost:8969/mcp",  // HTTP instead of stdio
      "type": "http"
    }
  }
}
```

## Privacy & Security

**Important:** Spotlight runs entirely on your local machine.

✅ **Safe:**
- All data stays on localhost
- No data sent to Sentry cloud (unless you configure DSN)
- Only captures errors during development
- MCP connection is local-only

⚠️ **Be Aware:**
- Error data may contain user info (request data, auth tokens)
- Don't commit errors to version control
- Disable Spotlight in production (it's development-only by design)

## Performance Impact

**Runtime overhead:** Minimal (~1-2ms per error)
**Memory usage:** ~20-50MB for Spotlight sidecar
**Network impact:** None (local-only)

Spotlight is designed for development and has negligible impact on dev performance.

## Next Steps

Once setup is complete:

1. Read [SPOTLIGHT-USAGE.md](./SPOTLIGHT-USAGE.md) for workflow integration
2. Try the debugging workflow: Report a bug and watch Claude query Spotlight
3. Run tests and see post-test error detection
4. Review the [Spotlight docs](https://spotlightjs.com/docs/) for advanced features

## Getting Help

**Plugin Issues:**
- Check [TROUBLESHOOTING.md](../hooks/TROUBLESHOOTING.md)
- Review hook logs in Claude Code output
- File issue in developer-skills plugin repo

**Spotlight Issues:**
- Official docs: https://spotlightjs.com/docs/
- GitHub: https://github.com/getsentry/spotlight
- Discord: https://discord.gg/sentry

**Sentry SDK Issues:**
- SDK docs: https://docs.sentry.io/platforms/
- GitHub: https://github.com/getsentry/sentry-javascript (or your platform)
