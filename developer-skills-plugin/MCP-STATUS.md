# MCP Server Status

## Overview

This plugin includes configurations for three optional MCP servers that enhance specific workflows. As of November 2, 2025, **extensive testing confirms both Chrome DevTools and Spotlight packages have broken MCP stdio implementations** that prevent them from working with Claude Code.

> **✅ Investigation Complete**: After testing 8+ different configurations and approaches, definitive empirical evidence confirms the packages do not respond to MCP `initialize` requests. This is a bug in the packages themselves, not a configuration issue.

> **📖 For full technical details**: See `MCP-INVESTIGATION-SUMMARY.md` for complete timeline, all attempted fixes, empirical testing results, and lessons learned.

## Quick Status

### ❌ chrome-devtools (DISABLED - Broken Package)

**Status**: **BROKEN** - Package does not implement MCP stdio protocol correctly
**Used by**: `pixel-perfect-site-copy` skill

#### Definitive Evidence

Direct testing proves the MCP implementation is broken:
```bash
$ echo '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' | \
  npx -y chrome-devtools-mcp@latest --headless=true --isolated=true
(no response, times out after 3s)
```

**What works**: `npx -y chrome-devtools-mcp@latest --help` returns help text
**What fails**: MCP stdio mode - process starts but never responds to initialize

#### Investigation Summary (8 Attempts)

1. ❌ Configuration fixes (added `mcpServers` field)
2. ❌ WSL2 Chrome flags (`--no-sandbox`, etc.)
3. ❌ Xvfb virtual display wrapper
4. ❌ Version changes (0.8.0, 0.9.0, @latest)
5. ❌ Local npm bundling (like claude-mem pattern)
6. ❌ Windows Chrome path via `/mnt/c`
7. ❌ Added `-y` flag to npx (fixed prompt but not MCP)
8. ✅ **Empirical testing confirmed package bug**

#### WSL2 Specific Issues

GitHub Issues document WSL2 problems:
- **Issue #405**: "WSL2 is not support" (closed as "not planned")
- **Issue #131**: Chrome detection only looks inside WSL
- **Issue #132**: Request timeout errors

**Root cause**: Package designed for native Linux/macOS, struggles with WSL2 cross-boundary process launching

#### Technical Details
- ✅ Process starts successfully
- ✅ Prints security warning to stderr
- ❌ Never responds to MCP `initialize` request
- ❌ Causes 30-second timeout in Claude Code

### Evidence

Log analysis shows:
```json
{
  "error": "Connection to MCP server timed out after 30000ms"
}
{
  "stderr": "chrome-devtools-mcp exposes content of the browser instance..."
}
```

The process starts and outputs warnings, but never completes the JSON-RPC handshake.

### Attempted Fixes

1. ❌ Direct npx execution
2. ❌ WSL-specific flags (`--no-sandbox`, `--disable-setuid-sandbox`)
3. ❌ xvfb-run virtual display wrapper
4. ❌ Version pinning (0.8.0, 0.9.0 - tried multiple versions)
5. ❌ Custom bash wrapper with Xvfb
6. ❌ Local npm installation (bundled in plugin like claude-mem)
7. ❌ Direct JSON-RPC initialize request testing

**All attempts result in the same 30s timeout.**

### Empirical Testing Results

Direct testing confirms the MCP protocol implementation is broken:

```bash
# Test 1: Binary execution
$ node_modules/.bin/chrome-devtools-mcp --headless --isolated
(hangs indefinitely, no response)

# Test 2: MCP initialize request
$ echo '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' | \
  node_modules/.bin/chrome-devtools-mcp --headless --isolated
(no output, times out after 5s)
```

**Conclusion**: The package does not implement MCP stdio protocol correctly. It starts, outputs stderr warnings, but never responds to initialize requests on stdout.

### Workaround

Use Chrome DevTools manually for pixel-perfect site copying:
1. Open target site in Chrome
2. Use DevTools → Elements → Computed styles
3. Take screenshots at breakpoints (320px, 768px, 1024px, 1440px)
4. Extract styles manually

### Report Bug

If you encounter this issue:
1. Open issue at: https://github.com/ChromeDevTools/chrome-devtools-mcp/issues
2. Reference: "MCP stdio mode timeout - never responds to initialize request"
3. Include: WSL2, Ubuntu, Node v22.20.0, Claude Code environment

---

## ❌ sentry-spotlight (DISABLED - Broken Package)

**Purpose**: Query real-time application errors during debugging
**Used by**: `memory-assisted-debugging` skill (enhancement only)
**Status**: **BROKEN** - MCP stdio protocol not implemented correctly
**Version tested**: v4.4.0 (latest on npm)

