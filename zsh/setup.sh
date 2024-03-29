#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
CWD=$(pwd)

. ../scripts/functions.sh

info "Setting up zsh ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
mv $HOME/.zshrc $HOME/.zshrc.bk
ln -s $CWD/.zshrc $HOME/.zshrc

# install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# TODO: there are probably more that need to be installed?

success "Successfully set up zsh. Remember to reload."

