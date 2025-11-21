#!/bin/bash
# Install Auto-heal on macOS updates

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOHEAL_SCRIPT="$SCRIPT_DIR/auto-heal-on-update.sh"
PLIST_FILE="$SCRIPT_DIR/com.trendscoded.ultramode.autoheal.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
INSTALLED_PLIST="$LAUNCH_AGENTS_DIR/com.trendscoded.ultramode.autoheal.plist"

echo "🔵 Installing UltraMode Auto-heal..."

# Create plist with actual script path
cat > "$INSTALLED_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.trendscoded.ultramode.autoheal</string>

  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$AUTOHEAL_SCRIPT</string>
  </array>

  <key>StartInterval</key>
  <integer>3600</integer>

  <key>RunAtLoad</key>
  <true/>

  <key>StandardOutPath</key>
  <string>$HOME/.ultramode/auto-heal.log</string>

  <key>StandardErrorPath</key>
  <string>$HOME/.ultramode/auto-heal.error.log</string>
</dict>
</plist>
EOF

# Make script executable
chmod +x "$AUTOHEAL_SCRIPT"

# Load the agent
launchctl unload "$INSTALLED_PLIST" 2>/dev/null || true
launchctl load "$INSTALLED_PLIST"

echo "✅ UltraMode Auto-heal installed"
echo "   Checks every hour for macOS updates"
echo "   Logs: ~/.ultramode/auto-heal.log"
echo ""
echo "To uninstall: launchctl unload $INSTALLED_PLIST"

