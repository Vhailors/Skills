# Spotlight MCP Status

**Date**: November 2, 2025
**Status**: ❌ **NOT WORKING** - Known Issue

---

## 🐛 Issue Summary

Spotlight MCP v4.4.0 has a **broken stdio implementation** that does not respond to MCP initialize requests.

### Evidence

1. **Timeout with no response**:
   ```bash
   echo '{"jsonrpc":"2.0","id":1,"method":"initialize",...}' | npx @spotlightjs/spotlight@4.4.0 mcp
   # Result: Timeout (exit code 124) - no JSON-RPC response
   ```

2. **Connection logs**:
   ```
   Starting connection with timeout of 30000ms
   Connection timeout triggered after 30010ms
   Connection failed: timed out after 30000ms
   ```

3. **No stderr output**: Process starts but never responds to MCP protocol messages

### Root Cause

Spotlight MCP's `stdio` mode is designed to **proxy to an existing sidecar** (localhost:8969), but:
- The proxy implementation doesn't properly implement MCP stdio protocol
- It tries to connect via "stdio proxy" mode which hangs during initialization
- The MCP handshake (initialize → initialized) never completes

### Attempted Solutions

| Approach | Config | Result |
|----------|--------|--------|
| stdio + env vars | `SPOTLIGHT_PORT=8969` | Timeout (proxy mode) |
| stdio without env | No env vars | Timeout (no response) |
| SSE transport | `http://localhost:8969/mcp` | Error: "Only one SSE stream allowed" |
| HTTP transport | Not supported | N/A |

---

## ❌ MCP Configuration Removed

**All MCP configurations removed** (Nov 2, 2025) after confirming broken:

- ~~`developer-skills-plugin/.mcp.json`~~ - Removed
- ~~`VedereLMS/.mcp.json`~~ - Removed

**Reason**: stdio implementation doesn't respond to initialize requests - not fixable via configuration

---

## 📋 Known Limitations

1. **stdio protocol broken**: Never responds to MCP initialize handshake
2. **No REST API**: Cannot build custom bridge to query events
3. **SSE conflicts**: SSE transport gives "one stream per session" error
4. **All versions affected**: v1.0.0 (cached) and v4.4.0 (latest) both broken
5. **Configuration doesn't help**: Issue is in package implementation, not config

---

## 🔧 Recommended Approach

**Use Spotlight UI directly** - fully functional alternative:

1. **Start VedereLMS with Spotlight**:
   ```bash
   cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS
   npm run dev
   # Spotlight auto-starts on http://localhost:8969
   ```

2. **Open Spotlight UI**: http://localhost:8969

   **Note**: VedereLMS has `SENTRY_ENABLED=1` and `SENTRY_SPOTLIGHT=1` in `.env.local` ✅
3. **Integrated debugging workflow**:
   - Trigger error in your application
   - Switch to Spotlight UI tab in browser
   - View comprehensive error details:
     - Full stack traces with file:line
     - Request/response context
     - Console logs and breadcrumbs
     - Performance traces
   - Copy error details
   - Paste into Claude Code for debugging assistance

**Why this is effective**:
- ✅ Full access to all Spotlight data
- ✅ Real-time updates as errors occur
- ✅ No MCP protocol issues
- ✅ Richer visualization than text-based tools
- ✅ Already integrated with VedereLMS Sentry SDK

This manual workflow provides the same debugging benefits without the broken MCP layer.

---

## 🔍 Custom Bridge Investigation

**Question**: Can we build a custom MCP bridge that queries Spotlight's HTTP API?

**Answer**: ❌ **Not viable** - Spotlight doesn't expose HTTP REST endpoints

### Technical Analysis

**Tested endpoints** (all return 404):
```bash
curl http://localhost:8969/events      # 404
curl http://localhost:8969/api         # 404
curl http://localhost:8969/context     # 404
curl http://localhost:8969/integrations # 404
```

**Only available endpoints**:
- `/health` → 200 OK (health check only)
- `/stream` → SSE stream (undocumented format, internal use)

**Architecture findings**:
- Spotlight stores events **in memory** (sidecar process)
- Web UI accesses data via **internal JavaScript** (not HTTP)
- Only programmatic interface: **MCP protocol** (which is broken)
- No REST API, GraphQL, or queryable endpoints

**Custom bridge status**: Template created at `scripts/spotlight-mcp-bridge.js` but cannot be completed without API to query.

---

## 📝 Future Resolution

**Possible fixes**:

1. **Report stdio bug to Sentry**: https://github.com/getsentry/spotlight/issues
   - Broken MCP initialize handshake
   - Timeout after 30s with no response
   - Both v1.0.0 and v4.4.0 affected

2. **Wait for official fix**: Monitor Spotlight releases for MCP stdio improvements

3. **Alternative if Sentry adds HTTP API**: Complete custom bridge to query REST endpoints

4. **Long-term**: Consider alternative local debugging tools with working MCP support

**Current status**:
- ✅ Manual UI workflow fully functional
- ❌ MCP integration disabled
- ⏳ Awaiting Sentry package fix

---

## 📚 Related Documentation

- **SPOTLIGHT-CUSTOM-BRIDGE-INVESTIGATION.md** - Complete analysis of custom bridge attempt ⭐
- **MCP-STATUS.md** - Overall MCP server status (chrome-devtools, spotlight, claude-mem)
- **scripts/spotlight-mcp-bridge.js** - MCP bridge template (working protocol, missing API)
- **SPOTLIGHT-MCP-SETUP-COMPLETE.md** - Original setup attempt
- **docs/SPOTLIGHT-SETUP.md** - General Spotlight setup
- **docs/SPOTLIGHT-USAGE.md** - Usage patterns (assumes working MCP)

---

**Conclusion**: Spotlight MCP integration is **currently not viable** for the developer-skills plugin.

**Working solution**: Use Spotlight UI at http://localhost:8969 manually - provides full debugging functionality without MCP layer.
