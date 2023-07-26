#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

if grep Developer git/.gitconfig; then
	error "Please change your name in git/.gitconfig"
	exit 1
fi

if grep developer@example.com git/.gitconfig; then
	error "Please change your email in git/.gitconfig"
	exit 1
fi

info "Prompting for sudo password..."
if sudo -v; then
	# Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
	success "Sudo credentials updated."
else
	error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
	success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
	success "Finished installing XCode command line tools."
else
	error "Failed to install XCode command line tools."
fi

# info "Installing Rosetta..."
# sudo softwareupdate --install-rosetta

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

#brew bundle;
brew cleanup;
# brew doctor;
success "Finished installing Brewfile packages."

python3 -m pip install --upgrade setuptools
python3 -m pip install --upgrade pip

find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
	bash $setup
done

success "Finished installing Dotfiles"

