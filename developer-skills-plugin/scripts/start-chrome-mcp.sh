#!/bin/bash
# Chrome DevTools MCP wrapper for WSL2

export CHROME_PATH=/usr/bin/google-chrome
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export DISPLAY=:99

# Start Xvfb in background if not running
if ! pgrep -x Xvfb > /dev/null; then
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 1
fi

# Run chrome-devtools-mcp
exec npx -y chrome-devtools-mcp@0.8.0 \
    --headless \
    --isolated \
    --chromeArg=--no-sandbox \
    --chromeArg=--disable-setuid-sandbox \
    --chromeArg=--disable-dev-shm-usage \
    "$@"
