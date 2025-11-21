#!/usr/bin/env bash
set -euo pipefail

echo "🔵 Starting Extreme Mode Repair…"
echo "--------------------------------"

###########################################################################
# 0. SANITY CHECKS
###########################################################################

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script only supports macOS."
  exit 1
fi

if ! command -v zsh >/dev/null; then
  echo "❌ zsh required. Install via Homebrew:"
  echo "   brew install zsh"
  exit 1
fi

###########################################################################
# 1. FIX BROKEN DENO EXPORT (YOUR ORIGINAL ERROR)
###########################################################################

if [[ -f "$HOME/.deno/envexport" ]]; then
  echo "🧹 Removing broken Deno envexport file…"
  rm -f "$HOME/.deno/envexport"
else
  echo "✔ No broken Deno file found."
fi

###########################################################################
# 2. APPLY PERSISTENT MAXFILES USING launchd (SAFE FOR SIP)
###########################################################################

LAUNCHD_PLIST="/Library/LaunchDaemons/com.trendscoded.maxfiles.plist"
DESIRED_MAXFILES=200000

echo "🔧 Checking maxfiles…"

current_maxfiles="$(sysctl -n kern.maxfiles 2>/dev/null || echo 0)"

if (( current_maxfiles < DESIRED_MAXFILES )); then
  echo "⚠️  kern.maxfiles too low ($current_maxfiles). Installing launchd override…"

  sudo tee "$LAUNCHD_PLIST" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.trendscoded.maxfiles</string>

    <key>ProgramArguments</key>
    <array>
      <string>/usr/sbin/sysctl</string>
      <string>-w</string>
      <string>kern.maxfiles=${DESIRED_MAXFILES}</string>
      <string>kern.maxfilesperproc=180000</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

  echo "🔁 Loading launchd override…"
  sudo launchctl unload "$LAUNCHD_PLIST" 2>/dev/null || true
  sudo launchctl load "$LAUNCHD_PLIST"
else
  echo "✔ maxfiles already adequate ($current_maxfiles)"
fi

###########################################################################
# 3. PROCESS LIMIT FIX (ulimit -u)
###########################################################################

echo "🔧 Checking process limit…"

current_ulimit_u=$(ulimit -u || echo 0)

if (( current_ulimit_u < 4096 )); then
  echo "⚠️  process limit too low ($current_ulimit_u). Fixing in /etc/zshenv…"

  sudo bash -c 'echo "ulimit -u 4096" >> /etc/zshenv'
else
  echo "✔ process limit OK ($current_ulimit_u)"
fi

###########################################################################
# 4. NODE MEMORY + NEXT.JS WORKER MEMORY OPTIMIZATION
###########################################################################

ZSHRC="$HOME/.zshrc"

echo "🔧 Ensuring Node memory flags…"

ensure_line() {
  local file="$1"
  local line="$2"
  grep -qxF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

ensure_line "$ZSHRC" 'export NODE_OPTIONS="--max-old-space-size=8192"'
ensure_line "$ZSHRC" 'export NEXT_WORKER_MAX_MEMORY=4096'

###########################################################################
# 5. WATCHPACK + CHOKIDAR FIXES (Next.js / Turbopack)
###########################################################################

echo "🔧 Adding watcher optimizations…"

ensure_line "$ZSHRC" 'export WATCHPACK_POLLING=1'
ensure_line "$ZSHRC" 'export WATCHPACK_IGNORE="**/node_modules/**"'
ensure_line "$ZSHRC" 'export CHOKIDAR_USEPOLLING=true'
ensure_line "$ZSHRC" 'export CHOKIDAR_INTERVAL=100'

###########################################################################
# 6. CURSOR AI ENGINEERING MODE RULES
###########################################################################

CURSOR_RULES_DIR="$HOME/.cursor/rules"
mkdir -p "$CURSOR_RULES_DIR"

CURSOR_RULES_FILE="$CURSOR_RULES_DIR/ai-engineering.json"

echo "🧠 Installing Cursor AI Engineering Mode rules…"

cat > "$CURSOR_RULES_FILE" <<'EOF'
{
  "name": "AI Engineering Mode",
  "version": 1,
  "strict_boundaries": true,
  "require_full_file_context": true,
  "prefer_diff_patches": true,
  "enforce_schema_first": true,
  "disallow_fuzzy_prompts": true,
  "error_centric_debugging": true,
  "comment_before_code": true,
  "style": "production"
}
EOF

###########################################################################
# 7. ZED AI CONFIG
###########################################################################

ZED_DIR="$HOME/.config/zed"
mkdir -p "$ZED_DIR"

echo "🧠 Installing Zed config…"

cat > "$ZED_DIR/settings.json" <<'EOF'
{
  "assistant": {
    "model": "gpt-5",
    "enable_inline_completion": true
  },
  "lsp": {
    "workers": 4
  },
  "file_watcher": {
    "max_threads": 32
  }
}
EOF

###########################################################################
# 8. OPTIONAL INSTALLS: Raycast, Supabase, Postgres
###########################################################################

ask_install() {
  read -rp "Install $1? (y/N) " yn
  if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
    echo "📦 Installing $1…"
    brew install --cask "$2"
  else
    echo "⏭ Skipped $1"
  fi
}

# Raycast
ask_install "Raycast" "raycast"

# Supabase local
ask_install "Supabase CLI" "supabase"

# Postgres
ask_install "Postgres.app" "postgres-unofficial"

###########################################################################
# 9. RELOAD SHELL
###########################################################################

echo "🔄 Reloading shell configuration…"

source "$HOME/.zprofile" 2>/dev/null || true
source "$HOME/.zshrc" 2>/dev/null || true

echo
echo "✅ Extreme Mode Repair Complete!"
echo "Run 'extreme-status' to verify."

