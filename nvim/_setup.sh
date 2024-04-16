#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up nvim..."

CWD=$(pwd)

error "nvim setup is not implemented"
# TODO:: is this even necessary with the lvim setup? probably not...
success "Successfully set up nvim"

