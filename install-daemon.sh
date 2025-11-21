#!/bin/bash
# Install UltraMode Daemon (weekly auto-reapply)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SCRIPT="$SCRIPT_DIR/ultramode-daemon.sh"
PLIST_FILE="$SCRIPT_DIR/com.trendscoded.ultramode.daemon.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
INSTALLED_PLIST="$LAUNCH_AGENTS_DIR/com.trendscoded.ultramode.daemon.plist"

echo "🔵 Installing UltraMode Daemon..."

# Create plist with actual script path
cat > "$INSTALLED_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.trendscoded.ultramode.daemon</string>

  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$DAEMON_SCRIPT</string>
  </array>

  <key>StartCalendarInterval</key>
  <dict>
    <key>Weekday</key>
    <integer>1</integer>
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>

  <key>RunAtLoad</key>
  <true/>

  <key>StandardOutPath</key>
  <string>$HOME/.ultramode/daemon.log</string>

  <key>StandardErrorPath</key>
  <string>$HOME/.ultramode/daemon.error.log</string>
</dict>
</plist>
EOF

# Make daemon script executable
chmod +x "$DAEMON_SCRIPT"

# Load the daemon
launchctl unload "$INSTALLED_PLIST" 2>/dev/null || true
launchctl load "$INSTALLED_PLIST"

echo "✅ UltraMode Daemon installed"
echo "   Runs every Monday at 9:00 AM"
echo "   Logs: ~/.ultramode/daemon.log"
echo ""
echo "To uninstall: launchctl unload $INSTALLED_PLIST"

