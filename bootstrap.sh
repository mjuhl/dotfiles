#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

preventSudo
bash scripts/dependencies.sh
bash scripts/macos.sh
bash scripts/links.sh

success "Completed bootstrapping dotfiles successfully"

