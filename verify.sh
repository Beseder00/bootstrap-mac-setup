#!/usr/bin/env bash
echo "🔍 Verifying core tools…"

for tool in git brew node pnpm bun deno fzf rg fd bat; do
  if command -v $tool >/dev/null 2>&1; then
    echo "✅ $tool detected"
  else
    echo "❌ $tool missing"
  fi
done

echo "📦 Verification complete."

