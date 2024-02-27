#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up bun..."

# doing this via Brewfile now
# curl -fsSL https://bun.sh/install | bash

info "remember to use \`brew upgrade bun\` to upgrade (not bun upgrade)"

success "Successfully set up bun"
