clear

# ====================================
# プロンプト設定
# ====================================
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep

# zshの補完
autoload -Uz compinit
compinit

# シンタックスハイライト
[[ ! -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && brew install zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# コマンド補完 →キーで補完する
[[ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 外観
[[ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]] && brew install powerlevel10k
source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================
# カスタムコマンド・ツール
# ====================================

type zoxide > /dev/null && eval "$(zoxide init zsh)"
type mise > /dev/null && eval "$(mise activate zsh)"

# fzf-previewのためにripgrepが必要
type rg > /dev/null || brew install ripgrep

export _ZO_FZF_OPTS='
--no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
--prompt="❯ "
--color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
--color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
--color prompt:#87afff,pointer:#ff5189,marker:#f09479
--preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'

alias vim='export VIM_PLUGIN_ENABLE=0 && \vim'
alias v='export VIM_PLUGIN_ENABLE=1 && \vim'
alias z='type zoxide > /dev/null 2>&1 || brew install zoxide; eval "$(zoxide init zsh)"; type eza > /dev/null 2>&1 || brew install eza; type fzf > /dev/null 2>&1 || brew install fzf; type bat > /dev/null 2>&1 || brew install bat; zi'
alias e='type yazi > /dev/null 2>&1 || brew install yazi; yazi'
alias l='type eza > /dev/null 2>&1 || brew install eza; eza -abghHliS --icons --git'
alias g='type lazygit > /dev/null 2>&1 || brew install lazygit; lazygit'
alias dev='type mise > /dev/null 2>&1 || brew install mise; eval "$(mise activate zsh)"; mise run'

alias rm='rm -i'
alias re='exec $SHELL -l'
alias q='exit'


# ====================================
# 設定ファイルの書き出し
# ====================================

# vim コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cat - << "EOF" > ~/.vim/after/plugin/common-settings.vim
au FileType * setlocal formatoptions-=ro
EOF

# vim coc.json
cat - << "EOF" > ~/.vim/coc-settings.json
{
    "snippets.priority": 10000,
    "explorer.icon.enableNerdfont": true,
    "explorer.file.showHiddenFiles": true,
    "inlayHint.enable": false,
    "clangd.arguments": [
        "--header-insertion=never"
    ],
    "python.formatting.provider": "yapf",
    "snippets.ultisnips.pythonPrompt": false
}
EOF

# yaziの設定
mkdir -p ~/.config/yazi
cat - << "EOF" > ~/.config/yazi/yazi.toml
[manager]
show_hidden = true
EOF

# git設定
cat - << "EOF" > ~/.gitconfig
[user]
    name = さーな
    email = 37serna37serna37serna@gmail.com

[credential]
    helper = osxkeychain
EOF

# ssh接続設定
mkdir -p ~/.ssh
cat - << "EOF" > ~/.ssh/config
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


# ====================================
# C++とAtCoder用設定
# ====================================
function solve() {
    type gum > /dev/null 2>&1 || brew install gum
    DIR_NAME=$(gum input --header "フォルダ名" --value "$HOME/sandbox_algo")
    CONTEST_CODE=$(gum input --header "コンテストコード" --value "abcXXX")
    mkdir -p $DIR_NAME
    cd $DIR_NAME

    # LSP用設定
    cp -f ~/git/library-cpp/.clang-format .
    cp -f ~/git/library-cpp/compile_flags.txt .
    # C++デバッガのlldbのためにllvmを導入
    [[ ! -d /opt/homebrew/opt/llvm ]] && brew install llvm
    # atcoder-cliを入れる
    type acc > /dev/null 2>&1 || npm install -g atcoder-cli
    # 仮想環境
    gum spin --title "Python venv activation" -- python -m venv venv
    . venv/bin/activate
    # AtCoderテスト用ライブラリをインストール
    gum spin --title "pip install --upgrade pip" -- pip install --upgrade pip
    gum spin --title "pip install --upgrade setuptools" -- pip install --upgrade setuptools
    gum spin --title "pip install online-judge-tools" -- pip install online-judge-tools
    gum spin --title "pip install online-judge-verify-helper" -- pip install online-judge-verify-helper

    # atcoder-cliとojのセットアップ
    gum spin --title "check acc check-oj" -- acc check-oj
    gum spin --title "oj login" -- oj login https://atcoder.jp
    gum spin --title "acc config..." -- acc config default-task-choice all
    gum spin --title "acc config..." -- acc config default-test-dirname-format test
    if [ $CONTEST_CODE = "abcXXX" ]; then
        echo " >> 書き捨てフォルダ"
        mkdir -p "$CONTEST_CODE/a"
        mkdir -p "$CONTEST_CODE/z"
    else
        echo " >> コンテスト $CONTEST_CODE フォルダ"
        acc new $CONTEST_CODE
    fi
    # main.cppを作成
    cd $CONTEST_CODE
    dirs=(`find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2`)
    for v in ${dirs[@]}; do
        if [ ! -f "$v/main.cpp" ]; then
            cp -f ~/git/library-cpp/template/template.cpp "$v/main.cpp"
        fi
    done
    cd $DIR_NAME
}


# ====================================
# C++の実行
# ====================================

# C++ビルドコマンド (ローカルのデバッグヘッダ用変数付き)
# AtCoderでの指定: https://atcoder.jp/contests/APG4b/rules?lang=ja
# -std=c++20 バージョン指定
# -I includeパス
# -Wall 警告オプションまとめ
# -Wextra その他の警告オプションまとめ
# -mtune=native マシン最適化
# -march=native マシン最適化
# -fconstexpr-depth=2147483647 コンパイル時の再帰回数
export CPP_BUILD_CMD="g++ -D=LOCAL -std=c++20 \
-I $HOME/git/library-cpp \
-Wall -Wextra \
-mtune=native -march=native \
-fconstexpr-depth=2147483647 \
-o "

# C++ビルドコマンド (サニタイザ版)
# -ftrapv 符号あり整数計算でover under flow
# -fsanitize-undefined-trap-on-error 未定義サニタイザ
# -fsanitize=address アドレスサニタイザ
export CPP_BUILD_CMD_SANITIZE="g++ -std=c++20 \
-I $HOME/git/library-cpp \
-Wall -Wextra \
-mtune=native -march=native \
-fconstexpr-depth=2147483647 \
-ftrapv \
-fsanitize-undefined-trap-on-error \
-fsanitize=address \
-o "

# C++ファイルを実行
function cppexe() {
    type gum > /dev/null 2>&1 || brew install gum
    # C++デバッガのlldbのためにllvmを導入
    [[ ! -d /opt/homebrew/opt/llvm ]] && brew install llvm

    # 実行ファイルを選択
    TARGET=$(find . -name '*.cpp' | gum filter --limit=1 --fuzzy)
    # 通常起動 / サニタイズ起動 を選択
    RUN_MODE=$(gum choose "normal" "sanitize")
    CMD=$CPP_BUILD_CMD
    [ $RUN_MODE = "sanitize" ] && CMD=$CPP_BUILD_CMD_SANITIZE

    # ビルドと実行
    gum spin --title "running..." -- zsh -c "$CMD _cpp_exec_tmpfile $TARGET 2>&1"
    ./_cpp_exec_tmpfile
    res=$?
    echo " == exit code: $res =="
    \rm _cpp_exec_tmpfile
}


# ====================================
# 主要コマンドの表記
# ====================================
echo -e "\e[34mCommands:\e[32m v z e l g dev\e[m   \e[34mC++:\e[32m solve cppexe\e[m"

