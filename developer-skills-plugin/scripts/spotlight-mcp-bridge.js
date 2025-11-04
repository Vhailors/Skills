#!/usr/bin/env node

/**
 * Spotlight MCP Bridge - INCOMPLETE (Template Only)
 *
 * This was an attempt to create a custom MCP bridge that fixes the broken
 * stdio implementation in @spotlightjs/spotlight by querying HTTP endpoints.
 *
 * STATUS: Cannot be completed - Spotlight doesn't expose HTTP REST API
 *
 * What works:
 * ✅ MCP stdio protocol implementation (responds to initialize)
 * ✅ Tool definitions for errors, logs, traces
 * ✅ JSON-RPC 2.0 request/response handling
 *
 * What's missing:
 * ❌ No HTTP endpoints to query (tested: /events, /api, /context all 404)
 * ❌ No REST API documented
 * ❌ Only internal memory access via broken official MCP
 *
 * Technical findings (Nov 2, 2025):
 * - Spotlight only exposes: /health (200) and /stream (SSE, undocumented)
 * - Events stored in memory, no external query interface
 * - Web UI uses internal JavaScript access, not HTTP
 * - Official MCP @spotlightjs/spotlight@4.4.0 stdio mode broken (timeout)
 *
 * Workaround:
 * Use Spotlight web UI at http://localhost:8969 manually.
 *
 * Future:
 * If Sentry adds HTTP REST API, this bridge can be completed.
 * Monitor: https://github.com/getsentry/spotlight/releases
 *
 * Usage (for testing MCP protocol):
 *   echo '{"jsonrpc":"2.0","id":1,"method":"initialize",...}' | node spotlight-mcp-bridge.js
 */

const http = require('http');
const readline = require('readline');

const SPOTLIGHT_URL = 'http://localhost:8969';
const MCP_VERSION = '2024-11-05';

// MCP protocol helper
function sendResponse(id, result) {
  const response = {
    jsonrpc: '2.0',
    id,
    result
  };
  console.log(JSON.stringify(response));
}

function sendError(id, code, message) {
  const response = {
    jsonrpc: '2.0',
    id,
    error: { code, message }
  };
  console.log(JSON.stringify(response));
}

// HTTP helper for Spotlight API
function fetchFromSpotlight(path) {
  return new Promise((resolve, reject) => {
    const url = `${SPOTLIGHT_URL}${path}`;

    http.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          try {
            resolve(JSON.parse(data));
          } catch (e) {
            resolve(data); // Return as string if not JSON
          }
        } else {
          reject(new Error(`HTTP ${res.statusCode}: ${data}`));
        }
      });
    }).on('error', reject);
  });
}

// Check if Spotlight is running
async function checkSpotlight() {
  try {
    await fetchFromSpotlight('/');
    return true;
  } catch (e) {
    return false;
  }
}

// MCP Tool: Search for errors
async function searchErrors(filters = {}) {
  const { timeWindow = 600, filename, limit = 50, offset = 0 } = filters;

  try {
    // Fetch from Spotlight's stream endpoint
    // Note: This is a simplified implementation.
    // Real implementation would need to understand Spotlight's actual API endpoints.
    const data = await fetchFromSpotlight('/stream');

    // Parse and filter errors
    // This is where you'd implement actual filtering based on Spotlight's data format

    return {
      errors: [],
      message: "Connected to Spotlight. Actual error data parsing needs Spotlight's API documentation."
    };
  } catch (error) {
    throw new Error(`Spotlight not available: ${error.message}. Start your app with Spotlight enabled.`);
  }
}

// MCP Tool: Search logs
async function searchLogs(filters = {}) {
  try {
    const data = await fetchFromSpotlight('/stream');
    return {
      logs: [],
      message: "Connected to Spotlight. Actual log data parsing needs Spotlight's API documentation."
    };
  } catch (error) {
    throw new Error(`Spotlight not available: ${error.message}`);
  }
}

// MCP Tool: Search traces
async function searchTraces(filters = {}) {
  try {
    const data = await fetchFromSpotlight('/stream');
    return {
      traces: [],
      message: "Connected to Spotlight. Actual trace data parsing needs Spotlight's API documentation."
    };
  } catch (error) {
    throw new Error(`Spotlight not available: ${error.message}`);
  }
}

