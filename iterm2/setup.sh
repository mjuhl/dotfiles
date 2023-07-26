#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"

info "Setting up iTerm2..."

# Load custom preferences from this folder
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$SOURCE"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1

# install shell integration
curl -L https://iterm2.com/shell_integration/zsh \
-o ~/.iterm2_shell_integration.zsh

success "Successfully set up iTerm2."

