#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. functions.sh

info "Sym-linking config files to home directory..."

shopt -s dotglob  # Enable matching of dotfiles

# === home -> ~/ ===
for item in ../home/*; do
	ln -s "$(realpath $item)" $HOME
done

# === config -> ~/.config ===
mkdir -p ~/.config

for item in ../config/*; do
  ln -s "$(realpath $item)" $HOME/.config
done

success "Config files linked"

