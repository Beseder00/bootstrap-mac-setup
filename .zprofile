# 🔵 .zprofile — Loaded once per login

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Node (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/bun" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Fix broken Deno references if they exist
[ -f "$HOME/.deno/envexport" ] || rm -f "$HOME/.deno/envexport"

# File watcher boost (better Next.js / Vite performance)
export CHOKIDAR_USEPOLLING=1
export WATCHPACK_POLLING=true

echo "🔵 .zprofile loaded"

