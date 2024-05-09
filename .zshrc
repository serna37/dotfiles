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
alias debug='cpp_exe'
alias cpp_ini='cp ~/git/dotfiles/conf/cpp/.clang-format . && cp ~/git/dotfiles/conf/cpp/compile_flags.txt .'
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

# C++ビルド
cpp_build() {
    filename=$1
    file="${filename%.*}"
    g++ \
        -std=c++23 \
        -I /opt/homebrew/Cellar/gcc/13.2.0/include/c++/13/aarch64-apple-darwin22 \
        -Wall \
        -Wextra \
        -mtune=native \
        -march=native \
        -fconstexpr-depth=2147483647 \
        -fconstexpr-loop-limit=2147483647 \
        -fconstexpr-ops-limit=2147483647 \
        -ftrapv \
        -fsanitize-undefined-trap-on-error \
        -o $file $1
        #-fsanitize=address,undefined \
}

# フォルダ名を指定してC++実行
export CC_EXE_PROBLEM="z"
cpp_exe() {
    if [ $# -eq 1 ]; then
        export CC_EXE_PROBLEM=$1
    fi
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_EXE_PROBLEM/main.cpp processing...\e[m"
    cpp_build ./$CC_EXE_PROBLEM/main.cpp
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_EXE_PROBLEM/main.cpp complete.\e[m"
    echo -e "==================================="
    echo -e "\e[33m-----------------------------\e[m"
    ./$CC_EXE_PROBLEM/main
    res=$?
    echo -e "\e[33m-----------------------------\e[m"
    if [ $res -eq 0 ]; then
        echo -e "[\e[34mINFO\e[m] \e[32mexit code:$res.\e[m"
    else
        echo -e "[\e[31mERROR\e[m] \e[mexeit code:$res."
    fi
}

# URLからojでC++テスト(vim atcoder menuに同機能あり)
cpp_test() {
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mmain.cppのある階層で実行してね\e[m"
    echo -e "[\e[34mINFO\e[m] \e[32m問題URLを入力\e[m"
    read OJ_D_URL
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mtestフォルダを空に\e[m"
    rm -rf ./test && mkdir test
    echo -e "[\e[34mINFO\e[m] \e[32mテストケースDL\e[m"
    oj d $OJ_D_URL
    echo -e "[\e[34mINFO\e[m] \e[32mビルド\e[m"
    cpp_build main.cpp
    echo -e "[\e[34mINFO\e[m] \e[32mテスト実行\e[m"
    echo -e "==================================="
    echo -e "==================================="
    oj t -c "./main"
}

# AtCoderコンテスト、朝活、ADT、単一練習用
export AC_DIR="$HOME/git/contest"
export ASA_DIR="$HOME/git/asakatu"
export ADT_DIR="$HOME/git/adt"
export SAND_DIR="$HOME/git/sandbox"
AtCoder() {
    cd $AC_DIR
    contest_cd=$1
    file_name="main.cpp"
    acc check-oj
    oj login https://atcoder.jp
    acc login
    acc config default-task-choice all
    acc config default-test-dirname-format test
    valid=`acc contest $contest_cd`
    if [[ $valid == ''  ]]; then
        echo -e "[\e[31mERROR\e[m] create faild."
        return
    fi
    acc new $contest_cd
    cd $contest_cd
    dirs=(`\fd -d 1 -t d`)
    for v in ${dirs[@]}; do
        echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
}
AtCoderResolve() {
    cd $AC_DIR && rm -rf $1 && AtCoder $1
}
AsakatuAtCoder() {
    cd $ASA_DIR
    file_name="main.cpp"
    dirname=`date '+%Y%m%d'`
    mkdir $dirname
    cd $dirname
    mkdir a b c d e f
    dirs=(`\fd -d 1 -t d`)
    for v in ${dirs[@]}; do
        echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    if [[ -n $ASA_SAMPLE_DL ]]; then
        for v in ${dirs[@]}; do
            rm -rf "${v}test"
        done
        eval $ASA_SAMPLE_DL
        cd ../
    fi
    vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
}
ADTAtCoder() {
    cd $ADT_DIR
    file_name="main.cpp"
    dirname=`date '+%Y%m%d'`
    mkdir $dirname
    cd $dirname
    mkdir c d e f g
    dirs=(`\fd -d 1 -t d`)
    for v in ${dirs[@]}; do
        echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
}
solve() {
    cd $SAND_DIR
    echo -n > z/main.cpp
    cd z
    rm -rf test
    oj d $(pbpaste)
    cd ../
    v z/main.cpp
}

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
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
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

