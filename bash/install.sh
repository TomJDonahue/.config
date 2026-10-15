#!/usr/bin/env bash
# install.sh - link bash config from ~/.config/bash into $HOME via stubs
set -euo pipefail

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bash"
FILES=(.bashrc .bash_logout .bash_profile)
# add .bash_profile here if you want it managed too

mkdir -p "$CONF_DIR"

for f in "${FILES[@]}"; do
    real="$CONF_DIR/${f#.}"     # .bashrc -> ~/.config/bash/bashrc
    stub="$HOME/$f"

    # First run on an existing machine: migrate the real file into .config
    if [[ -f "$stub" && ! -e "$real" ]] && ! grep -q "managed-stub" "$stub"; then
        mv "$stub" "$real"
        echo "moved  $stub -> $real"
    fi

    # Fresh machine with no config at all: create an empty one
    [[ -e "$real" ]] || { touch "$real"; echo "created $real"; }

    # Back up anything that isn't already one of our stubs
    if [[ -e "$stub" ]] && ! grep -q "managed-stub" "$stub"; then
        mv "$stub" "$stub.bak"
        echo "backup $stub -> $stub.bak"
    fi

    cat > "$stub" <<EOF
# managed-stub: do not edit, see $real
[ -f "$real" ] && . "$real"
EOF
    echo "stub   $stub"
done
