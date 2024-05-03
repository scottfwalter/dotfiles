# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash"
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/scott/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


[[ -f "$HOME/fig-export/dotfiles/dotfile.bash" ]] && source "$HOME/fig-export/dotfiles/dotfile.bash"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash"
