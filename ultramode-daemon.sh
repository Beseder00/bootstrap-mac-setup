#!/bin/bash
# UltraMode Daemon - Auto-reapply weekly
# Runs every week to ensure settings persist

set -euo pipefail

LOG_FILE="$HOME/.ultramode/daemon.log"
mkdir -p "$HOME/.ultramode"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🔵 UltraMode Daemon: Weekly reapplication started"

# Reapply sysctl settings (non-destructive, only if needed)
CURRENT_MAXFILES=$(sysctl -n kern.maxfiles 2>/dev/null || echo "0")
DESIRED_MAXFILES=200000

if (( CURRENT_MAXFILES < DESIRED_MAXFILES )); then
  log "⚠️  maxfiles too low ($CURRENT_MAXFILES), reapplying..."
  sudo sysctl -w kern.maxfiles=200000 >/dev/null 2>&1 || log "❌ Failed to reapply maxfiles (may need manual sudo)"
  sudo sysctl -w kern.maxfilesperproc=180000 >/dev/null 2>&1 || log "❌ Failed to reapply maxfilesperproc"
else
  log "✅ maxfiles OK ($CURRENT_MAXFILES)"
fi

# Reapply ulimit (user-level, safe)
CURRENT_ULIMIT=$(ulimit -n 2>/dev/null || echo "0")
if (( CURRENT_ULIMIT < 200000 )); then
  launchctl limit maxfiles 200000 200000 2>/dev/null || true
  log "✅ ulimit reapplied"
else
  log "✅ ulimit OK ($CURRENT_ULIMIT)"
fi

# Verify .zshrc has required exports
if ! grep -q "NODE_OPTIONS.*max-old-space-size" "$HOME/.zshrc" 2>/dev/null; then
  log "⚠️  NODE_OPTIONS missing, adding..."
  echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> "$HOME/.zshrc"
fi

if ! grep -q "CHOKIDAR_USEPOLLING" "$HOME/.zshrc" 2>/dev/null; then
  log "⚠️  Watcher settings missing, adding..."
  cat >> "$HOME/.zshrc" <<EOF

# UltraMode watcher optimizations
export CHOKIDAR_USEPOLLING=true
export CHOKIDAR_INTERVAL=50
export WATCHPACK_POLLING=true
EOF
fi

log "✅ UltraMode Daemon: Weekly check complete"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

