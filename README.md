# macOS AI Engineering Bootstrap

This repo configures a full AI-optimized development environment for macOS.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install.sh | bash
```

## Extreme Mode Repair (Advanced)

For maximum performance with Next.js, AI workloads, and heavy development:

```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/extreme-mode-repair.sh | bash
```

Or check status:
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/extreme-status.sh | bash
```

## UltraMode Installer (System-Level, Requires Sudo)

**Maximum performance boost** - Requires root access for system-level optimizations:

```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/ultramode-install.sh | sudo bash
```

**What UltraMode does:**
* System-level sysctl tunings (200,000 file descriptors)
* Persistent across reboots
* Node.js memory boost (4GB heap)
* Next.js/Turbopack watcher optimizations
* Local Postgres tuning for AI workloads
* Cursor AI strict mode
* Zed LSP memory boost

**Note:** Requires `sudo` - modifies system files for maximum performance.

## What's Included

### Basic Install
* AI-optimized shell (`.zshrc`, `.zprofile`)
* Full reproducible toolchain (`Brewfile`)
* macOS system tuning for LLM workloads
* Verification suite

### Extreme Mode (Optional, User-Level)
* 200,000+ file descriptor limits (50x boost)
* Process limit optimization (4096+)
* Node.js memory tuning (8GB heap)
* Next.js/Turbopack watcher optimizations
* Cursor AI Engineering Mode rules
* Zed AI configuration
* Optional: Raycast, Supabase CLI, Postgres

### UltraMode (System-Level, Requires Sudo)
* System-wide sysctl tunings (persistent)
* macOS-native file descriptor limits
* Node.js 4GB memory boost
* Postgres local optimization (2GB shared buffers)
* Cursor strict AI engineering mode
* Zed TypeScript LSP boost (4GB)
* Self-healing on rerun

## Safety

✅ **100% Safe** - No system files replaced
✅ **Idempotent** - Safe to run multiple times
✅ **Transparent** - All commands are visible
✅ **Opt-in** - Optional installs require confirmation
✅ **Append-only** - Never overwrites your configs

## Repository

https://github.com/Beseder00/bootstrap-mac-setup

