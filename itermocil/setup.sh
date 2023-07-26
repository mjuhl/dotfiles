#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. ../scripts/functions.sh

info "Setting up itermocil ..."

# if homebrew installation fails (which is has) do this instead:
# cd ~
# gh repo clone TomAnthony/itermocil -- --branch master  --single-branch
# ln -s /Users/mjuhl/itermocil/itermocil  /usr/local/bin/itermocil
# ln -s /Users/mjuhl/itermocil/itermocil.py /usr/local/bin/itermocil.py

# symlink .itermocil directory from icloud to home
ln -s $HOME"/Library/Mobile Documents/com~apple~CloudDocs/dev/.itermocil" ~/.itermocil

success "Successfully set up itermocil."

