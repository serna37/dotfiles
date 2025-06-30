# ====================================
# 環境設定
# ====================================
# brew
export PATH="$PATH:/opt/homebrew/bin/"
# Python
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
alias pip='python -m pip'
# nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -d $HOME/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install stable --latest-npm
    nvm alias default stable
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ====================================
# プロンプト設定
# ====================================
# zshの補完
autoload -Uz compinit
compinit
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep
# シンタックスハイライト
if [ ! -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    brew install zsh-syntax-highlighting
fi
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# コマンド補完 →キーで補完する
if [ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    brew install zsh-autosuggestions
fi
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Git補完
if [ ! -f /opt/homebrew/opt/zsh-git-prompt/zshrc.sh ]; then
    brew install zsh-git-prompt
fi
source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
eval "$(gh completion -s zsh)"
# 外観
if [ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    brew install powerlevel10k
fi
source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================
# カスタムコマンド・ツール
# ====================================

# rmのセーフガード
alias rm='rm -i'
# shell再起動
alias re='exec $SHELL -l'
# exit
alias q='exit'

# zoxide
# + eza fzf bat
function _zoxide() {
    type zoxide > /dev/null 2>&1 || brew install zoxide
    type eza > /dev/null 2>&1 || brew install eza
    type fzf > /dev/null 2>&1 || brew install fzf
    type bat > /dev/null 2>&1 || brew install bat
    eval "$(zoxide init zsh)"
    zi
}
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
alias zi='_zoxide'

# ls → eza
function l() {
    type eza > /dev/null 2>&1 || brew install eza
    eza -abghHliS --icons --git $@
    # ls -AFGlihrt --color=auto $@
}
function tree() {
    type eza > /dev/null 2>&1 || brew install eza
    eza -bghHliST --icons --git $@
    # pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
}

# エクスプローラ
function e() {
    type yazi > /dev/null 2>&1 || brew install yazi
    if [ ! -f ~/.config/yazi/yazi.toml ]; then
        ln -nfs ~/git/dotfiles/conf/config/yazi.toml ~/.config/yazi/yazi.toml
    fi
    yazi
}

# Lazy Git
function g() {
    type lazygit > /dev/null 2>&1 || brew install lazygit
    lazygit
}

# Lazy Docker
function d() {
    type lazydocker > /dev/null 2>&1 || brew install lazydocker
    CNT=$(ps aux | grep -c OrbStack)
    if [ $CNT -eq 1 ]; then
        open -g /Applications/OrbStack.app
        sleep 1
        type genact > /dev/null 2>&1 || brew install genact
        genact -s 10 --exit-after-modules 1 -m botnet
        genact -s 10 --exit-after-modules 1 -m bruteforce
    fi
    lazydocker
}

# SSH / SCP 接続
function s() {
    type gum > /dev/null 2>&1 || brew install gum
    if [ "$1" = "ssh" ]; then
        if [ ! -f ~/.ssh/known_hosts ]; then
            ssh $(gum input --prompt 'target. e.g.) github.com: ')
        else
            ssh $(cat ~/.ssh/known_hosts | awk '{print $1}' | uniq | gum choose)
        fi
    fi
    if [ "$1" = "scp" ]; then
        type termscp > /dev/null 2>&1 || brew install veeso/termscp/termscp
        termscp
    fi
}
function _s() { _values '' 'ssh[ssh接続]' 'scp[scp接続]' }
compdef _s s

# top → bottomを使用
function top() {
    type btm > /dev/null 2>&1 || brew install bottom
    btm --battery
}

# ハック+マトリックスのアニメ
function c() {
    type genact > /dev/null 2>&1 || brew install genact
    genact -s 10 --exit-after-modules 1 -m botnet
    genact -s 10 --exit-after-modules 1 -m bruteforce
    type cmatrix > /dev/null 2>&1 || brew install cmatrix
    cmatrix
}

# バックiサーチをhistoryのfzfにする
function incremental_search_history() {
    type fzf > /dev/null 2>&1 || brew install fzf
    selected=`history -E 0 | fzf --tac --height 75% --reverse --margin=0,1 | cut -b 24-`
    BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
    CURSOR=${#BUFFER}
    zle redisplay
}
zle -N incremental_search_history
bindkey "^r" incremental_search_history

# 時計
function clock() {
    type tty-clock > /dev/null 2>&1 || brew install tty-clock
    tty-clock
}

# Gif作成コマンド
function gif() {
    type ffmpeg > /dev/null 2>&1 || brew install ffmpeg
    type gum > /dev/null 2>&1 || brew install gum
    ffmpeg -i $(ls -A | gum choose) -r 10 $(gum input --prompt 'e.g.) test.gif: ')
}

# 入れたコマンドを全部消す
function Azathoth() {
    type gum > /dev/null 2>&1 || brew install gum
    if ! gum confirm; then
        return
    fi
    gum spin --title "delete all installed brew" -- sleep 3
    brew list
    \rm -rf ~/.nvm
    \rm ~/.netrc
    # この辺を入れて使っているメモ代わり
    DEL=(fastfetch
    zoxide fzf bat eza ripgrep
    lazygit lazydocker
    genact cmatrix tty-clock
    yazi gobang termscp gum
    ffmpeg jq
    bottom
    nmap gobuster
    zsh-syntax-highlighting zsh-autosuggestions
    zsh-git-prompt powerlevel10k
    )
    for v in ${DEL[@]}; do
        brew uninstall $v
    done
    exec $SHELL -l
}


# ====================================
# ロード
# ====================================

clear
type fastfetch > /dev/null 2>&1 || brew install fastfetch
fastfetch
echo '== Enhanced  Commands =='
echo 'zi l tree e | g d s top c | clock gif Azathoth'
echo '======================'

