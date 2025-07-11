clear
echo -e "\e[34m-------------------------------------------------------------------\e[m"
echo -e "\e[34m[ LOAD START ] ~/.zshrc\e[m"

# ====================================
# 環境設定
# Homebrew, Nodejs, Python
# ====================================
# Homebrew
export PATH="$PATH:/opt/homebrew/bin/"
# Python
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
alias pip='python3 -m pip'
# nvm
# TODO ここに記述をしたくないので、別の管理コマンドにしたい
export NVM_DIR="$HOME/.nvm"
if [ ! -d $HOME/.nvm ]; then
    echo -e "\e[34m [INFO] install nvm\e[m"
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
    echo -e "\e[34m [INFO] install zsh-syntax-highlighting\e[m"
    brew install zsh-syntax-highlighting
fi
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# コマンド補完 →キーで補完する
if [ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo -e "\e[34m [INFO] install zsh-autosuggestions\e[m"
    brew install zsh-autosuggestions
fi
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 外観
if [ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    echo -e "\e[34m [INFO] install powerlevel10k\e[m"
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

# vim コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cat << "EOF" > ~/.vim/after/plugin/common-settings.vim
au FileType * setlocal formatoptions-=ro
EOF

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
    --prompt="❯ "
    --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
    --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
    --color prompt:#87afff,pointer:#ff5189,marker:#f09479
    --preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'
alias z='_zoxide'

# yazi エクスプローラ
mkdir -p ~/.config/yazi
cat << "EOF" > ~/.config/yazi/yazi.toml
[manager]
show_hidden = true
EOF
function e() {
    type yazi > /dev/null 2>&1 || brew install yazi
    yazi
}

# eza (ls -AFGlihrt --color=auto)
function l() {
    type eza > /dev/null 2>&1 || brew install eza
    eza -abghHliS --icons --git $@
}

# lazygit + git設定
cat << "EOF" > ~/.gitconfig
[user]
    name = さーな
    email = 37serna37serna37serna@gmail.com

[credential]
    helper = osxkeychain
EOF
function g() {
    type lazygit > /dev/null 2>&1 || brew install lazygit
    lazygit
}

# lazydocker + orbstack起動
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

# ssh / termscp 接続 + 接続設定
mkdir -p ~/.ssh
cat << "EOF" > ~/.ssh/config
# Added by OrbStack
# This only works if it's at the top of ssh_config (before any Host blocks).
Include ~/.orbstack/ssh/config

Host *
  # SSH接続を10倍速くする
  # https://qiita.com/suin/items/1708dc78fc412297f885
  ControlMaster auto
  ControlPath ~/.ssh/mux-%r@%h:%p
  ControlPersist 4h
  # パスフレーズの保存と複合
  # https://qiita.com/kaino5454/items/98dcf3a996f2074e0074
  AddKeysToAgent yes
  UseKeychain yes
EOF
function s() {
    if [ "$1" = "ssh" ]; then
        type gum > /dev/null 2>&1 || brew install gum
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

# lazysql
function db() {
    type lazysql > /dev/null 2>&1 || brew install lazysql
    lazysql
}

# top → bottomを使用
function top() {
    type btm > /dev/null 2>&1 || brew install bottom
    btm --battery
}

# fastfetch
function os() {
    type fastfetch > /dev/null 2>&1 || brew install fastfetch
    fastfetch
}

# ハック+マトリックスのアニメ
function c() {
    type genact > /dev/null 2>&1 || brew install genact
    genact -s 10 --exit-after-modules 1 -m botnet
    genact -s 10 --exit-after-modules 1 -m bruteforce
    type cmatrix > /dev/null 2>&1 || brew install cmatrix
    cmatrix
}

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
    DEL=(gum
    zoxide fzf bat eza yazi
    lazygit lazydocker
    termscp
    bottom
    fastfetch genact cmatrix tty-clock
    ffmpeg
    zsh-syntax-highlighting zsh-autosuggestions powerlevel10k
    jq nmap gobuster
    )
    for v in ${DEL[@]}; do
        brew uninstall $v
    done
    exec $SHELL -l
}


echo -e "\e[34m>> Enhanced  Commands\e[m"
echo -e "   \e[35m(file) \e[32mz e l \e[35m(tool)\e[33m g d s db \e[35m(visual)\e[36m top os c clock gif \e[35m(oblivion)\e[31m Azathoth\e[m"
echo -e "\e[34m[ LOAD  DONE ] ~/.zshrc\e[m"
echo -e "\e[34m-------------------------------------------------------------------\e[m"

