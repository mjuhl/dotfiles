#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up git..."

ln -s $CWD/.gitconfig $HOME/.gitconfig
ln -s $CWD/.gitignore_global $HOME/.gitignore_global

success "Successfully set up git"

