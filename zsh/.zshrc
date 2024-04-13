# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# GITSTATUS_LOG_LEVEL=DEBUG

#################################
# Basic options
#################################
setopt AUTO_CD
setopt NO_CASE_GLOB
setopt GLOB_COMPLETE
unsetopt correct_all

#################################
# Misc variables
#################################
export CXONE=/Volumes/T16-Skyhopper/cxone

#################################
# Man Pager
#################################
#export MANPAGER="nvim +Man"

#################################
# History file options
#################################
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

#################################
# vi command line editing
#################################
export VISUAL="vim"
export EDITOR="vim"
bindkey -v

export KEYTIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

MODE_CURSOR_VICMD="green blinking bar"
MODE_CURSOR_VIINS="#red block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"

#################################
# Auto Complete
#################################
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#################################
# GREP
#################################
export GREP_OPTIONS='--color=auto --exclude-dir=.svn --exclude-dir=target'

#################################
# Set platform variable
#################################
case $(uname) in
    Darwin)
    # macOS specific code goes here
    export platform="mac"
    ;;

    Linux)
    export platform="linux"
    alias ls="ls --color"
    ;;

    *)
    export platform="other"
    # Other platforms code goes here
esac

#################################
# Git and Github
#################################
export GITHUB_USER=scottfwalter
export GITHUB_USER_NICE=scottwalter-nice
#export GITHUB_TOKEN=$(op item get "Github (Personal)" --fields "Access Token")
#export GITHUB_TOKEN_NICE=$(op item get "Github (Nice)" --fields "Access Token")

#################################
# PATH
#################################
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export DOTFILES="$HOME/Dropbox/dotfiles"

#################################
# Source Additional Files
#################################
files=('.zshrc_alias_functions' '.zshrc_colors' )
for f in $files; do
  . ~/$f
done

checksetup

#################################
# Node JS
#################################
eval "$(fnm env --use-on-cd)"
# bun completions
[ -s "/Users/scott/.bun/_bun" ] && source "/Users/scott/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#################################
# Java
#################################
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

#################################
# macOS
#################################
platform_zshrc=${ZDOTDIR:-$HOME}/.zshrc_$(uname)
if [[ -r $platform_zshrc ]]; then
    source $platform_zshrc
fi

#################################
# Starship
#################################
#export STARSHIP_CONFIG=~/.starship-config/starship.toml
eval "$(starship init zsh)"


#################################
# fzf
#################################
eval "$(fzf --zsh)"

#################################
# Banner
#################################
neofetch

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/scott/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


#[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
