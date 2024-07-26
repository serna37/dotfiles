# x86_64 バイナリを実行用 glibc
apk add /tmp/glibc-2.34-r0.apk &> /dev/null

echoc() {
    txt=$1
    color=$2
    echo -e "\e[$2m$1\e[m"
}

echoc "==============================================================" 33
echoc "[INFO] Welcome to Dev Container for sandbox." 32
echoc "[INFO] Happy Hacking." 32
echoc "==============================================================" 33

alias re='source ~/.bashrc'
alias l='ls -AFlihrt'
v() {
    # plug入れてなければ入れてからvim起動
    if [ ! -d ~/.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim -c "PlugInstall" -c "qa!"
        vim "$@"
    else
        vim "$@"
    fi
}

