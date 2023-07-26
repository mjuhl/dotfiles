#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. ../scripts/functions.sh

info "Setting up lsd ..."

mkdir -p $HOME/.config/lsd
ln -s $CWD/config.yaml $HOME/.config/lsd/config.yaml

success "Successfully set up lsd."

