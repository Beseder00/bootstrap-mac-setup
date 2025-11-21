#!/bin/bash
# Raycast UltraMode Dashboard
# GUI-friendly status and controls

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for Raycast
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

show_status() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  UltraMode Dashboard"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # File descriptors
  CURRENT_MAXFILES=$(sysctl -n kern.maxfiles 2>/dev/null || echo "0")
  CURRENT_ULIMIT=$(ulimit -n 2>/dev/null || echo "0")

  if (( CURRENT_MAXFILES >= 200000 )); then
    echo -e "${GREEN}✓${NC} File Descriptors: $CURRENT_MAXFILES (optimal)"
  else
    echo -e "${YELLOW}⚠${NC} File Descriptors: $CURRENT_MAXFILES (recommended: 200000+)"
  fi

  if (( CURRENT_ULIMIT >= 200000 )); then
    echo -e "${GREEN}✓${NC} ulimit -n: $CURRENT_ULIMIT (optimal)"
  else
    echo -e "${YELLOW}⚠${NC} ulimit -n: $CURRENT_ULIMIT (recommended: 200000+)"
  fi

  echo ""

  # Node.js
  if grep -q "NODE_OPTIONS.*max-old-space-size" "$HOME/.zshrc" 2>/dev/null; then
    NODE_MEM=$(grep "NODE_OPTIONS" "$HOME/.zshrc" | grep -oE "[0-9]+" | head -1)
    echo -e "${GREEN}✓${NC} Node.js Memory: ${NODE_MEM}MB"
  else
    echo -e "${YELLOW}⚠${NC} Node.js Memory: Not configured"
  fi

  # Watchers
  if grep -q "CHOKIDAR_USEPOLLING" "$HOME/.zshrc" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} File Watchers: Optimized"
  else
    echo -e "${YELLOW}⚠${NC} File Watchers: Not optimized"
  fi

  echo ""

  # Daemon status
  if launchctl list | grep -q "com.trendscoded.ultramode.daemon"; then
    echo -e "${GREEN}✓${NC} UltraMode Daemon: Running"
  else
    echo -e "${YELLOW}⚠${NC} UltraMode Daemon: Not installed"
  fi

  # Last daemon run
  if [[ -f "$HOME/.ultramode/daemon.log" ]]; then
    LAST_RUN=$(tail -1 "$HOME/.ultramode/daemon.log" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" | tail -1)
    echo -e "${BLUE}ℹ${NC} Last Daemon Run: ${LAST_RUN:-Unknown}"
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

reapply_now() {
  echo "🔄 Reapplying UltraMode settings..."
  "$SCRIPT_DIR/ultramode-daemon.sh"
  echo "✅ Settings reapplied"
}

install_daemon() {
  echo "📦 Installing UltraMode Daemon..."
  "$SCRIPT_DIR/install-daemon.sh"
}

uninstall_daemon() {
  echo "🗑️  Uninstalling UltraMode Daemon..."
  launchctl unload "$HOME/Library/LaunchAgents/com.trendscoded.ultramode.daemon.plist" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/com.trendscoded.ultramode.daemon.plist"
  echo "✅ Daemon uninstalled"
}

view_logs() {
  if [[ -f "$HOME/.ultramode/daemon.log" ]]; then
    echo "📋 UltraMode Daemon Logs:"
    echo ""
    tail -20 "$HOME/.ultramode/daemon.log"
  else
    echo "No logs found"
  fi
}

# Main menu
case "${1:-status}" in
  status)
    show_status
    ;;
  reapply)
    reapply_now
    ;;
  install-daemon)
    install_daemon
    ;;
  uninstall-daemon)
    uninstall_daemon
    ;;
  logs)
    view_logs
    ;;
  *)
    echo "Usage: $0 {status|reapply|install-daemon|uninstall-daemon|logs}"
    exit 1
    ;;
esac

