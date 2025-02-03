# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# GITSTATUS_LOG_LEVEL=DEBUG

export HOMEBREW_BREWFILE=~/.config/brewfile/Brewfile

#################################
# Basic options
#################################
setopt AUTO_CD NO_CASE_GLOB GLOB_COMPLETE
unsetopt correct_all

#################################
# Misc variables
#################################
export CXONE=/Volumes/Tardis/cxone

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

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward


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
export HOMEBREW_PREFIX="$(brew --prefix)"

#################################
# Source Additional Files
#################################
files=('.zshrc_alias_functions' '.zshrc_colors' '.zshrc_tokens' )
for f in $files; do
  if [ -f $f ]; then
  	. ~/$f
  fi
done

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

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --
bindkey "ç" fzf-cd-widget

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    #cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

#source ~/bin/fzf-git.sh/fzf-git.sh
[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh


export BAT_THEME=Dracula

#################################
# Banner
#################################
#neofetch
fastfetch

#---- Zoxide (better cd)
eval "$(zoxide init zsh)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/scott/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


#[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

if [ -z "$TMUX" ] && [[ "$TERM" = "xterm-kitty" || "$TERM" = "xterm-ghostty" || -n "$WEZTERM_CONFIG_FILE" ]]; then
  if ! tmux list-sessions | grep -q -E '^main.*\(attached\)$'; then
	  tmux attach -d -t main || tmux new -s main
  fi
fi

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
