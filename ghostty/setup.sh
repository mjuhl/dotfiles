#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. ../scripts/functions.sh

info "Setting up ghostty ..."
mkdir -p $HOME/.config/ghostty
ln -s $CWD/config $HOME/.config/ghostty

success "Successfully set up ghostty"

