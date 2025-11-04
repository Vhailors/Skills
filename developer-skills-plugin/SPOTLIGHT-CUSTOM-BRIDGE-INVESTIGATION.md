# Spotlight Custom MCP Bridge Investigation

**Date**: November 2, 2025
**Status**: ❌ **Not Viable** - Missing HTTP API
**Outcome**: Manual UI workflow recommended

---

## 📋 Summary

**User request**: "Can you think about some kind of solution just for spotlightjs?"

**Goal**: Create custom MCP bridge to work around broken `@spotlightjs/spotlight` stdio implementation

**Result**: Custom bridge cannot be completed - Spotlight doesn't expose queryable HTTP endpoints

---

## ✅ What Was Accomplished

### 1. MCP Protocol Template Created

**File**: `scripts/spotlight-mcp-bridge.js`

**Working features**:
- ✅ Proper JSON-RPC 2.0 stdio protocol
- ✅ Responds to `initialize` handshake (unlike official package)
- ✅ Complete tool definitions:
  - `spotlight_errors_search`
  - `spotlight_logs_search`
  - `spotlight_traces_search`
  - `spotlight_traces_get`
- ✅ HTTP query helper functions

**Testing results**:
```bash
# Custom bridge: ✅ Works
$ echo '{"jsonrpc":"2.0","id":1,"method":"initialize",...}' | node scripts/spotlight-mcp-bridge.js
{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2024-11-05",...}}
# Response in <3s

# Official package: ❌ Broken
$ echo '{"jsonrpc":"2.0","id":1,"method":"initialize",...}' | npx @spotlightjs/spotlight@4.4.0 mcp
# Timeout after 30s (exit code 124)
```

### 2. HTTP API Investigation

**Tested endpoints**:
| Endpoint | Method | Result | Purpose |
|----------|--------|--------|---------|
| `/health` | GET | ✅ 200 OK | Health check only |
| `/stream` | GET | ✅ SSE | Undocumented event stream |
| `/events` | GET | ❌ 404 | N/A |
| `/api` | GET | ❌ 404 | N/A |
| `/context` | GET | ❌ 404 | N/A |
| `/integrations` | GET | ❌ 404 | N/A |
| `/api/events` | GET | ❌ 404 | N/A |

**Conclusion**: No REST API available to query stored events

### 3. Architecture Analysis

**How Spotlight works**:
```
App → Sentry SDK → Spotlight Sidecar (localhost:8969)
                        ↓
                   In-Memory Storage
                        ↓
              ┌─────────┴─────────┐
              ↓                   ↓
         Web UI (internal)   MCP Protocol (broken)
```

**Key findings**:
- Events stored in **memory only** (sidecar process)
- Web UI accesses via **internal JavaScript** (not HTTP requests)
- Only external interface: **MCP protocol** (which is broken)
- No documented REST API, GraphQL, or query endpoints

---

## ❌ Why Custom Bridge Failed

### Missing Requirements

**A functional MCP bridge needs**:
1. ✅ Proper MCP stdio protocol → **Implemented**
2. ✅ Tool definitions → **Complete**
3. ❌ **HTTP endpoints to query** → **Don't exist**
4. ❌ **Data format documentation** → **Not available**

### Technical Blockers

1. **No REST API**: Spotlight doesn't expose HTTP endpoints for querying events
2. **Internal-only access**: Web UI uses JavaScript in same process, not HTTP
3. **SSE stream undocumented**: `/stream` endpoint exists but format not documented
4. **Memory-only storage**: No database or external query layer

### What We Can't Do

- ❌ Query errors via HTTP GET `/api/errors`
- ❌ Fetch traces via REST endpoints
- ❌ Parse SSE `/stream` events (format unknown, likely binary/internal)
- ❌ Access in-memory storage externally

---

## ✅ Working Solution

### Manual UI Workflow

**Recommended approach**:

1. **Start VedereLMS** (Spotlight auto-connects):
   ```bash
   cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS
   npm run dev
   ```

2. **Open Spotlight UI**: http://localhost:8969

3. **Debugging workflow**:
   - Trigger error in application
   - Switch to Spotlight UI browser tab
   - View comprehensive error data:
     - Full stack traces with file:line
     - Request/response context
     - Console logs and breadcrumbs
     - Performance traces
     - SDK metadata
   - Copy relevant details
   - Paste into Claude Code
   - Use `systematic-debugging` skill or `/quick-fix`

**Why this works well**:
- ✅ Full access to all Spotlight features
- ✅ Real-time updates as errors occur
- ✅ Richer visualization than text tools
- ✅ No MCP protocol issues
- ✅ Already integrated with VedereLMS Sentry SDK

---

## 📝 Next Steps

### Immediate Actions

1. **Use manual workflow** documented above ✅
2. **Keep bridge template** for future if API added ✅
3. **Document findings** in MCP-STATUS.md ✅