// MCP Tool: Get trace details
async function getTrace(traceId) {
  try {
    const data = await fetchFromSpotlight(`/trace/${traceId}`);
    return {
      trace: null,
      message: "Connected to Spotlight. Actual trace retrieval needs Spotlight's API documentation."
    };
  } catch (error) {
    throw new Error(`Spotlight not available: ${error.message}`);
  }
}

// MCP request handler
async function handleRequest(request) {
  const { method, params, id } = request;

  try {
    switch (method) {
      case 'initialize':
        sendResponse(id, {
          protocolVersion: MCP_VERSION,
          serverInfo: {
            name: 'spotlight-mcp-bridge',
            version: '1.0.0'
          },
          capabilities: {
            tools: {}
          }
        });
        break;

      case 'initialized':
        // No response needed for notification
        break;

      case 'tools/list':
        sendResponse(id, {
          tools: [
            {
              name: 'spotlight_errors_search',
              description: 'Search for runtime errors captured by Spotlight',
              inputSchema: {
                type: 'object',
                properties: {
                  filters: {
                    type: 'object',
                    properties: {
                      timeWindow: { type: 'number', description: 'Seconds to look back (default: 600)' },
                      filename: { type: 'string', description: 'Filter by filename' },
                      limit: { type: 'number', description: 'Max results (default: 50)' },
                      offset: { type: 'number', description: 'Skip N results (default: 0)' }
                    }
                  }
                }
              }
            },
            {
              name: 'spotlight_logs_search',
              description: 'Search application logs captured by Spotlight',
              inputSchema: {
                type: 'object',
                properties: {
                  filters: {
                    type: 'object',
                    properties: {
                      timeWindow: { type: 'number' },
                      limit: { type: 'number' },
                      offset: { type: 'number' }
                    }
                  }
                }
              }
            },
            {
              name: 'spotlight_traces_search',
              description: 'List recent performance traces',
              inputSchema: {
                type: 'object',
                properties: {
                  filters: {
                    type: 'object',
                    properties: {
                      timeWindow: { type: 'number' },
                      limit: { type: 'number' }
                    }
                  }
                }
              }
            },
            {
              name: 'spotlight_traces_get',
              description: 'Get detailed span breakdown for a specific trace',
              inputSchema: {
                type: 'object',
                properties: {
                  traceId: { type: 'string', description: 'Trace ID (8 or 32 char hex)' }
                },
                required: ['traceId']
              }
            }
          ]
        });
        break;

      case 'tools/call':
        const { name, arguments: args } = params;
        let result;

        switch (name) {
          case 'spotlight_errors_search':
            result = await searchErrors(args.filters);
            break;
          case 'spotlight_logs_search':
            result = await searchLogs(args.filters);
            break;
          case 'spotlight_traces_search':
            result = await searchTraces(args.filters);
            break;
          case 'spotlight_traces_get':
            result = await getTrace(args.traceId);
            break;
          default:
            throw new Error(`Unknown tool: ${name}`);
        }

        sendResponse(id, {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2)
            }
          ]
        });
        break;

      default:
        sendError(id, -32601, `Method not found: ${method}`);
    }
  } catch (error) {
    sendError(id, -32603, error.message);
  }
}

// Main: Read JSON-RPC from stdin
async function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
  });

  // Log to stderr so it doesn't interfere with stdout JSON-RPC
  console.error('[Spotlight MCP Bridge] Starting...');

  // Check if Spotlight is reachable (non-blocking)
  checkSpotlight().then(available => {
    if (available) {
      console.error('[Spotlight MCP Bridge] ✅ Connected to Spotlight at localhost:8969');
    } else {
      console.error('[Spotlight MCP Bridge] ⚠️  Spotlight not running. Start your app with Spotlight enabled.');
    }
  });

  rl.on('line', async (line) => {
    try {
      const request = JSON.parse(line);
      await handleRequest(request);
    } catch (error) {
      console.error('[Spotlight MCP Bridge] Error:', error.message);
      sendError(null, -32700, 'Parse error');
    }
  });

  rl.on('close', () => {
    console.error('[Spotlight MCP Bridge] Shutting down');
    process.exit(0);
  });
}

main().catch(error => {
  console.error('[Spotlight MCP Bridge] Fatal error:', error);
  process.exit(1);
});
