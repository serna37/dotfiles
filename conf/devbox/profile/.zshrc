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
alias v='vim -c "CocCommand explorer --no-focus --width 30"'

# dev tool
alias t='tool-box'

# terminal ctrl
alias ll='ls -AFlihrt --color=auto'
alias l='eza -abghHliS --icons --git'
alias tree='eza -bghHliST --icons --git'
alias ..='cd ..'
alias rm='rm -i'
alias rmf="gum confirm && rm -rf"
alias re='exec $SHELL -l'
alias q='exit'

# ======================================================
# PATH
# ======================================================
# brew
#export PATH="$PATH:/opt/homebrew/bin/"

# Rust
#export PATH="$PATH:$CARGO_HOME/bin"

# Go
#export PATH="$PATH:$HOME/work/go/bin"

# Java
#PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
#export JAVA_HOME=`/usr/libexec/java_home -v 11`

# ======================================================
# Utility
# ======================================================
# x86_64 バイナリを実行用 glibc
apk add /tmp/glibc-2.34-r0.apk &> /dev/null

# 情報ログ形式でecho
# echo_info "Hello World!"
# echo_info "test \e[33m yellw"  途中から色を変えることも可能
echo_info() {
    echo -e "\e[32m[\e[34mINFO\e[32m] \e[34m$1\e[m"
}

# 確認ダイアログ
# confirm "echo Hello World!" "cancelled"
confirm() {
    gum confirm && eval $1 || echo_info $2
}

# 指定秒数待機アニメーション
# loading 2 "Loading..."
loading() {
    if command -v gum > /dev/null 2>&1; then
        gum spin --title $2 -- sleep $1
    else
        sleep $1
    fi
}

# ======================================================
# Logo
# ======================================================
# tool-box用ロゴ
logo_toolbox() {
    echo -e "\e[32m"
    echo "                      _  _ ";
    echo "  _                  | || | ";
    echo " | |_    ___    ___  | || | _    ___   _   _ ";
    echo " |  _)  / _ \  / _ \ | || || \  / _ \ ( \ / ) ";
    echo " | |__ | |_| || |_| || || |_) )| |_| | ) X ( ";
    echo "  \___) \___/  \___/ |_||____/  \___/ (_/ \_) ";
    echo -e "\e[m"
}

# python ロゴ
logo_py() {
    echo -e "\e[33m"
    echo "               ........            "
    echo "            (MMMMMMMMMMMNJ         "
    echo "           ,MF  MMMMMMMMMM]        "
    echo "           ,MMNMMMMMMMMMMM]        "
    echo "       ............MMMMMMM].....   "
    echo "     JMMMMMMMMMMMMMMMMMMMM].==?=i. "
    echo "    dMMMMMMMMMMMMMMMMMMMMM].?==??1 "
    echo "   .MMMMMMMMMMMMMMMMMMMMMF ?=?===?_"
    echo "   -MMMMMMMMB'7<<<<<<<<~.(?==??=?={"
    echo "   ,MMMMMMM!.??=?=??=?????==?==?=?:"
    echo "    MMMMMMF.==?=?=?=?==?==?=?=?=?v "
    echo "    .WMMMMF.?==?=?==?=?==?=?=?==<  "
    echo "      .7""=.=?=?==?________  _     "
    echo "           .??==??=?=?=1?=:        "
    echo "           .?=?=?==?=?  .?:        "
    echo "            ~1?==?==??1+??         "
    echo "                _!!!!~             "
    echo -e "\e[m"
}

# python localhost ロゴ
logo_py_localhost() {
    logo_py
    echo -e "\e[32m"
    echo "  _                       _  _                             _____    ______   ______   ______ ";
    echo " | |                     | || |                  _        / ___ \  / __   | / __   | / __   | ";
    echo " | |  ___    ____   ____ | || | _    ___    ___ | |_   _ ( (   ) )| | //| || | //| || | //| | ";
    echo " | | / _ \  / ___) / _  || || || \  / _ \  /___)|  _) (_) > > < < | |// | || |// | || |// | | ";
    echo " | || |_| |( (___ ( ( | || || | | || |_| ||___ || |__  _ ( (___) )|  /__| ||  /__| ||  /__| | ";
    echo " |_| \___/  \____) \_||_||_||_| |_| \___/ (___/  \___)(_) \_____/  \_____/  \_____/  \_____/ ";
    echo -e "\e[m"
}

# python 仮想環境 ロゴ
logo_py_venv() {
    logo_py
    echo -e "\e[32m"
    echo "     _   _   ____  ____   _   _ ";
    echo "    | | | | / _  )|  _ \ | | | | ";
    echo "     \ V / ( (/ / | | | | \ V / ";
    echo "      \_/   \____)|_| |_|  \_/ ";
    echo -e "\e[m"
    sleep 0.5
}

