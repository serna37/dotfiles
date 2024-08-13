# TODO [WIP] OS判定だけど、CentOS系もLinuxなので、aptなのかyumなのか判断つかない。

# ======================================================
# PROMPT SETTINGS
# ======================================================
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep

if [ "$(uname)" = "Darwin" ]; then
    source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    autoload -Uz compinit
    compinit
    eval "$(gh completion -s zsh)"
fi

if [ "$(uname)" = "Linux" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="fino"
    plugins=(
      zsh-autosuggestions
      zsh-syntax-highlighting
    )
    source $ZSH/oh-my-zsh.sh
fi

# ======================================================
# PATHや言語用設定
# ======================================================
if [ "$(uname)" = "Darwin" ]; then
    # brew
    export PATH="$PATH:/opt/homebrew/bin/"

    # Python
    export PATH="$PATH:/opt/homebrew/bin/python3"
    alias python='python3'
    alias pip='python -m pip'

    # Rust
    export PATH="$PATH:$CARGO_HOME/bin"

    # Go
    export PATH="$PATH:$HOME/work/go/bin"

    # Java
    PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    export JAVA_HOME=`/usr/libexec/java_home -v 11`
fi

if [ "$(uname)" = "Linux" ]; then
    export SHELL=/bin/zsh
    export PATH="$PATH:$HOME/.local/bin"
    alias python='python3'
fi

# C++ビルドコマンド
# AtCoderでの指定: https://atcoder.jp/contests/APG4b/rules?lang=ja
# -std=c++20 バージョン指定
# -I includeパス
# -Wall 警告オプションまとめ
# -Wextra その他の警告オプションまとめ
# -mtune=native マシン最適化
# -march=native マシン最適化
# -fconstexpr-depth=2147483647 コンパイル時の再帰回数
export CPP_BUILD_CMD="g++ -std=c++20 \
-I $HOME/git/dotfiles/conf/cpp \
-Wall \
-Wextra \
-mtune=native \
-march=native \
-fconstexpr-depth=2147483647 \
-o "

# -ftrapv 符号あり整数計算でover under flow
# -fsanitize-undefined-trap-on-error 未定義サニタイザ
# -fsanitize=address アドレスサニタイザ
export CPP_BUILD_CMD_SANITIZE="g++ -std=c++20 \
-I $HOME/git/dotfiles/conf/cpp \
-Wall \
-Wextra \
-mtune=native \
-march=native \
-fconstexpr-depth=2147483647 \
-ftrapv \
-fsanitize-undefined-trap-on-error \
-fsanitize=address \
-o "

# ======================================================
# 開発パーツ
# ======================================================
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

# 確認ダイアログ越しにコマンド実行
# confirm echo Hello World!
function confirm() {
    CMD=$@
    if type gum > /dev/null 2>&1; then
        gum confirm && eval $CMD || info 'cancel'
    else
        if [ -n "$ZSH_VERSION" ]; then
            read "input?Are you sure? (y/n):"
        else
            read -p "Are you sure? (y/n):" input
        fi
        if [ "$input" = "y" ]; then
            eval $CMD
        else
            info "cancel"
        fi
    fi
}

# 標準出力を出さずに、ロード中spinを表示
# spin 'loading...' sleep 3
function spin() {
    gum spin --title "$1" -- ${@:2}
}

# ======================================================
# ターミナル上での操作 alias等
# ======================================================
# vim
function v() {
    if [ ! -d ~/.vim/plugged ]; then
        curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim -c "PlugInstall"
    else
        vim -c "CocCommand explorer --no-focus --width 30" $@
    fi
}
# zoxide
if type zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
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
alias zv='zi && v'

# terminal ctrl
alias ..='cd ..'
alias rm='rm -i'
alias rmf='confirm rm -rf'
alias re='exec $SHELL -l'
alias q='exit'
function l() {
    if type eza > /dev/null 2>&1; then
        if [ "$(uname)" = "Darwin" ]; then
            eza -abghHliS --icons --git
        else
            eza -abghHliS
        fi
    else
        if [ "$(uname)" = "Darwin" ]; then
            ls -AFGlihrt --color=auto
        else
            ls -AFlihrt --color=auto
        fi
    fi
}
function tree() {
    if type eza > /dev/null 2>&1; then
        if [ "$(uname)" = "Darwin" ]; then
            eza -bghHliST --icons --git
        else
            eza -bghHliST
        fi
    else
        pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
    fi
}

# TUI
if type yazi > /dev/null 2>&1; then
    alias e='yazi'
fi
if type lazygit > /dev/null 2>&1; then
    alias g='lazygit'
fi
if type lazydocker > /dev/null 2>&1; then
    alias d='lazydocker'
fi
if type cmatrix > /dev/null 2>&1; then
    alias c='cmatrix'
fi

# バックiサーチをhistoryのfzfにする
function incremental_search_history() {
  selected=`history -E 0 | fzf --tac --height 75% --reverse --margin=0,1 | cut -b 24-`
  BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N incremental_search_history
bindkey "^r" incremental_search_history

# ======================================================
# Dev Tools
# ======================================================
function dev_tools_logo_python() {
    printf "\e[33m\n"
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
    printf "\e[m"
}

function dev_tools_python_localhost() {
    dev_tools_logo_python
    printf "\e[32m\n"
    echo "  _                       _  _                             _____    ______   ______   ______ ";
    echo " | |                     | || |                  _        / ___ \  / __   | / __   | / __   | ";
    echo " | |  ___    ____   ____ | || | _    ___    ___ | |_   _ ( (   ) )| | //| || | //| || | //| | ";
    echo " | | / _ \  / ___) / _  || || || \  / _ \  /___)|  _) (_) > > < < | |// | || |// | || |// | | ";
    echo " | || |_| |( (___ ( ( | || || | | || |_| ||___ || |__  _ ( (___) )|  /__| ||  /__| ||  /__| | ";
    echo " |_| \___/  \____) \_||_||_||_| |_| \___/ (___/  \___)(_) \_____/  \_____/  \_____/  \_____/ ";
    printf "\e[m"
    info 'input port'
    python -m http.server $(gum input --header='port' --value='8000')
}

function dev_tools_python_venv() {
    dev_tools_logo_python
    printf "\e[32m\n"
    echo "  _   _   ____  ____   _   _ ";
    echo " | | | | / _  )|  _ \ | | | | ";
    echo "  \ V / ( (/ / | | | | \ V / ";
    echo "   \_/   \____)|_| |_|  \_/ ";
    printf "\e[m"
    # vimspector debug設定を追加
    cp -f ~/git/dotfiles/conf/vim/.vimspector.json .
    spin 'Python venv activation' python -m venv venv
    . venv/bin/activate
}

function dev_tools_logo_cpp() {
    printf "\e[34m\n"
    echo "            .(XyyS&,             "
    echo "         .JyZZZZyZyyyn..         "
    echo "     ..dyyZZyyyZZyZZyZyyk-.      "
    echo "   .yyyZyZ0=!      _7XZZyyyW,    "
    echo "   dZZZyZ=            ?yQgMH#    "
    echo "   dyZyZ'    .dyyk.  .&HHHHH#    "
    echo "   dZyyr    dyZyyXQMHH@4HHYM#    "
    echo "   dZZy[   .yyQNMMHHHh,..&..K    "
    echo "   dyZZn    ?MNNNNMDTMHHHHHH#    "
    echo '   dyyZQa     ?""^     WMHHH#    '
    echo "   zQNNNMN,          .MNMNMM#    "
    echo '    THNMNNNMN&....(MNNNNMM#"     '
    echo "       ?YMNNNNMNNNNNNMMY=        "
    echo '          .TMNNNMNMM"            '
    echo '              7"""`              '
    printf "\e[m"
}

function dev_tools_cpp_setup() {
    dev_tools_logo_cpp
    printf "\e[32m\n"
    echo "               _ ";
    echo "   ___   ____ | |_   _   _  ____ ";
    echo "  /___) / _  )|  _) | | | ||  _ \ ";
    echo " |___ |( (/ / | |__ | |_| || | | | ";
    echo " (___/  \____) \___) \____|| ||_/ ";
    echo "                           |_| ";
    printf "\e[m"
    # gitignore
    cp -f ~/git/dotfiles/conf/cpp/cpp_gitignore .gitignore
    # LSP server用設定
    cp -f ~/git/dotfiles/conf/cpp/.clang-format .
    cp -f ~/git/dotfiles/conf/cpp/compile_flags.txt .
    # vimspector debug設定を追加
    cp -f ~/git/dotfiles/conf/vim/.vimspector.json .
}

function dev_tools_logo_atcoder() {
    echo '                                            .'
    echo '                                          .dN.'
    echo '                                       ..d@M#J#(,'
    echo '                                    vRMPMJNd#dbMG#(F'
    echo '                          (O.  U6..  WJNdPMJFMdFdb#`  .JU` .Zo'
    echo '                       .. +NM=(TB5.-^.BMDNdJbEddMd ,n.?T@3?MNm  ..'
    echo '                      .mg@_J~/?`.a-XNxvMMW9""TWMMF.NHa._ ?_,S.Tmg|'
    echo '                   .Js ,3,`..-XNHMT"= ...d"5Y"X+.. ?"8MNHHa.. (,b uZ..'
    echo '                  J"17"((dNMMB"^ ..JTYGJ7"^  ?"T&JT9QJ..?"TMNNHa,?727N'
    echo '                  .7    T"^..JT"GJv"=`             ?"4JJT9a.,?T"`  .7!'
    echo '                          M~JY"!     ....<.Zj+,(...     .7Ta_M'
    echo '              .JWkkWa,    d-F     .+;.ge.ga&.aa,ua+.g,     ,}#    .(Wkkkn,'
    echo '             .W9AaeVY=-.. J;b   .XH3dHHtdHHDJHHH(HHH(WH,   J(F  ..?T4agdTH-'
    echo '              6XkkkH=!    ,]d  .HHtdHHH.HHHbJHHH[WHHH(HHL  k.]    _7HkkkHJ:'
    echo '              JqkP?H_      N(; TYY?YYY9(YYYD?YYYt7YYY\YY9 .Fd!     .WPjqqh'
    echo '              .mmmH,``      d/b WHHJHH@NJHHH@dHHHFdHHHtHH#`.1#       `(dqqq]'
    echo '             ,gmmgghJQQVb  ,bq.,YY%7YYY(YYY$?YYY^TYYY(YY^ K.]  JUQmAJmmmmg%'
    echo '              ggggggggh,R   H,]  T#mTNNbWNN#dNN#(NN@(N@! .t#   d(Jgggggggg:'
    echo '             .@@@@@#"_JK4,  ,bX.   ?i,1g,jge.g2+g2i,?`   K.t  .ZW&,7W@@@@@h.'
    echo '         `..H@@@@@P   7 .H`  W/b        .^."?^(!        -1#   W, ?   T@@@@@Ma,`'
    echo '         dH@HHHM"       U\   .N,L        ..            .$d    .B`     ."MHHH@HN.'
    echo '    ....JMHHHHH@              ,N(p      .dH.d"77h.    .$J\              dHHHHHMU....'
    echo '   ` WHH#,7MHHM{               ,N,h     d^.W,        .^J^               .MHHM"_d#HN.'
    echo '    ,jH#Mo .MMW:                .W,4,  J\   Ta.-Y` .J(#                 .HMM- .M#MF!'
    echo '      .MN/ d@?M+                  7e(h.           .3.F                  .MDd# (MML`'
    echo '      .M4%  ?H, 7a,                .S,7a.       .Y.#^                .,"`.d=  ,PWe'
    echo '     .! ?     dN .N,                 (N,7a.   .Y(d=                 .d! d@     4 .!'
    echo '              .W` .!                   ?H,?GJ".d"                    ^  B'
    echo '                                         (SJ.#='
    echo '                        J             ....            .M:'
    echo '                       JUb     .   .#    (\            M~'
    echo '                      .\.M;  .W@"` M}       .y7"m. .J"7M~ .v74e ,M7B'
    echo '                     .F  ,N.  J]   M]       M)  JF M_  M~ d-     M`'
    echo '                    .W,  .db, Jh.   Th...J\ /N..Y` ?N-.Ma.-M&.> .M-'
    echo ""
    echo ""
}

function dev_tools_cpp_setup_atcoder() {
    dev_tools_cpp_setup
    dev_tools_python_venv
    dev_tools_logo_atcoder
    spin 'pip install --upgrade pip' pip install --upgrade pip
    spin 'pip install --upgrade setuptools' pip install --upgrade setuptools
    spin 'pip install online-judge-tools' pip install online-judge-tools
}

function solve() {
    # 書き捨てで解く
    SAND_DIR="$HOME/work/sandbox"
    if [ $# -eq 0 ]; then
        mkdir -p $SAND_DIR > /dev/null 2>&1
        cd $SAND_DIR
        dev_tools_cpp_setup_atcoder
        mkdir a > /dev/null 2>&1
        mkdir z > /dev/null 2>&1
        touch a/main.cpp z/main.cpp
        \rm -rf a/test z/test
        v z/main.cpp
        return
    fi

    # AtCoder コンテスト
    CONTEST_CODE=$1
    if [ "$(acc contest $CONTEST_CODE)" = "" ]; then
        error 'contest code is not found.'
        return
    fi
    AC_DIR="$HOME/git/contest"
    mkdir -p $AC_DIR > /dev/null 2>&1
    cd $AC_DIR
    dev_tools_cpp_setup_atcoder
    # atcoder-cliとojのセットアップ
    if ! type acc > /dev/null 2>&1; then
        npm install -g atcoder-cli
    fi
    acc check-oj
    oj login https://atcoder.jp
    acc login
    acc config default-task-choice all
    acc config default-test-dirname-format test
    acc new $CONTEST_CODE
    cd $CONTEST_CODE
    # main.cppを作成
    dirs=(`find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2`)
    for v in ${dirs[@]}; do
        info "touch file :\e[32m$v/main.cpp"
        touch "$v/main.cpp"
    done
    v
}

function cpp_exe() {
    TARGET=$(find . -name 'main.cpp' | gum choose)
    RUN_MODE=$(gum choose "normal" "sanitize")
    CMD=$CPP_BUILD_CMD
    if [ $RUN_MODE = "sanitize" ]; then
        CMD=$CPP_BUILD_CMD_SANITIZE
    fi
    echo "==================================="
    info "build :$TARGET processing..."
    eval "$CMD _cpp_tmp $TARGET 2>&1"
    info "build :$TARGET complete."
    echo "==================================="
    printf "\e[33m-----------------------------\e[m\n"
    ./_cpp_tmp
    res=$?
    printf "\e[33m-----------------------------\e[m\n"
    if [ $res -eq 0 ]; then
        info "exit code:$res"
    else
        error "exit code:$res."
    fi
}

# ======================================================
# Tool Box
# ======================================================
# ツール系のカスタムしたコマンドをリストで選択し実行
export TOOL_BOX=$(cat << "EOF"
[
    {
        "name": "[ Python] localhost",
        "cmd": "dev_tools_python_localhost"
    },
    {
        "name": "[ Python] venv",
        "cmd": "dev_tools_python_venv"
    },
    {
        "name": "[ scp] termscp",
        "cmd": "termscp"
    },
    {
        "name": "[ DB] gobang",
        "cmd": "gobang"
    },
    {
        "name": "[ DB] edit connection",
        "cmd": "cd ~/git/dotfiles && v conf/gobang/config.toml"
    },
    {
        "name": "[ Mac] application",
        "cmd": "find /Applications -maxdepth 1 -name '*.app' | fzf | xargs -I {} open '{}'"
    },
    {
        "name": "[ Mac] finder",
        "cmd": "open ."
    },
    {
        "name": "[ clock] show clock",
        "cmd": "tty-clock -sc -C2"
    },
    {
        "name": "[ gif] convert mov -> gif",
        "cmd": "ffmpeg -i $(ls -A | gum choose) -r 10 $(gum input --prompt 'e.g.) test.gif: ')"
    },
    {
        "name": "[ devbox] devbox-ctrl",
        "cmd": "devbox-ctrl"
    },
    {
        "name": "[ zoxide] ls",
        "cmd": "zoxide query -ls"
    },
    {
        "name": "[ zoxide] rm filename",
        "cmd": "(){zoxide remove $(gum input --prompt \"del: \")}"
    },
    {
        "name": "[ x86 brew]",
        "cmd": "arch -x86_64 /usr/local/bin/brew"
    },
    {
        "name": "[cancel]",
        "cmd": "info cancel"
    }
]
EOF
)

t() {
    printf "\e[32m\n"
    echo "                      _  _ ";
    echo "  _                  | || | ";
    echo " | |_    ___    ___  | || | _    ___   _   _ ";
    echo " |  _)  / _ \  / _ \ | || || \  / _ \ ( \ / ) ";
    echo " | |__ | |_| || |_| || || |_) )| |_| | ) X ( ";
    echo "  \___) \___/  \___/ |_||____/  \___/ (_/ \_) ";
    printf "\e[m"
    info "Choose Tool"
    IFS=$'\n'
    TOOLS=($(echo $TOOL_BOX | jq '.[].name'))
    IFS=' '
    LEN=$(expr ${#TOOLS[@]} + 3)
    TARGET="[cancel]"
    TARGET=$(gum choose --height $LEN --cursor="❯ " --header="Choose" $TOOLS)
    if [ -z "$TARGET" ]; then
        info "Cancel"
        return
    fi
    CMD=$(echo $TOOL_BOX | jq ".[] | select(.name == $TARGET) | .cmd")
    CMD="${CMD:1:-1}" # 前後のダブルクォーとを取ってevalに渡す
    confirm $CMD
}

# ========================================================
# ========================================================
# ||          Dev Container for SandBox                 ||
# ========================================================
# ========================================================

# 開発用のsandboxコンテナを起動する
# 現在フォルダで、なければdevbox-XXXフォルダを作成し
# dotfile/conf/devboxの設定の最新を反映して、コンテナ起動する
devbox() {
    if [ "$(uname)" = "Linux" ]; then
        warn "Already in Dev Container Box"
        return
    fi
    printf "\e[36m\n"
    echo ""
    echo "                       .."
    echo "                      (NNNN!"
    echo "                      (NMNM_"
    echo "           (J..J-..JJ,.JJ..."
    echo "           -NNMM<MNNMF(NNNN_        .gx-"
    echo "           (MMMM!MMMM5(MMMM!        dNNNx         "
    echo "      MMNM@-MNNM<MNMNF(MNNN_NNNMF  .MNNNN&(-. . "
    echo "      MNNN@(NMNN:MNNNF(NNMN<MNNNF  .NNMNNNNNNNN;  "
    echo "    .-???<!.?<<? <<??:(??<< ??<<!.-.(NNMNNNNNM9."
    echo "  .NNMNNMNMNNMNNNNNNMNNNNNNNNNMNNNNMNNMNMMH =_    "
    echo "  ,NMNMNNMNMNNMNMNMNNNNMNNMNNNNNMNNMNNN@  .     "
    echo "  ,NNNNMNNNNNMNNNMNNMNNMNMNNMMNNMNNMNN@ .         "
    echo "   qMNMNMNMNNMNMNNMNNMNNNNNNMNNMNNMNMD.           "
    echo "    WNNMNNMNNNMNNNMNNNMNMMNNNNMNNMN#!"
    echo "     TNNMNNMNMNNMNNMNNNMNNMNMNNNM@!"
    echo "      .TNMNNMNNMNNMNMNNNNNNMNMY="
    echo "         ? MMNMNNMNNNMMMMW = "
    echo "                 ~~  "
    echo ""
    printf "\e[m"
    printf "\e[32m\n"
    echo "      _                                                    _ ";
    echo "     | |                                      _           (_) ";
    echo "   _ | |  ____  _   _     ____   ___   ____  | |_    ____  _  ____    ____   ____ ";
    echo "  / || | / _  )| | | |   / ___) / _ \ |  _ \ |  _)  / _  || ||  _ \  / _  ) / ___) ";
    echo " ( (_| |( (/ /  \ V /   ( (___ | |_| || | | || |__ ( ( | || || | | |( (/ / | | ";
    echo "  \____| \____)  \_/     \____) \___/ |_| |_| \___) \_||_||_||_| |_| \____)|_| ";
    echo "   ___                                          _  _ ";
    echo "  / __)                                        | || | ";
    echo " | |__   ___    ____     ___   ____  ____    _ | || | _    ___   _   _ ";
    echo " |  __) / _ \  / ___)   /___) / _  ||  _ \  / || || || \  / _ \ ( \ / ) ";
    echo " | |   | |_| || |      |___ |( ( | || | | |( (_| || |_) )| |_| | ) X ( ";
    echo " |_|    \___/ |_|      (___/  \_||_||_| |_| \____||____/  \___/ (_/ \_) ";
    printf "\e[m"

    # エンジンが動いてないなら起動
    APP_LIST=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)')
    if [[ ! $APP_LIST =~ "OrbStack" ]]; then
        info "START OrbStack"
        open -g /Applications/OrbStack.app
        sleep 0.5
        genact -s 10 --exit-after-modules 1 -m botnet
        genact -s 10 --exit-after-modules 1 -m bruteforce
    fi

    DEVBOX_DOTFILES_PATH=~/git/dotfiles/conf/devbox
    DOCKERFILE=${DEVBOX_DOTFILES_PATH}/Dockerfile
    COMPOSE_FILE=${DEVBOX_DOTFILES_PATH}/docker-compose.yml
    IGNORE_FILE=${DEVBOX_DOTFILES_PATH}/devbox_gitignore.txt

    # .devbox-XXXがない場合は作成し、設定をDL
    if ! ls -d .devbox*/ > /dev/null 2>&1; then
        # 手動でイメージを削除すると、ここでの重複回避の対象に引けないため
        # 再度ビルドしたときなどに重複する恐れがある
        # 重複した場合はあとガチで、前の同名コンテナは停止するだけ。
        # 手動でけさなきゃいい！
        info "[INITIATION] CREATE DIR \e[32m.devbox-XXX"
        info "[INITIATION] Please \e[31mDO NOT DELETE \e[34mdocker image startsWith \e[32mdevbox-"

        # 現在の位置に.devbox-XXXを作成
        # docker-composeは自動で「フォルダ名-サービス名」でコンテナ命名する
        # .devbox-XXX/docker-compose.ymlならdevbox-XXX-sandbox
        CONTAINERS=$(docker images --format='{{.Repository}}')
        info "[INITIATION] CONTAINERS: \e[37m$CONTAINERS"
        S=".devbox-$RANDOM"
        while [[ $CONTAINERS =~ $S ]]; do
            S=".devbox-$RANDOM"
        done
        info "[INITIATION] create: \e[32m$S"
        mkdir $S

        # コンテナ設定を取得
        info " >> install Dockerfile docker-compose.yml from dotfiles"
        cp $DOCKERFILE $S
        cp $COMPOSE_FILE $S

        # 作業用volumeを作成
        info " >> create work volume"
        mkdir -p $S/vol

        # gitignoreを追加、devbox配下に配置しvol以外を無視する
        info " >> add .gitignore"
        cp $IGNORE_FILE $S/.gitignore

        info "[INITIATION] initiation completed"
        echo
    fi

    # コンテナ設定のチェックサムを取得
    info "checking checksum from dotfiles"
    DOCKERFILE_MD5=$(md5 $DOCKERFILE | cut -d "=" -f 2)
    DOCKER_COMPOSE_MD5=$(md5 $COMPOSE_FILE | cut -d "=" -f 2)

    # コンテナ設定を確認
    S=$(ls -d .devbox*/)
    cd $S

    # 現在のコンテナ設定のチェックサムを取得
    CURRENT_DOCKERFILE_MD5=$(md5 Dockerfile | cut -d "=" -f 2)
    CURRENT_DOCKER_COMPOSE_MD5=$(md5 docker-compose.yml | cut -d "=" -f 2)

    echo "dockerfile"
    echo $DOCKERFILE_MD5
    echo $CURRENT_DOCKERFILE_MD5
    echo "docker-compose"
    echo $DOCKER_COMPOSE_MD5
    echo $CURRENT_DOCKER_COMPOSE_MD5

    # 新規作成でない場合で、元ファイルに更新があった場合に反映するため再ビルド
    if [ "$1" = "re"  ] || [ $DOCKERFILE_MD5 != $CURRENT_DOCKERFILE_MD5 ] || [ $DOCKER_COMPOSE_MD5 != $CURRENT_DOCKER_COMPOSE_MD5 ]; then
        info "[!!] Update was detected"

        # 最新にする
        cp $DOCKERFILE .
        cp $COMPOSE_FILE .
        info "Build Docker image"

        # オプション指定の場合はキャッシュを見ない
        if [ "$1" = "re"  ]; then
            docker-compose build --no-cache
        else
            docker-compose build
        fi
    fi

    # クリップボード共有用
    \rm -rf shared-register && mkdir shared-register && cd shared-register
    echo $(pbpaste) > clip
    echo $(ls -l clip) > tmp
    cd ..
    watch_shared_clipboard() {
        while [ 1 ]; do
            # フォルダが消えたらループ終了
            if [ ! -d shared-register ]; then
                return
            fi
            LATEST=$(cat shared-register/tmp)
            CURRENT=$(cd shared-register && ls -l clip)
            if [[ "$LATEST" != "$CURRENT" ]]; then
                pbcopy < shared-register/clip
                echo $CURRENT > shared-register/tmp
            fi
            sleep 1
        done
    }
    watch_shared_clipboard & # バックグラウンドで実行

    # 起動
    info "Start Dev Container for Sandbox"
    docker-compose up -d

    # ログイン
    info "Login"
    docker-compose exec -it -w /work sandbox zsh

    # 抜けたときの処理
    \rm -rf shared-register
    cd ..
    info "Welcome back to HOST PC"
    exec $SHELL -l
}

# devbox関連の操作コマンド一覧
devbox-ctrl() {
    if [ "$(uname)" = "Linux" ]; then
        warn "Already in Dev Container Box"
        return
    fi
    LIST=(
        "[ ] devbox start"
        "[ file](on devbox) cp file into devbox/vol"
        "[ file](on devbox) cp ~/Downloads file into devbox/vol"
        "[  crush](on devbox) current devbox"
        "[  crush] all devbox"
        "[cancel]"
    )
    info "Choose devbox Ctrl"
    LEN=$(expr ${#LIST[@]} + 3)
    # TODO ここ修正
    #gum choose --height $LEN --cursor="❯ " --header="Choose tool:" $LIST
    TARGET=$(gum choose --height $LEN --cursor="❯ " --header="Choose tool:" $LIST)
    case $TARGET in
        "[ ] devbox start")
            CMD="devbox"
            ;;
        "[ file](on devbox) cp file into devbox/vol")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                error "No devbox"
                return
            fi
            ls -AF | gum choose --no-limit --height 20 --cursor='❯ ' --header='current file / dir:' \
                | xargs -I {} cp -R {} .devbox-**/vol \
                && info 'cp to devbox/vol'
            return
            #CMD='info "Choose Current file / dir"'
            #CMD="$CMD && ls -AF | gum choose --no-limit --height 20 --cursor='❯ ' --header='current file / dir:'"
            #CMD="$CMD | xargs -I {} cp -R {} .devbox-**/vol"
            #CMD="$CMD && info 'cp to devbox/vol'"
            ;;
        "[ file](on devbox) cp ~/Downloads file into devbox/vol")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                error "No devbox"
                return
            fi
            CMD='info "Choose DL file"'
            CMD="$CMD && ls -AF ~/Downloads | grep -v / | gum choose --no-limit --cursor='❯ ' --header='DL file:'"
            CMD="$CMD | xargs -I {} cp ~/Downloads/{} .devbox-**/vol"
            CMD="$CMD && info 'cp DL files to devbox/vol'"
            ;;
        "[  crush](on devbox) current devbox")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                error "No devbox"
                return
            fi
            S=$(ls -d .devbox*/ | sed 's/^\.//; s/\/$//')
            STOP='docker stop $(docker ps -aq -f name='$S')'
            RM='docker rm $(docker ps -aq -f name='$S')'
            DELNET='docker network rm $(docker network ls --format '\''{{.Name}}'\'' | grep '$S')'
            RMI='docker rmi $(docker images --format '\''{{.Repository}}'\'' | grep '$S')'
            CMD="gum spin --title 'stop a devbox container...' -- $STOP"
            CMD="$CMD && info 'stop a devbox'"
            CMD="$CMD && gum spin --title 'delete a devbox container...' -- $RM"
            CMD="$CMD && info 'delete a devbox'"
            CMD="$CMD && gum spin --title 'delete a devbox network...' -- $DELNET"
            CMD="$CMD && info 'delete a devbox network'"
            CMD="$CMD && gum spin --title 'delete a image...' -- $RMI"
            CMD="$CMD && info 'delete a devbox image'"
            CMD="$CMD && rm -rf .devbox*/"
            CMD="$CMD && info 'delete .devbox directory'"
            ;;
        "[  crush] all devbox")
            STOP='docker stop $(docker ps -aq -f name=^devbox)'
            RM='docker rm $(docker ps -aq -f name=^devbox)'
            DELNET='docker network rm $(docker network ls --format '\''{{.Name}}'\'' | grep devbox)'
            RMI='docker rmi $(docker images --format '\''{{.Repository}}'\'' | grep devbox)'
            CMD="gum spin --title 'stop all devbox containers...' -- $STOP"
            CMD="$CMD && info 'stop all devbox'"
            CMD="$CMD && gum spin --title 'delete all devbox containers...' -- $RM"
            CMD="$CMD && info 'delete all devbox'"
            CMD="$CMD && gum spin --title 'delete all devbox networks...' -- $DELNET"
            CMD="$CMD && info 'delete all devbox networks'"
            CMD="$CMD && gum spin --title 'delete all devbox images...' -- $RMI"
            CMD="$CMD && info 'delete all devbox images'"
            CMD="$CMD && info '\e[31m remain .devbox directories'"
            ;;
        *)
            info "Skipped"
            return
            ;;
    esac
    confirm $CMD
}

# ======================================================
# END
# ======================================================
clear
info "Load ~/.zshrc"
if [ "$(uname)" = "Darwin" ]; then
    if type fastfetch > /dev/null 2>&1; then
        fastfetch
    fi
fi
if [ "$(uname)" = "Linux" ]; then
    if type screenfetch > /dev/null 2>&1; then
        screenfetch
    fi
fi

