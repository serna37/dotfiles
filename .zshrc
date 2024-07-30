# ======================================================
# OS HANDLING
# ======================================================
OS_NAME=$(uname -s)
IS_MAC=false
IS_DOCKER=false

if [ "$OS_NAME" = "Darwin" ]; then
  IS_MAC=true
elif [ "$OS_NAME" = "Linux" ]; then
  IS_DOCKER=true
fi

# ======================================================
# PROMPT SETTINGS
# ======================================================
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
if "$IS_MAC"; then
    source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

if "$IS_DOCKER"; then
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="fino"
    plugins=(
      zsh-autosuggestions
      zsh-syntax-highlighting
    )
    source $ZSH/oh-my-zsh.sh
fi

# ======================================================
# ALIAS
# ======================================================
if "$IS_MAC"; then
    # vim
    alias v='vim -c "CocCommand explorer --no-focus --width 30"'
    alias zv='zi && v'

    # TUI
    alias e='yazi'
    alias d='lazydocker'
    alias g='lazygit'

    # dev tool
    alias t='tool-box'
    alias dev='devbox'

    # terminal ctrl
    alias ll='ls -AFGlihrt --color=auto'
    alias l='eza -abghHliS --icons --git'
    alias tree='eza -bghHliST --icons --git'
    alias ..='cd ..'
    alias rm='rm -i'
    alias rmf="gum confirm && rm -rf"
    alias re='exec $SHELL -l'
    alias q='exit'
    alias c='cmatrix'
fi

if "$IS_DOCKER"; then
    # vim
    alias v='vim -c "CocCommand explorer --no-focus --width 30"'
    alias zv='zi && v'

    # dev tool
    alias t='tool-box'
    alias dev='devbox'

    # terminal ctrl
    alias ll='ls -AFGlihrt --color=auto'
    alias l='eza -abghHliS'
    alias tree='eza -bghHliST'
    alias ..='cd ..'
    alias rm='rm -i'
    alias rmf="gum confirm && rm -rf"
    alias re='exec /bin/zsh -l'
    alias q='exit'
fi

# ======================================================
# PATH
# ======================================================
if "$IS_MAC"; then
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

if "$IS_DOCKER"; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# ======================================================
# Utility
# ======================================================
# 情報ログ形式でecho
# echo_info "Hello World!"
# echo_info "test \e[33m yellw"  途中から色を変えることも可能
echo_info() {
    echo -e "\e[32m[\e[34mINFO\e[32m] \e[34m$1\e[m"
}