# C++ ロゴ
logo_cpp() {
    echo -e "\e[34m"
    echo "                     .(XyyS&,                    "
    echo "                  .JyZZZZyZyyyn..                "
    echo "              ..dyyZZyyyZZyZZyZyyk-.             "
    echo "            .yyyZyZ0=!      _7XZZyyyW,           "
    echo "            dZZZyZ=            ?yQgMH#           "
    echo "            dyZyZ'    .dyyk.  .&HHHHH#           "
    echo "            dZyyr    dyZyyXQMHH@4HHYM#           "
    echo "            dZZy[   .yyQNMMHHHh,..&..K           "
    echo "            dyZZn    ?MNNNNMDTMHHHHHH#           "
    echo '            dyyZQa     ?""^     WMHHH#           '
    echo "            zQNNNMN,          .MNMNMM#           "
    echo '             THNMNNNMN&....(MNNNNMM#"            '
    echo "                ?YMNNNNMNNNNNNMMY=               "
    echo '                   .TMNNNMNMM"                   '
    echo '                       7"""`                     '
    echo -e "\e[m"
}

# C++ セットアップ ロゴ
logo_cpp_setup() {
    logo_cpp
    echo -e "\e[32m"
    echo "                      _ ";
    echo "          ___   ____ | |_   _   _  ____ ";
    echo "         /___) / _  )|  _) | | | ||  _ \ ";
    echo "        |___ |( (/ / | |__ | |_| || | | | ";
    echo "        (___/  \____) \___) \____|| ||_/ ";
    echo "                                  |_| ";
    echo -e "\e[m"
    sleep 0.5
}

# AtCoder ロゴ
logo_atcoder() {
    echo '                                               .'
    echo '                                             .dN.'
    echo '                                          ..d@M#J#(,'
    echo '                                       vRMPMJNd#dbMG#(F'
    echo '                             (O.  U6..  WJNdPMJFMdFdb#`  .JU` .Zo'
    echo '                          .. +NM=(TB5.-^.BMDNdJbEddMd ,n.?T@3?MNm  ..'
    echo '                         .mg@_J~/?`.a-XNxvMMW9""TWMMF.NHa._ ?_,S.Tmg|'
    echo '                      .Js ,3,`..-XNHMT"= ...d"5Y"X+.. ?"8MNHHa.. (,b uZ..'
    echo '                     J"17"((dNMMB"^ ..JTYGJ7"^  ?"T&JT9QJ..?"TMNNHa,?727N'
    echo '                     .7    T"^..JT"GJv"=`             ?"4JJT9a.,?T"`  .7!'
    echo '                             M~JY"!     ....<.Zj+,(...     .7Ta_M'
    echo '                 .JWkkWa,    d-F     .+;.ge.ga&.aa,ua+.g,     ,}#    .(Wkkkn,'
    echo '                .W9AaeVY=-.. J;b   .XH3dHHtdHHDJHHH(HHH(WH,   J(F  ..?T4agdTH-'
    echo '                 6XkkkH=!    ,]d  .HHtdHHH.HHHbJHHH[WHHH(HHL  k.]    _7HkkkHJ:'
    echo '                 JqkP?H_      N(; TYY?YYY9(YYYD?YYYt7YYY\YY9 .Fd!     .WPjqqh'
    echo '                 .mmmH,``      d/b WHHJHH@NJHHH@dHHHFdHHHtHH#`.1#       `(dqqq]'
    echo '                ,gmmgghJQQVb  ,bq.,YY%7YYY(YYY$?YYY^TYYY(YY^ K.]  JUQmAJmmmmg%'
    echo '                 ggggggggh,R   H,]  T#mTNNbWNN#dNN#(NN@(N@! .t#   d(Jgggggggg:'
    echo '                .@@@@@#"_JK4,  ,bX.   ?i,1g,jge.g2+g2i,?`   K.t  .ZW&,7W@@@@@h.'
    echo '            `..H@@@@@P   7 .H`  W/b        .^."?^(!        -1#   W, ?   T@@@@@Ma,`'
    echo '            dH@HHHM"       U\   .N,L        ..            .$d    .B`     ."MHHH@HN.'
    echo '       ....JMHHHHH@              ,N(p      .dH.d"77h.    .$J\              dHHHHHMU....'
    echo '      ` WHH#,7MHHM{               ,N,h     d^.W,        .^J^               .MHHM"_d#HN.'
    echo '       ,jH#Mo .MMW:                .W,4,  J\   Ta.-Y` .J(#                 .HMM- .M#MF!'
    echo '         .MN/ d@?M+                  7e(h.           .3.F                  .MDd# (MML`'
    echo '         .M4%  ?H, 7a,                .S,7a.       .Y.#^                .,"`.d=  ,PWe'
    echo '        .! ?     dN .N,                 (N,7a.   .Y(d=                 .d! d@     4 .!'
    echo '                 .W` .!                   ?H,?GJ".d"                    ^  B'
    echo '                                            (SJ.#='
    echo '                           J             ....            .M:'
    echo '                          JUb     .   .#    (\            M~'
    echo '                         .\.M;  .W@"` M}       .y7"m. .J"7M~ .v74e ,M7B'
    echo '                        .F  ,N.  J]   M]       M)  JF M_  M~ d-     M`'
    echo '                       .W,  .db, Jh.   Th...J\ /N..Y` ?N-.Ma.-M&.> .M-'
    echo ""
    echo ""
    sleep 0.5
}

