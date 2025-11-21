#!/usr/bin/env bash
set -e

echo "⚙️ Applying macOS system performance limits…"

sudo sysctl -w kern.maxfiles=1048576
sudo sysctl -w kern.maxfilesperproc=1048576

ulimit -n 1048576
ulimit -u 2048

echo "kern.maxfiles=1048576" | sudo tee -a /etc/sysctl.conf >/dev/null
echo "kern.maxfilesperproc=1048576" | sudo tee -a /etc/sysctl.conf >/dev/null

echo "Done."

