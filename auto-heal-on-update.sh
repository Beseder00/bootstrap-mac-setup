#!/bin/bash
# Auto-heal on macOS updates
# Detects macOS system updates and reapplies UltraMode settings

set -euo pipefail

LOG_FILE="$HOME/.ultramode/auto-heal.log"
mkdir -p "$HOME/.ultramode"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Track last known macOS version
VERSION_FILE="$HOME/.ultramode/last-macos-version"
CURRENT_VERSION=$(sw_vers -productVersion)

# Check if macOS version changed
if [[ -f "$VERSION_FILE" ]]; then
  LAST_VERSION=$(cat "$VERSION_FILE")

  if [[ "$CURRENT_VERSION" != "$LAST_VERSION" ]]; then
    log "🔵 macOS version changed: $LAST_VERSION → $CURRENT_VERSION"
    log "🔄 Auto-healing UltraMode settings..."

    # Reapply sysctl (requires sudo, but we'll try)
    CURRENT_MAXFILES=$(sysctl -n kern.maxfiles 2>/dev/null || echo "0")
    if (( CURRENT_MAXFILES < 200000 )); then
      log "⚠️  maxfiles reset to $CURRENT_MAXFILES after update"
      log "   Run 'sudo bash ultramode-install.sh' to fix"
    fi

    # Reapply ulimit (user-level, always safe)
    launchctl limit maxfiles 200000 200000 2>/dev/null || true

    # Verify .zshrc settings
    if ! grep -q "NODE_OPTIONS.*max-old-space-size" "$HOME/.zshrc" 2>/dev/null; then
      log "⚠️  NODE_OPTIONS missing, restoring..."
      echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> "$HOME/.zshrc"
    fi

    if ! grep -q "CHOKIDAR_USEPOLLING" "$HOME/.zshrc" 2>/dev/null; then
      log "⚠️  Watcher settings missing, restoring..."
      cat >> "$HOME/.zshrc" <<EOF

# UltraMode watcher optimizations
export CHOKIDAR_USEPOLLING=true
export CHOKIDAR_INTERVAL=50
export WATCHPACK_POLLING=true
EOF
    fi

    log "✅ Auto-heal complete"
  else
    log "✅ macOS version unchanged ($CURRENT_VERSION)"
  fi
else
  log "📝 First run - recording macOS version: $CURRENT_VERSION"
fi

# Save current version
echo "$CURRENT_VERSION" > "$VERSION_FILE"

