#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up npm dependencies..."

npm install -g typescript
npm install -g eslint_d
npm install -g nodemon

success "Successfully set up npm dependencies."

