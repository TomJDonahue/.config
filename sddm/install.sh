#!/usr/bin/env bash
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
sudo rm -rf /usr/share/sddm/themes/habamax
sudo cp -r "$src/habamax" /usr/share/sddm/themes/habamax
sudo install -Dm644 "$src/10-theme.conf" /etc/sddm.conf.d/10-theme.conf