# 確認ダイアログ
# confirm "echo Hello World!" "cancelled"
confirm() {
    if command -v gum > /dev/null 2>&1; then
        gum confirm && eval $1 || echo_info $2
    else
        read -p "Are you sure? (y/n):" input
        if [ "$input" == "y" ]; then
            eval $1
        elif [ "$input" == "n" ]; then
            echo_info $2
        else
            echo_info $2
        fi
    fi
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

# 長めのハッキングアニメーションを表示
loading_long() {
    if command -v genact > /dev/null 2>&1; then
        genact -s 10 --exit-after-modules 1 -m botnet
        genact -s 10 --exit-after-modules 1 -m bruteforce
    else
        sleep 3
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

# docker ロゴ
logo_docker() {
    echo -e "\e[36m"
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
    echo -e "\e[m"
}

# docker dev用コンテナ起動ロゴ
logo_dev_container() {
    echo -e "\e[32m"
    echo "      _                                                    _ ";
    echo "     | |                                      _           (_) ";
    echo "   _ | |  ____  _   _     ____   ___   ____  | |_    ____  _  ____    ____   ____ ";
    echo "  / || | / _  )| | | |   / ___) / _ \ |  _ \ |  _)  / _  || ||  _ \  / _  ) / ___) ";
    echo " ( (_| |( (/ /  \ V /   ( (___ | |_| || | | || |__ ( ( | || || | | |( (/ / | | ";
    echo "  \____| \____)  \_/     \____) \___/ |_| |_| \___) \_||_||_||_| |_| \____)|_| ";
    echo -e "\e[m"
}
logo_for_sandbox() {
    echo -e "\e[32m"
    echo "   ___                                          _  _ ";
    echo "  / __)                                        | || | ";
    echo " | |__   ___    ____     ___   ____  ____    _ | || | _    ___   _   _ ";
    echo " |  __) / _ \  / ___)   /___) / _  ||  _ \  / || || || \  / _ \ ( \ / ) ";
    echo " | |   | |_| || |      |___ |( ( | || | | |( (_| || |_) )| |_| | ) X ( ";
    echo " |_|    \___/ |_|      (___/  \_||_||_| |_| \____||____/  \___/ (_/ \_) ";
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

# ========================================================
# ========================================================
# ||          Dev Container for SandBox                 ||
# ========================================================
# ========================================================

# 開発用のsandboxコンテナを起動する
# 現在フォルダで、なければdevbox-XXXフォルダを作成し
# dotfile/conf/devboxの設定の最新を反映して、コンテナ起動する
devbox() {
    if "$IS_DOCKER"; then
        echo_info "Already in Dev Container Box"
        return
    fi
    logo_docker
    logo_dev_container
    logo_for_sandbox

    # エンジンが動いてないなら起動
    APP_LIST=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)')
    if [[ ! $APP_LIST =~ "OrbStack" ]]; then
        echo_info "START OrbStack"
        open -g /Applications/OrbStack.app
        sleep 0.5
        loading_long
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
        echo_info "[INITIATION] CREATE DIR \e[32m.devbox-XXX"
        echo_info "[INITIATION] Please \e[31mDO NOT DELETE \e[34mdocker image startsWith \e[32mdevbox-"
        loading 0.5 "Initiating..."

        # 現在の位置に.devbox-XXXを作成
        # docker-composeは自動で「フォルダ名-サービス名」でコンテナ命名する
        # .devbox-XXX/docker-compose.ymlならdevbox-XXX-sandbox
        CONTAINERS=$(docker images --format='{{.Repository}}')
        echo_info "[INITIATION] CONTAINERS: \e[37m$CONTAINERS"
        S=".devbox-$RANDOM"
        while [[ $CONTAINERS =~ $S ]]; do
            S=".devbox-$RANDOM"
        done
        echo_info "[INITIATION] create: \e[32m$S"
        mkdir $S
        loading 0.5 "creating $S ..."

        # コンテナ設定を取得
        echo_info " >> install Dockerfile docker-compose.yml from dotfiles"
        cp $DOCKERFILE $S
        cp $COMPOSE_FILE $S

        # 作業用volumeを作成
        echo_info " >> create work volume"
        mkdir -p $S/vol

        # gitignoreを追記
        echo_info " >> add .gitignore"
        cat $IGNORE_FILE >> .gitignore

        loading 1 "setup profiles..."
        echo_info "[INITIATION] initiation completed"
        echo
    fi

    # コンテナ設定のチェックサムを取得
    echo_info "checking checksum from dotfiles"
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

    loading 0.5 "checking..."

    # 新規作成でない場合で、元ファイルに更新があった場合に反映するため再ビルド
    if [ "$1" = "re"  ] || [ $DOCKERFILE_MD5 != $CURRENT_DOCKERFILE_MD5 ] || [ $DOCKER_COMPOSE_MD5 != $CURRENT_DOCKER_COMPOSE_MD5 ]; then
        echo_info "[!!] Update was detected"
        loading 1 "Loading..."

        # 最新にする
        cp $DOCKERFILE .
        cp $COMPOSE_FILE .
        loading 1 "ready to build docker..."
        echo_info "Build Docker image"

        # オプション指定の場合はキャッシュを見ない
        if [ "$1" = "re"  ]; then
            docker-compose build --no-cache
        else
            docker-compose build
        fi
    fi

    # 起動してログイン
    echo_info "Start Dev Container for Sandbox"
    docker-compose up -d
    echo_info "Login"
    loading 0.5 "ready to login..."
    docker-compose exec -it -w /work sandbox zsh

    # 抜けたときに元のフォルダに戻っておく
    cd ..
    echo_info "Welcome back to HOST PC"
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
        "[ GitHub] gh-ctrl"
        "[ devbox] devbox-ctrl"
        "[ ini] initiation"
        "[ exe] exe C++ file"
        "[ venv]"
        "[ server] localhost 8000"
        "[ app] open application"
        "[ finder] open ."
        "[ DB] gobang"
        "[ DB] edit connection"
        "[ SCP] termscp"
        "[ clock] show clock"
        "[ gif] convert mov -> gif"
        "[ fzf] fzf"
        "[ zoxide] ls"
        "[ zoxide] rm filename"
        "[ x86 brew]"
        "[cancel]"
    )
    echo_info "Choose tool"
    LEN=$(expr ${#LIST[@]} + 3)
    TARGET=$(gum choose --height $LEN $LIST)
    case $TARGET in
        "[ GitHub] gh-ctrl")
            gh-ctrl
            return
            ;;
        "[ devbox] devbox-ctrl")
            devbox-ctrl
            return
            ;;
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
        "[ app] open application")
            CMD='open "$(\fd -t d -d 1 . /Applications | \fzf)"'
            ;;
        "[ finder] open .")
            CMD='open .'
            ;;
        "[ DB] gobang")
            CMD='gobang'
            ;;
        "[ DB] edit connection")
            CMD='cd ~/git/dotfiles && v conf/gobang/config.toml'
            ;;
        "[ SCP] termscp")
            CMD='termscp'
            ;;
        "[ clock] show clock")
            CMD='tty-clock -sc -C2'
            ;;
        "[ gif] convert mov -> gif")
            FROM=$(ls -A | gum choose)
            TO=$(gum input --prompt "e.g.) test.gif: ")
            CMD="ffmpeg -i $FROM -r 10 $TO"
            ;;
        "[ fzf] fzf")
            CMD="fzf --preview 'bat -n --color=always {}'"
            ;;
        "[ zoxide] ls")
            CMD='zoxide query -ls'
            ;;
        "[ zoxide] rm filename")
            TO=$(gum input --prompt "del: ")
            CMD="(){zoxide remove $TO}"
            ;;
        "[ x86 brew]")
            CMD='arch -x86_64 /usr/local/bin/brew'
            ;;
        *)
            echo_info "Skipped"
            return
            ;;
    esac
    confirm $CMD "Skipped"
}