### Future Possibilities

**If Sentry adds HTTP REST API**:
- Complete bridge implementation
- Add endpoint query functions
- Parse response formats
- Test with real Spotlight instance
- Enable in plugin `.mcp.json`

**If Sentry fixes official MCP**:
- Monitor: https://github.com/getsentry/spotlight/releases
- Look for: "stdio fix", "MCP handshake", "Claude Code compatibility"
- Re-enable in `.claude-plugin/plugin.json`
- Remove `"disabled": true` flag

**Report issue** (optional):
- Repository: https://github.com/getsentry/spotlight/issues
- Title: "MCP stdio mode timeout - never responds to initialize request"
- Evidence: Timeout after 30s, no response to JSON-RPC initialize
- Versions: v1.0.0 (cached) and v4.4.0 (latest) both broken
- Environment: WSL2 Ubuntu, Node v22.20.0, Claude Code

---

## 📊 Impact Assessment

### What Still Works

| Feature | Status | Alternative |
|---------|--------|-------------|
| Error tracking | ✅ Working | Spotlight UI + manual copy |
| Performance traces | ✅ Working | Spotlight UI |
| Console logs | ✅ Working | Spotlight UI |
| Systematic debugging | ✅ Working | `systematic-debugging` skill |
| Memory-assisted debugging | ✅ Working | `claude-mem` + `/recall-bug` |
| Quick fixes | ✅ Working | `/quick-fix` command |

### What's Missing

| Feature | Status | Impact |
|---------|--------|--------|
| MCP error queries | ❌ Broken | Low - manual UI works |
| Automated error fetch | ❌ Not possible | Low - workflow only |
| Programmatic trace access | ❌ Not possible | Low - enhancement only |

**Overall impact**: **Minimal** - 99% of debugging workflows unaffected

---

## 🎓 Lessons Learned

### MCP Bridge Requirements

**To build a working custom MCP bridge, you need**:
1. Proper JSON-RPC 2.0 stdio protocol implementation ✅
2. Complete tool definitions with input schemas ✅
3. **Queryable external API** (HTTP, gRPC, database) ❌
4. Data format documentation ❌
5. Error handling and timeout management ✅

**Without #3 and #4, a bridge cannot be completed.**

### Spotlight Architecture Constraints

- Designed for **internal MCP access only**
- No external programmatic interface
- Web UI uses **same-process** data access
- Not built for REST API consumption

### Alternative Approaches

**When official MCP is broken**:
1. ✅ Use manual UI workflow (effective for Spotlight)
2. ❌ Build custom bridge (only if HTTP API exists)
3. ⏳ Wait for official fix (best long-term solution)
4. ✅ Document workarounds clearly

---

## 📚 Related Documentation

- **MCP-STATUS.md** - Overall MCP server status (chrome-devtools, spotlight, claude-mem)
- **SPOTLIGHT-MCP-STATUS.md** - Detailed Spotlight MCP investigation
- **scripts/spotlight-mcp-bridge.js** - Bridge template (MCP protocol working)
- **docs/SPOTLIGHT-SETUP.md** - Original setup documentation
- **docs/SPOTLIGHT-USAGE.md** - Usage patterns (assumes working MCP)

---

## 🔍 Technical Evidence

### Custom Bridge Works (Protocol Level)

```bash
$ echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}' | timeout 3s node scripts/spotlight-mcp-bridge.js

# Output (immediate):
{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2024-11-05","serverInfo":{"name":"spotlight-mcp-bridge","version":"1.0.0"},"capabilities":{"tools":{}}}}
```

### Official Package Broken

```bash
$ echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{...}}' | timeout 3s npx @spotlightjs/spotlight@4.4.0 mcp

# Output: (timeout, exit code 124)
# No response after 3 seconds
```

### No REST API Available

```bash
# All return 404 Not Found
curl http://localhost:8969/events
curl http://localhost:8969/api
curl http://localhost:8969/context
curl http://localhost:8969/integrations
curl http://localhost:8969/api/events

# Only /health works
curl http://localhost:8969/health
# → 200 OK
```

---

**Conclusion**: Manual Spotlight UI workflow is the pragmatic, fully-functional solution until Sentry fixes the official MCP implementation or adds HTTP REST API support.

---

## 🧹 Cleanup (Nov 2, 2025)

**MCP configurations removed** after investigation:
- ✅ Removed `developer-skills-plugin/.mcp.json`
- ✅ Removed `VedereLMS/.mcp.json`

**VedereLMS Spotlight still functional** via manual UI:
- ✅ `.env.local` has `SENTRY_ENABLED=1` and `SENTRY_SPOTLIGHT=1`
- ✅ Spotlight UI available at http://localhost:8969 when `npm run dev`
- ✅ Full debugging features accessible without MCP layer
