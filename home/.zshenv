# .zshenv is sourced for EVERY zsh invocation (interactive shells, scripts,
# `zsh -c`, and GUI-spawned processes), so keep it limited to fast environment
# variable assignments. Anything interactive or slow (prompt, plugins, compinit,
# aliases, `eval "$(tool init)"`, sourcing nvm, etc.) belongs in .zshrc.
#
# NOTE: PATH is intentionally NOT set here. On macOS /etc/zprofile runs
# path_helper after .zshenv and reorders PATH, so PATH tweaks live in .zshrc
# (which runs last) to keep their ordering intact.

export EDITOR='nvim'
export LANG='en_US.UTF-8'

# nvm: the directory variable is env, but the (heavy) nvm.sh sourcing stays in
# .zshrc so it only runs for interactive shells.
export NVM_DIR="$HOME/.nvm"
