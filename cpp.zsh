#!/bin/zsh

# ====================================
# C++とAtCoder用設定
# ====================================

# カスタムコマンドの一覧
function solve() {
    type gum > /dev/null 2>&1 || brew install gum
    CMD=$(gum filter --limit 1 \
        _cpp_ac_create_pj \
        _cpp_ac_exe \
        _cpp_ac_bundle \
    )
    eval $CMD
}

# AtCoder用プロジェクト作成
function _cpp_ac_create_pj() {
    echo "AtCoder用プロジェクト作成"
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
function _cpp_ac_exe() {
    echo "C++実行"
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
    gum spin --title "building..." -- zsh -c "$CMD _cpp_exec_tmpfile $TARGET 2>&1"
    echo " == [INFO] exe: $TARGET =="
    ./_cpp_exec_tmpfile
    res=$?
    echo " == [INFO] exit code: $res =="
    \rm _cpp_exec_tmpfile
}

# C++ファイルのincludeライブラリをバンドル
function _cpp_ac_bundle() {
    echo "C++バンドル"
    PWD=$(pwd)
    if [[ ! -e "$HOME/git/library-cpp/bundler/build/cpp-bundler" ]]; then
        echo "C++バンドラをビルドします"
        cd ~/git/library-cpp/bundler
        make build
        cd $PWD
    fi
    # 対象ファイルを選択
    type gum > /dev/null 2>&1 || brew install gum
    TARGET=$(find . -name '*.cpp' | gum filter --limit=1 --fuzzy)
    # includeファイルをバンドルする
    ~/git/library-cpp/bundler/build/cpp-bundler -I ~/git/library-cpp $TARGET > ./bundle.cpp
    # 展開されたうち、#line 1 /Users/serna37/git/... という行を削除する
    sed -i '' '/^#line/d' ./bundle.cpp

    cat ./bundle.cpp | pbcopy
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        "./bundle.cppを作成しました" \
        "クリップボードにコピーしました"
}