# ======================================================
# Custom Commands
# ======================================================
# historyのfzf
incremental_search_history() {
  selected=`history -E 0 | fzf --tac --height 75% --reverse --margin=0,1 | cut -b 25-`
  BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N incremental_search_history
bindkey "^r" incremental_search_history

# ツール系のカスタムしたコマンドをリストで選択し実行
tool-box() {
    logo_toolbox
    LIST=(
        "[ ini] initiation"
        "[ exe] exe C++ file"
        "[ venv]"
        "[ server] localhost 8000"
        "[ DB] gobang"
        "[ DB] edit connection"
        "[ find] fd"
        "[ fzf] fzf"
        "[cancel]"
    )
    echo_info "Choose tool"
    LEN=$(expr ${#LIST[@]} + 3)
    TARGET=$(gum choose --height $LEN $LIST)
    case $TARGET in
        "[ ini] initiation")
            CMD='cpp_ini'
            ;;
        "[ exe] exe C++ file")
            FROM=$(ls -d $(find .) | grep main.cpp | gum choose)
            CMD="cpp_exe $FROM"
            ;;
        "[ venv]")
            CMD='logo_py_venv && python -m venv venv && . venv/bin/activate'
            ;;
        "[ server] localhost 8000")
            CMD='logo_py_localhost && python -m http.server 8000'
            ;;
        "[ DB] gobang")
            # TODO DB vierewはいれたいよなぁ
            CMD='gobang'
            ;;
        "[ DB] edit connection")
            CMD='cd ~/git/dotfiles && v conf/gobang/config.toml'
            ;;
        "[ find] fd")
            CMD='fd -H -E .git -E .DS_Store -t f'
            ;;
        "[ fzf] fzf")
            CMD="fzf --preview 'bat -n --color=always {}'"
            ;;
        *)
            echo_info "Skipped"
            return
            ;;
    esac
    confirm $CMD "Skipped"
}

# ======================================================
# C++ SETTINGS
# ======================================================
# C++ 初期化
cpp_ini() {
    # ojコマンドのためにPython仮想環境を作成
    logo_py_venv && python -m venv venv && . venv/bin/activate
    pip install --upgrade pip
    pip install --upgrade setuptools
    pip install online-judge-tools
    # AA
    logo_cpp_setup
    # LSP server用設定
    cp ~/cpp/.clang-format .
    cp ~/cpp/compile_flags.txt .
    # vimspector debug設定を追加
    cp -f ~/.vim/plugged/vim-IDE-menu/.vimspector.json .vimspector.json
}

# C++ビルド
CC_INCLUDE_PATH="/root/cpp"
export CC_BUILD_CMD="g++ -std=c++20 -I $CC_INCLUDE_PATH -Wall -Wextra -mtune=native -march=native -fconstexpr-depth=2147483647 -ftrapv -fsanitize-undefined-trap-on-error -o "

# C++ビルド+実行
cpp_exe() {
    echo "==================================="
    echo_info "build :$1 processing..."
    eval "$CC_BUILD_CMD _cpp_tmp $1 2>&1"
    echo_info "build :$1 complete."
    echo "==================================="
    echo -e "\e[33m-----------------------------\e[m"
    ./_cpp_tmp
    res=$?
    echo -e "\e[33m-----------------------------\e[m"
    if [ $res -eq 0 ]; then
        echo_info "exit code:$res"
    else
        echo -e "[\e[31mERROR\e[m] \e[mexit code:$res."
    fi
}

# AtCoder解く
solve() {
    AC_DIR="$HOME/git/contest"
    SAND_DIR="$HOME/work/sandbox"
    logo_atcoder

    # 引数が無い場合、クリップボードのURLを単一で解く
    if [ -z "$1" ]; then
        mkdir -p $SAND_DIR && cd $SAND_DIR
        cpp_ini
        mkdir a && touch a/main.cpp
        mkdir z && touch z/main.cpp
        #echo -n > z/main.cpp
        rm -rf a/test z/test
        cd z && oj d $(pbpaste)
        cd $SAND_DIR && v z/main.cpp
        return
    fi

    # AtCoder コンテスト
    mkdir -p $AC_DIR && cd $AC_DIR
    cpp_ini
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
        echo_info "touch file :\e[32m${v}${file_name}"
        touch "${v}${file_name}"
    done
    v
}

# ======================================================
# END
# ======================================================

# TODO ログインメッセージ変えような
# 最初にv起動しろってメッセージ

# echoc "==============================================================" 33
# echoc "[INFO] Welcome to Dev Container for sandbox." 32
# echoc "[INFO] Mac like env -> command [mode-shift]" 32
# echoc "==============================================================" 33

