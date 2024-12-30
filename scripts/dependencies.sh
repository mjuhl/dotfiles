#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. functions.sh
preventSudo

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
	success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
	success "Finished installing XCode command line tools."
else
	error "Failed to install XCode command line tools."
fi

# === HOMEBREW ===
#
if ( brew --version ) < /dev/null > /dev/null 2>&1; then
	info 'Homebrew is already installed!'
else
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

info "Installing Brewfile packages..."

if ( brew bundle check; ) < /dev/null > /dev/null 2>&1; then
	info 'Brewfiles already enabled'
else
	brew tap Homebrew/bundle;
fi

brew bundle --file ../Brewfile
brew cleanup;
# brew doctor;
success "Finished installing Brewfile packages."


# === ZSH ===
# (zsh is installed by homebrew)

info "Setting up zsh ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# TODO: there are probably more that need to be installed?

success "Successfully set up zsh. Remember to reload."


# === NODE.JS ===
. $(brew --prefix nvm)/nvm.sh
nvm install 22;

npm install -g typescript
npm install -g eslint_d
npm install -g nodemon

# === PYTHON ===
# FIXME: this is failing. need to set up a virtual environment, see:
# https://discuss.python.org/t/on-macos-14-pip-install-throws-error-externally-managed-environment/50352/6

# python3 -m pip install --upgrade setuptools
# python3 -m pip install --upgrade pip


substep_success "Completed dependencies.sh successfully"

