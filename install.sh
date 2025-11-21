#!/usr/bin/env bash
set -e

echo "🔵 Bootstrapping macOS AI Engineering Environment…"

# Ensure Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🍺 Running Brew Bundle…"
brew bundle install --file=./Brewfile

echo "📦 Copying .zprofile and .zshrc…"
cp .zprofile ~/.zprofile
cp .zshrc ~/.zshrc

echo "⚙️ Applying macOS system limits…"
chmod +x ./macos-limits.sh
sudo ./macos-limits.sh

echo "🔍 Verifying environment…"
chmod +x ./verify.sh
./verify.sh

echo "✅ Bootstrap complete. Open a new terminal to load everything."