# devbox関連の操作コマンド一覧
devbox-ctrl() {
    if "$IS_DOCKER"; then
        echo_info "Already in Dev Container Box"
        return
    fi
    LIST=(
        "[ ] devbox start"
        "[ file](on devbox) cp file into devbox/vol"
        "[ file](on devbox) cp DL file into devbox/vol"
        "[ crush](on devbox) current devbox"
        "[ crush] all devbox"
        "[cancel]"
    )
    echo_info "Choose devbox Ctrl"
    LEN=$(expr ${#LIST[@]} + 3)
    TARGET=$(gum choose --height $LEN $LIST)
    case $TARGET in
        "[ ] devbox start")
            CMD="devbox"
            ;;
        "[ file](on devbox) cp file into devbox/vol")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                echo_info "No devbox"
                return
            fi
            CMD='echo_info "Choose Current file / dir"'
            CMD="$CMD && ls -AF | gum choose --no-limit --height 20"
            CMD="$CMD | xargs -I {} cp -R {} .devbox-**/vol"
            CMD="$CMD && echo_info 'cp to devbox/vol'"
            ;;
        "[ file](on devbox) cp DL file into devbox/vol")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                echo_info "No devbox"
                return
            fi
            CMD='echo_info "Choose DL file"'
            CMD="$CMD && ls -AF ~/Downloads | grep -v / | gum choose --no-limit"
            CMD="$CMD | xargs -I {} cp ~/Downloads/{} .devbox-**/vol"
            CMD="$CMD && echo_info 'cp DL files to devbox/vol'"
            ;;
        "[ crush](on devbox) current devbox")
            if ! ls -d .devbox*/ > /dev/null 2>&1; then
                echo_info "No devbox"
                return
            fi
            S=$(ls -d .devbox*/ | sed 's/^\.//; s/\/$//')
            STOP='docker stop $(docker ps -aq -f name='$S')'
            RM='docker rm $(docker ps -aq -f name='$S')'
            DELNET='docker network rm $(docker network ls --format '\''{{.Name}}'\'' | grep '$S')'
            RMI='docker rmi $(docker images --format '\''{{.Repository}}'\'' | grep '$S')'
            CMD="gum spin --title 'stop a devbox container...' -- $STOP"
            CMD="$CMD && echo_info 'stop a devbox'"
            CMD="$CMD && gum spin --title 'delete a devbox container...' -- $RM"
            CMD="$CMD && echo_info 'delete a devbox'"
            CMD="$CMD && gum spin --title 'delete a devbox network...' -- $DELNET"
            CMD="$CMD && echo_info 'delete a devbox network'"
            CMD="$CMD && gum spin --title 'delete a image...' -- $RMI"
            CMD="$CMD && echo_info 'delete a devbox image'"
            CMD="$CMD && rm -rf .devbox*/"
            CMD="$CMD && echo_info 'delete .devbox directory'"
            ;;
        "[ crush] all devbox")
            STOP='docker stop $(docker ps -aq -f name=^devbox)'
            RM='docker rm $(docker ps -aq -f name=^devbox)'
            DELNET='docker network rm $(docker network ls --format '\''{{.Name}}'\'' | grep devbox)'
            RMI='docker rmi $(docker images --format '\''{{.Repository}}'\'' | grep devbox)'
            CMD="gum spin --title 'stop all devbox containers...' -- $STOP"
            CMD="$CMD && echo_info 'stop all devbox'"
            CMD="$CMD && gum spin --title 'delete all devbox containers...' -- $RM"
            CMD="$CMD && echo_info 'delete all devbox'"
            CMD="$CMD && gum spin --title 'delete all devbox networks...' -- $DELNET"
            CMD="$CMD && echo_info 'delete all devbox networks'"
            CMD="$CMD && gum spin --title 'delete all devbox images...' -- $RMI"
            CMD="$CMD && echo_info 'delete all devbox images'"
            CMD="$CMD && echo_info '\e[31m remain .devbox directories'"
            ;;
        *)
            echo_info "Skipped"
            return
            ;;
    esac
    confirm $CMD "Skipped"
}

