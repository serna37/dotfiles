# x86_64 バイナリを実行用 glibc
apk add /tmp/glibc-2.34-r0.apk &> /dev/null




# TODO macのに合わせる
echoc() {
    txt=$1
    color=$2
    echo -e "\e[$2m$1\e[m"
}

# ======================================================
# oh my zsh
# ======================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fino"
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# ======================================================
# ALIAS
# ======================================================
# vim
#alias v='vi -c "CocCommand explorer --no-focus --width 30"'
# TODO 初回起動でplugいれる系
v() {
    # plug入れてなければ入れてからvim起動
    if [ ! -d ~/.vim ]; then
        # TODO install.sh見直そう
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim -c "PlugInstall" -c "qa"
        vim "$@"
    else
        vim "$@"
    fi
}

# dev tool
alias t='tool-box'

# terminal ctrl
# TODO option Gはエラーになるはず
alias ll='ls -AFlihrt --color=auto'
alias l='eza -abghHliS --icons --git'
alias tree='eza -bghHliST --icons --git'
alias ..='cd ..'
alias rm='rm -i'
alias rmf="gum confirm && rm -rf"
alias re='exec $SHELL -l'
alias q='exit'


# echoc "==============================================================" 33
# echoc "[INFO] Welcome to Dev Container for sandbox." 32
# echoc "[INFO] Mac like env -> command [mode-shift]" 32
# echoc "==============================================================" 33

