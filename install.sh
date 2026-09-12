#!/usr/bin/env bash
#
# Link this repo's configs into the locations nvim and wezterm read from.
#
#   ./install.sh
#
# Safe to re-run

link_config() {
    local src="$REPO_DIR/$1"
    local dest="$2"

    printf '%s\n  -> %s\n' "$dest" "$src"

    if [ ! -e "$src" ]; then
        printf '    skip: not present in repo\n\n'
        return
    fi

    # Already the link we want: nothing to do.
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        printf '    ok: already linked\n\n'
        return
    fi

    # A real file/dir, or a link pointing somewhere else, is in the way.
    # Refuse to touch it; moving it is the user's call.
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        printf '    ERROR: %s already exists\n' "$dest" >&2
        printf '    move or remove it, then re-run\n' >&2
        exit 1
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    printf '    linked\n\n'
}

#-e abort when a command fails
#-u reference to unset variable is error, not empty string
#-o pipefail: a | b will fail if any stage fails, not just last
set -euo pipefail

# Resolve absolute path
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The XDG spec says config lives in $XDG_CONFIG_HOME, falling back to ~/.config
# when that is unset. Both nvim and wezterm follow this.
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

printf 'repo:    %s\n' "$REPO_DIR"
printf 'config:  %s\n' "$CONFIG_HOME"
printf '\n'

link_config nvim    "$CONFIG_HOME/nvim"
link_config wezterm "$CONFIG_HOME/wezterm"

printf 'done\n'
