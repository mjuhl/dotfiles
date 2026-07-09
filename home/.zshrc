# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

fpath+=("$(brew --prefix)/share/zsh/site-functions")

# Initialize zsh's completion system
autoload -Uz compinit && compinit

autoload -U promptinit; promptinit
prompt pure

# Plugins: self-contained copies live in ZSH_PLUGIN_DIR and are sourced directly.
ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"

source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

# git plugin needs these two helpers (originally from oh-my-zsh's lib/git.zsh).
function __git_prompt_git() { GIT_OPTIONAL_LOCKS=0 command git "$@" }
function git_current_branch() {
	local ref
	ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?
	if [[ $ret != 0 ]]; then
		[[ $ret == 128 ]] && return  # no git repo.
		ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
	fi
	echo ${ref#refs/heads/}
}
source "$ZSH_PLUGIN_DIR/git/git.plugin.zsh"

# als: prints a cheatsheet of your aliases grouped by command
source "$ZSH_PLUGIN_DIR/aliases/aliases.plugin.zsh"

# bgnotify: desktop notification when a long-running bg command finishes
source "$ZSH_PLUGIN_DIR/bgnotify/bgnotify.plugin.zsh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Personal aliases. These are defined after the plugins above so they win on
# any name collisions (e.g. gg, gst). For a full list, run `alias`.
alias zshrc="nvim ~/.zshrc"
# alias ls="lsd -lA" # remap ls to LSDeluxe (and use long opt by default)
alias gg="lazygit"
alias reload="source ~/.zshrc && exec /bin/zsh"
alias npmg="npm list -g --depth 0" # show globally installed packages
alias trs="tmux rename-session"
alias gst="git status"
alias ll="ls -al"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# enable frum (fast ruby version manager)
# eval "$(frum init)"

export PATH=/Users/mjuhl/.local/bin:$PATH

# bun completions
# [ -s "/Users/mjuhl/.bun/_bun" ] && source "/Users/mjuhl/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

# zsh-syntax-highlighting must be sourced LAST, after everything else.
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