# GitHub CLIでのカスタムしたコマンドを一覧で選択
gh-ctrl() {
    if "$IS_DOCKER"; then
        echo_info "Don't allow to use GitHub CLI in Dev Container Box"
        return
    fi
    if [ ! -d ~/git/task ]; then
        cd ~/git && git clone https://github.com/serna37/task
    fi
    LIST=(
        "Daily Algo v1"
        "Daily Algo v2"
        "Daily Algo v3"
        "Daily Algo POWER"
        "Daily Hacking"
        "PR develop <- feature"
        "PR release <- develop"
        "PR master  <- release"
        "[cancel]"
    )
    echo_info "Choose GitHub Ctrl"
    LEN=$(expr ${#LIST[@]} + 3)
    TARGET=$(gum choose --height $LEN $LIST)
    case $TARGET in
        "Daily Algo v1")
            CMD='cd ~/git/task && gh issue view 49 && gh issue close 49'
            ;;
        "Daily Algo v2")
            CMD='cd ~/git/task && gh issue view 172 && gh issue close 172'
            ;;
        "Daily Algo v3")
            CMD='cd ~/git/task && gh issue view 177 && gh issue close 177'
            ;;
        "Daily Algo POWER")
            CMD='cd ~/git/task && gh issue view 198 && gh issue close 198'
            ;;
        "Daily Hacking")
            CMD='cd ~/git/task && gh issue view 57 && gh issue close 57'
            ;;
        "PR develop <- feature")
            CMD='gh pr create --base develop --head $(git branch --contains | cut -d " " -f 2) --title "modify" --body ""'
            ;;
        "PR release <- develop")
            CMD='gh pr create --base release --head develop --title "Publish" --body ""'
            ;;
        "PR master  <- release")
            CMD='gh pr create --base master --head release --title "Publish" --body ""'
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
    # gitignore
    cat ~/git/dotfiles/conf/cpp/cpp_gitignore >> ./.gitignore
    # LSP server用設定
    cp ~/git/dotfiles/conf/cpp/.clang-format .
    cp ~/git/dotfiles/conf/cpp/compile_flags.txt .
    # vimspector debug設定を追加
    cp -f ~/git/dotfiles/conf/vim/.vimspector.json .
}

# C++ビルドコマンド
export CC_BUILD_CMD="g++ -std=c++20 -I $HOME/git/dotfiles/conf/cpp -Wall -Wextra -mtune=native -march=native -fconstexpr-depth=2147483647 -ftrapv -fsanitize-undefined-trap-on-error -o "

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

    # 引数が問題URLの場合、単一で解く
    if [[ $1 == https://* ]]; then
        mkdir -p $SAND_DIR && cd $SAND_DIR
        cpp_ini
        mkdir a && touch a/main.cpp
        mkdir z && touch z/main.cpp
        rm -rf a/test z/test
        cd z && oj d $1
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
    dirs=(`find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2`)
    for v in ${dirs[@]}; do
        echo_info "touch file :\e[32m$v/$file_name"
        touch "$v/$file_name"
    done
    v
}

# ======================================================
# END
# ======================================================
echo_info "Load ~/.zshrc"

