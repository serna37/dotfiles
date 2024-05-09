# ======================================================
# PROMPT SETTINGS
# ======================================================
HISTSIZE=100000
SAVEHIST=100000
setopt no_beep

# pecoのバックiサーチ
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# ======================================================
# ALIAS
# ======================================================
# vim
alias v='vi -c "CocCommand explorer --no-focus --width 30"'
alias zv='zi && v'

# ls
alias ll='ls -AFGlihrt --color=auto'
alias l='eza -abghHliS --icons --git'
alias tree='eza -bghHliST --icons --git'
alias zoxide_ls='zoxide query -ls'
alias zoxide_rm='(){zoxide remove $1}'

# find
alias find='fd -H -E .git -E .DS_Store -t f'
alias fzf="fzf --preview 'bat -n --color=always {}'"
alias fv='tmp="$(fd | fzf)" && bat $tmp && v $tmp'
alias explorer='export EDITOR="vi" && br -h -c :open_preview'

# df ps top
alias df='dust'
alias ps='procs -t'
alias top='btm --battery --enable_cache_memory'

# cd
alias ..='cd ..'

# util
alias q='exit'
alias x86brew='arch -x86_64 /usr/local/bin/brew'
alias rezsh='exec $SHELL -l'

# tools
alias g='lazygit'
alias d='lazydocker'
alias localhost_here='python -m http.server 8000'
alias clock='tty-clock -sc -C2'
alias app='open "$(\fd -t d -d 1 . /Applications | \fzf)"'

# GitHub
alias issue_create='cd ~/git/task && gh issue create'
alias issue_list='cd ~/git/task && gh issue list'
alias issue_49_close='cd ~/git/task && gh issue view 49 && gh issue close 49'
alias pr_develop_feature='gh pr create --base develop --head $(git branch --contains | cut -d " " -f 2) --title "modify" --body ""'
alias pr_release_develop='gh pr create --base release --head develop --title "Publish" --body ""'
alias pr_master_release='gh pr create --base master --head release --title "Publish" --body ""'

# Gifへ変換
gif() {
    if [ $# != 2 ]; then
        echo "Usage:"
        echo "  gif [basefile] [output-name.gif]"
        echo "Alias Of:"
        echo "  ffmpeg -i [basefile] -r 10 [output-name.gif]"
    else
        ffmpeg -i $1 -r 10 $2
        l
    fi
}

# C++用設定
source ~/git/dotfiles/conf/cpp/.zshrc.cpp

# ======================================================
# ENHANCED COMMAND SETTINGS
# ======================================================
export PATH="$PATH:/opt/homebrew/bin/"

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
# broot
source /Users/serna37/Library/Application\ Support/org.dystroy.broot/launcher/bash/br

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
# DEV-TOOLS, LANGUAGES, PATH
# ======================================================
# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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
# EOF
# ======================================================

