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

## Advanced Features

### UltraMode Daemon (Weekly Auto-Reapply)

Automatically reapplies UltraMode settings every Monday at 9:00 AM:

```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install-daemon.sh | bash
```

**What it does:**
* Checks and reapplies file descriptor limits
* Verifies Node.js memory settings
* Ensures watcher optimizations are active
* Logs all actions to `~/.ultramode/daemon.log`

**Uninstall:**
```bash
launchctl unload ~/Library/LaunchAgents/com.trendscoded.ultramode.daemon.plist
```

### Raycast GUI Dashboard

Beautiful GUI dashboard for managing UltraMode:

```bash
# Install Raycast extension
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/raycast-ultramode.json -o ~/.config/raycast/extensions/ultramode.json

# Or use the script directly
bash raycast-ultramode-dashboard.sh status
bash raycast-ultramode-dashboard.sh reapply
bash raycast-ultramode-dashboard.sh logs
```

**Features:**
* Real-time status display
* One-click reapply settings
* View daemon logs
* Install/uninstall daemon

### Auto-Heal on macOS Updates

Automatically detects macOS system updates and reapplies settings:

```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install-autoheal.sh | bash
```

**What it does:**
* Checks macOS version every hour
* Detects when system updates reset settings
* Automatically reapplies user-level optimizations
* Logs all actions to `~/.ultramode/auto-heal.log`

**Note:** System-level changes (sysctl) may require manual re-run of `ultramode-install.sh` after major macOS updates.

## Complete Installation Guide

### 1. Basic Setup
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install.sh | bash
```

### 2. UltraMode (System-Level)
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/ultramode-install.sh | sudo bash
```

### 3. Install Daemon (Optional)
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install-daemon.sh | bash
```

### 4. Install Auto-Heal (Optional)
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/install-autoheal.sh | bash
```

### 5. Check Status
```bash
curl -fsSL https://raw.githubusercontent.com/Beseder00/bootstrap-mac-setup/main/extreme-status.sh | bash
```

## Repository

https://github.com/Beseder00/bootstrap-mac-setup

