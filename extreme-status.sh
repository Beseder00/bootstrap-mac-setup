#!/usr/bin/env bash
# Extreme Mode Status Dashboard
# Shows current system limits and optimizations

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Extreme Mode Status Dashboard"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# File descriptor limits
echo -e "${BLUE}📁 File Descriptor Limits:${NC}"
current_maxfiles=$(sysctl -n kern.maxfiles 2>/dev/null || echo "unknown")
current_maxfilesperproc=$(sysctl -n kern.maxfilesperproc 2>/dev/null || echo "unknown")
current_ulimit_n=$(ulimit -n 2>/dev/null || echo "unknown")

if (( current_maxfiles >= 200000 )); then
  echo -e "  ${GREEN}✓${NC} kern.maxfiles: $current_maxfiles (optimal)"
else
  echo -e "  ${YELLOW}⚠${NC} kern.maxfiles: $current_maxfiles (recommended: 200000+)"
fi

if (( current_maxfilesperproc >= 180000 )); then
  echo -e "  ${GREEN}✓${NC} kern.maxfilesperproc: $current_maxfilesperproc (optimal)"
else
  echo -e "  ${YELLOW}⚠${NC} kern.maxfilesperproc: $current_maxfilesperproc (recommended: 180000+)"
fi

if [[ "$current_ulimit_n" != "unknown" ]] && (( current_ulimit_n >= 65536 )); then
  echo -e "  ${GREEN}✓${NC} ulimit -n: $current_ulimit_n (optimal)"
else
  echo -e "  ${YELLOW}⚠${NC} ulimit -n: $current_ulimit_n (recommended: 65536+)"
fi

# Process limits
echo ""
echo -e "${BLUE}⚙️  Process Limits:${NC}"
current_ulimit_u=$(ulimit -u 2>/dev/null || echo "unknown")
if [[ "$current_ulimit_u" != "unknown" ]] && (( current_ulimit_u >= 4096 )); then
  echo -e "  ${GREEN}✓${NC} ulimit -u: $current_ulimit_u (optimal)"
else
  echo -e "  ${YELLOW}⚠${NC} ulimit -u: $current_ulimit_u (recommended: 4096+)"
fi

# LaunchDaemon status
echo ""
echo -e "${BLUE}🔧 System Services:${NC}"
if [[ -f "/Library/LaunchDaemons/com.trendscoded.maxfiles.plist" ]]; then
  if launchctl list | grep -q "com.trendscoded.maxfiles"; then
    echo -e "  ${GREEN}✓${NC} maxfiles LaunchDaemon: loaded"
  else
    echo -e "  ${YELLOW}⚠${NC} maxfiles LaunchDaemon: exists but not loaded"
  fi
else
  echo -e "  ${RED}✗${NC} maxfiles LaunchDaemon: not installed"
fi

# Environment variables
echo ""
echo -e "${BLUE}🌍 Environment Variables:${NC}"
if grep -q "NODE_OPTIONS.*max-old-space-size" "$HOME/.zshrc" 2>/dev/null; then
  echo -e "  ${GREEN}✓${NC} NODE_OPTIONS configured"
else
  echo -e "  ${YELLOW}⚠${NC} NODE_OPTIONS not configured"
fi

if grep -q "WATCHPACK_POLLING" "$HOME/.zshrc" 2>/dev/null; then
  echo -e "  ${GREEN}✓${NC} WATCHPACK optimizations enabled"
else
  echo -e "  ${YELLOW}⚠${NC} WATCHPACK optimizations not configured"
fi

if grep -q "CHOKIDAR_USEPOLLING" "$HOME/.zshrc" 2>/dev/null; then
  echo -e "  ${GREEN}✓${NC} CHOKIDAR optimizations enabled"
else
  echo -e "  ${YELLOW}⚠${NC} CHOKIDAR optimizations not configured"
fi

# AI Editor configs
echo ""
echo -e "${BLUE}🧠 AI Editor Configurations:${NC}"
if [[ -f "$HOME/.cursor/rules/ai-engineering.json" ]]; then
  echo -e "  ${GREEN}✓${NC} Cursor AI Engineering Mode: configured"
else
  echo -e "  ${YELLOW}⚠${NC} Cursor AI Engineering Mode: not configured"
fi

if [[ -f "$HOME/.config/zed/settings.json" ]]; then
  echo -e "  ${GREEN}✓${NC} Zed AI config: configured"
else
  echo -e "  ${YELLOW}⚠${NC} Zed AI config: not configured"
fi

# Deno fix
echo ""
echo -e "${BLUE}🧹 Cleanup:${NC}"
if [[ -f "$HOME/.deno/envexport" ]]; then
  echo -e "  ${RED}✗${NC} Broken Deno file still exists"
else
  echo -e "  ${GREEN}✓${NC} No broken Deno files found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

