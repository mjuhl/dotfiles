#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up Typora..."

# Load custom preferences from this folder
# orig ~/Library/Preferences/abnerworks.Typora.plist
defaults import abnerworks.Typora abnerworks.Typora.plist

mkdir -p $HOME/Library/Application\ Support/abnerworks.Typora/themes/

cd $HOME/Library/Application\ Support/abnerworks.Typora/themes/ \
  && curl -L https://github.com/jhildenbiddle/typora-themeable/releases/latest/download/typora-themeable.zip -o typora-themeable.zip \
  && unzip typora-themeable.zip \
  && rm typora-themeable.zip \
  && echo "\nInstallation complete. Please restart Typora."

success "Successfully set up Typora"
