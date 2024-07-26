# ======================================================
# PROMPT SETTINGS
# ======================================================
# Utility
source ~/git/dotfiles/conf/zsh/.zshrc.utils
# custom
source ~/git/dotfiles/conf/zsh/.zshrc.custom
# devbox
source ~/git/dotfiles/conf/zsh/.zshrc.devbox

echo_info "Load ~/.zshrc"
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep

# ======================================================
# ENHANCED COMMAND SETTINGS
# ======================================================
# zoxide
eval "$(zoxide init zsh)"
export _ZO_FZF_OPTS='
    --no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
    --bind ctrl-f:page-down,ctrl-b:page-up
    --bind pgdn:preview-page-down,pgup:preview-page-up
    --prompt="❯ "
    --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
    --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
    --color prompt:#87afff,pointer:#ff5189,marker:#f09479
    --preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'
# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-git-prompt
source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh

# powerlevel10k
source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======================================================
# ALIAS
# ======================================================
# vim
alias v='vi -c "CocCommand explorer --no-focus --width 30"'
alias zv='zi && v'

# TUI
alias e='yazi'
alias d='lazydocker'
alias g='lazygit'
alias zg='zi && g'

# ls
alias ll='ls -AFGlihrt --color=auto'
alias l='eza -abghHliS --icons --git'
alias tree='eza -bghHliST --icons --git'

# cd
alias ..='cd ..'

# terminal ctrl
alias q='exit'
alias rezsh='exec $SHELL -l'
alias re='cd && clear && rezsh'

# ======================================================
# PATH
# ======================================================
# brew
export PATH="$PATH:/opt/homebrew/bin/"

# Rust
export PATH="$PATH:$CARGO_HOME/bin"

# Python
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
alias pip='python -m pip'

# Go
export PATH="$PATH:$HOME/work/go/bin"

# Java
PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home -v 11`

# ======================================================
# C++
# ======================================================
# C++用設定
source ~/git/dotfiles/conf/cpp/.zshrc.cpp

