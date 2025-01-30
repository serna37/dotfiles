# ====================================
# 共通コマンド
# ====================================
# 情報ログ形式でecho
# info 'Hello World!'
# info 'test \e[33m yellw'  途中から色を変えることも可能
function info() {
    #echo -e "\e[32m[\e[34mINFO\e[32m] \e[34m$1\e[m"
    printf "\e[32m[\e[34mINFO\e[32m] \e[34m$1\e[m\n"
}
function warn() {
    printf "\e[32m[\e[33mWARN\e[32m] \e[34m$1\e[m\n"
}
function error() {
    printf "\e[32m[\e[31mERROR\e[32m] \e[34m$1\e[m\n"
}

# $1がなければ$2をインストール
function _lazy_install() {
    if ! type "$1" > /dev/null 2>&1; then
        info "INSTALL: $1"
        if [ "$(uname)" = "Darwin" ]; then
            brew install $2
        fi
    fi
}

# 標準出力を出さずに、ロード中spinを表示
# spin 'loading...' sleep 3
function spin() {
    _lazy_install gum gum
    gum spin --title "$1" -- "${@:2}"
}

# zshの補完
autoload -Uz compinit
compinit

# ====================================
# ショートカットコマンド、便利ツール
# ====================================
source ~/git/dotfiles/conf/zsh/.zshrc.cmds

# ====================================
# パス追加
# ====================================
# brew
export PATH="$PATH:/opt/homebrew/bin/"
# Python
export PATH="$PATH:/opt/homebrew/bin/python3"
# nvm
export NVM_DIR="$HOME/.nvm"

# ====================================
# プロンプト設定
# ====================================
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep
# シンタックスハイライト
if [ ! -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    info 'INSTALL: zsh-syntax-highlighting'
    brew install zsh-syntax-highlighting
fi
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 補完 →キーで補完する
if [ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    info 'INSTALL: zsh-autosuggestions'
    brew install zsh-autosuggestions
fi
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Git補完
if [ ! -f /opt/homebrew/opt/zsh-git-prompt/zshrc.sh ]; then
    info 'INSTALL: zsh-git-prompt'
    brew install zsh-git-prompt
fi
source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
eval "$(gh completion -s zsh)"
# 外観
if [ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    info 'INSTALL: powerlevel10k'
    brew install powerlevel10k
fi
source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================
# 言語
# ====================================
# Python
alias python='python3'
alias pip='python -m pip'
# Nodejsのためnvm (cocのためにvoltaでない)
if [ ! -d $HOME/.nvm ]; then
    info 'INSTALL: nvm'
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install stable --latest-npm
    nvm alias default stable
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# C++
source ~/git/dotfiles/conf/zsh/.zshrc.cpp

# ====================================
# ロード
# ====================================
# rmのセーフガード
alias rm='rm -i'
# shell再起動
alias re='exec $SHELL -l'
# exit
alias q='exit'

clear
info 'Load ~/.zshrc'
_lazy_install fastfetch fastfetch
fastfetch
info '== Favorit Commands =='
info 'v zi l e | g d s top c'
info 'solve cpp_exe'

