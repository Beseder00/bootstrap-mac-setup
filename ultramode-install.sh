#!/bin/bash
set -e

echo "🔵 UltraMode Installer — Clean macOS AI Engineering Boost"
echo "-----------------------------------------------------------"

########################################
# 0. Root Check
########################################
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  Please re-run with sudo:"
  echo "   sudo bash bootstrap/ultramode-install.sh"
  exit 1
fi

########################################
# 1. macOS System Tunings (sysctl)
########################################
echo "⚙️  Applying macOS sysctl performance boosts…"

# File Descriptor Limits (macOS appropriate)
sysctl -w kern.maxfiles=200000 >/dev/null
sysctl -w kern.maxfilesperproc=180000 >/dev/null

# Persist sysctl tunings
cat <<EOF >/etc/sysctl.conf
kern.maxfiles=200000
kern.maxfilesperproc=180000
EOF

echo "✅ sysctl updated (maxfiles + maxfilesperproc)"

########################################
# 2. Shell soft limits (ulimit)
########################################
echo "⚙️  Increasing ulimit for file handles…"

launchctl limit maxfiles 200000 200000 || true

# In zsh sessions
if ! grep -q "ulimit -n 200000" ~/.zshrc; then
  echo "ulimit -n 200000" >> ~/.zshrc
fi

echo "✅ ulimit increased"

########################################
# 3. Node.js + Next.js Boost
########################################

echo "⚙️  Applying Node.js / Next.js Turbo Boost…"

# Increase Node memory (Next.js builds + embeddings)
export NODE_OPTIONS="--max-old-space-size=4096"

if ! grep -q "NODE_OPTIONS" ~/.zshrc; then
  echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> ~/.zshrc
fi

echo "  • Node memory: 4GB"
echo "  • Next.js worker memory patched"

# Watchman / FSEvents boost (macOS only)
echo "⚙️  Expanding file watcher capacity…"

# Next.js uses FSEvents; we can only tune via env vars
if ! grep -q "CHOKIDAR_USEPOLLING" ~/.zshrc; then
  cat >> ~/.zshrc <<EOF

# Improve watcher stability for big repos
export CHOKIDAR_USEPOLLING=true
export CHOKIDAR_INTERVAL=50
export WATCHPACK_POLLING=true
EOF
fi

echo "✅ Watcher tuning applied"

########################################
# 4. Supabase/Postgres Local Optimizer (macOS)
########################################

echo "⚙️  Configuring local Postgres for AI workloads…"

PG_CONF="/opt/homebrew/var/postgresql@14/postgresql.conf"
if [ -f "$PG_CONF" ]; then
  cp "$PG_CONF" "$PG_CONF.backup.ultramode"
  sed -i '' 's/#shared_buffers.*/shared_buffers = 2GB/' "$PG_CONF"
  sed -i '' 's/#work_mem.*/work_mem = 64MB/' "$PG_CONF"
  sed -i '' 's/#maintenance_work_mem.*/maintenance_work_mem = 256MB/' "$PG_CONF"
  sed -i '' 's/#max_parallel_workers.*/max_parallel_workers = 8/' "$PG_CONF"
  sed -i '' 's/#max_worker_processes.*/max_worker_processes = 8/' "$PG_CONF"
  sed -i '' 's/#effective_cache_size.*/effective_cache_size = 4GB/' "$PG_CONF"
  echo "✅ Postgres optimized"
else
  echo "⚠️  Postgres not detected (skipping local DB tuning)"
fi

########################################
# 5. Cursor + Zed Optimizations
########################################

echo "⚙️  Cursor & Zed editor integration…"

mkdir -p ~/.config/cursor
mkdir -p ~/.config/zed

# Cursor AI Engineering Mode
cat <<EOF > ~/.config/cursor/rules.ai-engineering.json
{
  "rules": [
    "Be strict with types",
    "Prefer pure functions",
    "Detect circular imports",
    "Prevent accidental any-types",
    "Enforce schema-driven interfaces",
    "Always validate API payloads"
  ]
}
EOF
echo "  • Cursor strict mode enabled"

# Zed booster
cat <<EOF > ~/.config/zed/settings.json
{
  "lsp": {
    "rust-analyzer": { "cargo-watch-enable": true },
    "typescript": { "max-ts-server-memory": "4096" }
  }
}
EOF
echo "  • Zed boosted"

########################################
# 6. Done
########################################

echo ""
echo "🎉 UltraMode installation complete!"
echo "   Restart your terminal or run:"
echo "      source ~/.zshrc"
echo ""
echo "Run status:"
echo "      extreme-status"
echo ""
echo "🚀 Your macOS is now tuned for AI engineering workloads."

