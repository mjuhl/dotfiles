#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. ../scripts/functions.sh

# SOURCE="$(realpath .)"

info "Setting up LunarVim...." 

if ( lvim --version ) < /dev/null > /dev/null 2>&1; then
	info 'LunarVim is already installed!'
else
	LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y
fi

if ( cat $HOME/.config/lvim/config.lua) < /dev/null > /dev/null 2>&1; then
	info "lvim config already exists, not overwriting"
else
	mkdir -p $HOME/.config/lvim
	ln -s $CWD/config.lua $HOME/.config/lvim/config.lua
fi

# Automator workflow for opening files with iterm/lvim.
# Add to the dock, then drag files or folders to open in iterm/lvim
ln -s $CWD/workflow.app /Applications/lvim.app

success "Successfully set up LunarVim" 

