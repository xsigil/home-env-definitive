#!/bin/sh
set -eu

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

link_file() {
    src="$1"
    dst="$2"

    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    printf "LINKED: %s -> %s\n" "$dst" "$src"
}

echo "==> Deploying home-env-definitive..."

# 1. Home dotfiles (~/.*)
link_file "$BASEDIR/home/zshenv"       "$HOME/.zshenv"
link_file "$BASEDIR/home/profile"      "$HOME/.profile"
link_file "$BASEDIR/home/bash_profile" "$HOME/.bash_profile"
link_file "$BASEDIR/home/bashrc"       "$HOME/.bashrc"

# 2. XDG Configs (~/.config/...)
link_file "$BASEDIR/config/tmux/tmux.conf"                "$HOME/.config/tmux/tmux.conf"
link_file "$BASEDIR/config/user-dirs.conf"                "$HOME/.config/user-dirs.conf"
link_file "$BASEDIR/config/user-dirs.dirs"                "$HOME/.config/user-dirs.dirs"
link_file "$BASEDIR/config/zsh"                           "$HOME/.config/zsh"
link_file "$BASEDIR/config/dnscrypt-proxy"                "$HOME/.config/dnscrypt-proxy"
link_file "$BASEDIR/config/nmap"                          "$HOME/.config/nmap"
link_file "$BASEDIR/config/proxychains"                   "$HOME/.config/proxychains"
link_file "$BASEDIR/config/ssl"                           "$HOME/.config/ssl"
link_file "$BASEDIR/config/nvim"                          "$HOME/.config/nvim"

# 3. Executable Binaries (~/.local/bin/...)
mkdir -p "$HOME/.local/bin"
for bin_path in "$BASEDIR/bin"/*; do
    [ -f "$bin_path" ] || continue
    chmod +x "$bin_path"
    link_file "$bin_path" "$HOME/.local/bin/$(basename "$bin_path")"
done

# 4. Local Share Data (~/.local/share/...)
link_file "$BASEDIR/local/share/db"   "$HOME/.local/share/db"
link_file "$BASEDIR/local/share/dict" "$HOME/.local/share/dict"

echo "==> Done. Deployment complete."