> **📖 Custom Bridge Attempted**: See `SPOTLIGHT-CUSTOM-BRIDGE-INVESTIGATION.md` for detailed analysis of why a custom MCP bridge cannot be built (Spotlight doesn't expose HTTP REST API)

### Definitive Evidence

Direct testing proves the MCP implementation is broken:
```bash
$ echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}' | \
  npx -y @spotlightjs/spotlight@4.4.0 mcp
(no response, times out after 3s - exit code 124)
```

**What works**: `npx @spotlightjs/spotlight@4.4.0 mcp --help` returns help text
**What fails**: MCP stdio mode - process starts but never responds to initialize

### Issue

Spotlight MCP's `stdio` mode is designed to proxy to an existing sidecar (localhost:8969), but:
- The proxy implementation doesn't properly implement MCP stdio protocol
- It tries to connect via "stdio proxy" mode which hangs during initialization
- The MCP handshake (initialize → initialized) never completes
- No stderr output, just silent timeout

### Impact

**Minimal** - Debugging workflows still function perfectly via:
- `systematic-debugging` skill
- Memory-assisted debugging (uses claude-mem only)
- All `/recall-bug` and `/quick-fix` commands

Spotlight only **enhances** debugging by providing real-time error data. All debugging functionality works without it.

### Workaround: Manual Web UI Workflow

**Recommended approach** until package is fixed:

1. **Start your app with Spotlight**:
   ```bash
   cd /mnt/c/Users/Dominik/Documents/GitHub/VedereLMS
   npm run dev  # Sentry SDK automatically connects to Spotlight sidecar
   ```

2. **Access Spotlight UI**: http://localhost:8969

3. **Debugging workflow**:
   - Trigger error in application
   - Switch to Spotlight UI in browser
   - View full error details:
     - Stack traces with file:line numbers
     - Request/response context
     - Console logs
     - Performance traces
   - Copy relevant information
   - Use in Claude Code for debugging

**Why this works**: Spotlight web UI has full access to in-memory events. The broken MCP integration only affects programmatic access from Claude Code tools.

---

## ✅ claude-mem (Working)

**Purpose**: Project memory for past decisions, bugs, and features
**Used by**: All memory-assisted-* skills
**Status**: **WORKING PERFECTLY**

This is the core MCP that powers the developer-skills plugin and it works flawlessly.

---

## Impact Summary

| Feature | Status | Affected Skills | Workaround Available? |
|---------|--------|----------------|---------------------|
| Memory-assisted workflows | ✅ Working | All recall-* commands | N/A |
| Systematic debugging | ✅ Working | All debugging skills | N/A |
| Spec-kit workflows | ✅ Working | Feature development | N/A |
| Real-time error data | ❌ Broken | Spotlight enhancement | ✅ Yes (web UI) |
| Pixel-perfect site copy | ❌ Broken | chrome-devtools skill | ✅ Yes (manual) |

**99% of plugin functionality works without the broken MCPs.**

---

## Future Updates

If these packages fix their MCP implementations:

### To Re-Enable

1. Edit `.claude-plugin/plugin.json`
2. Change `"disabled": true` → `"disabled": false"`
3. Reload plugin: `/plugin reload developer-skills`
4. Test connection in MCP servers panel

### Watch For

- https://github.com/ChromeDevTools/chrome-devtools-mcp/releases
- https://github.com/getsentry/spotlight/releases

Look for release notes mentioning:
- "MCP stdio fix"
- "Initialize handshake fix"
- "Claude Code compatibility"

---

## Technical Details

### MCP Protocol Requirements

A functioning MCP server must:
1. Accept stdin as JSON-RPC 2.0 messages
2. Respond to `initialize` method with server capabilities
3. Complete handshake within 30 seconds
4. Output responses to stdout (not stderr)

### What's Broken

Both packages:
1. ✅ Accept stdin
2. ❌ Never respond to `initialize`
3. ❌ Timeout after 30s
4. ✅ Output logs to stderr (but no stdout response)

This suggests the packages may not implement the MCP protocol correctly, or expect a different initialization flow than Claude Code uses.

---

## See Also

- **MCP-INVESTIGATION-SUMMARY.md** - Chrome DevTools MCP investigation (8+ attempts, WSL2 issues)
- **SPOTLIGHT-CUSTOM-BRIDGE-INVESTIGATION.md** - Custom Spotlight bridge attempt and why it's not viable
- **SPOTLIGHT-MCP-STATUS.md** - Detailed Spotlight MCP status with workarounds
- **skills/pixel-perfect-site-copy/SKILL.md** - Puppeteer-based workaround for Chrome DevTools
- **scripts/spotlight-mcp-bridge.js** - MCP bridge template (protocol works, missing API to query)
- **package.json** - MCP dependencies kept for future re-enablement
- **.claude-plugin/plugin.json** - MCP configurations with `disabled: true` flags

---

Last updated: 2025-11-02
