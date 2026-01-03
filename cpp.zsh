#!/bin/zsh

# ====================================
# C++とAtCoder用設定
# ====================================

# カスタムコマンドの一覧
function solve() {
    type gum > /dev/null 2>&1 || brew install gum
    CMD=$(gum filter --limit 1 \
        _cpp_ac_pj \
        _cpp_ac_DL \
        _cpp_ac_test \
        _cpp_ac_exe \
        _cpp_ac_bundle \
    )
    eval $CMD
}

# AtCoder用プロジェクト作成
function _cpp_ac_pj() {
    echo "\e[34mAtCoder用プロジェクト作成\e[m"
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
        echo "\e[34m >> 書き捨てフォルダ\e[m"
        mkdir -p "$CONTEST_CODE/a"
        mkdir -p "$CONTEST_CODE/z"
    else
        echo "\e[34m >> コンテスト $CONTEST_CODE フォルダ\e[m"
        acc new $CONTEST_CODE
    fi
    # main.cppを作成
    cd $CONTEST_CODE
    dirs=(`find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2`)
    for v in ${dirs[@]}; do
        if [ ! -f "$v/main.cpp" ]; then
            cp -f ~/git/library-cpp/main.cpp "$v/main.cpp"
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
    echo "\e[34m C++実行 - サニタイズを選択する場合は引数を指定\e[m"
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
    gum spin --title "build..." -- zsh -c "$CMD _cpp_exec_tmpfile $TARGET"
    if [ ! -f "_cpp_exec_tmpfile" ]; then
        eval $CMD _cpp_exec_tmpfile $TARGET
        \rm _cpp_exec_tmpfile
        return 1
    fi
    echo "\e[34m == [INFO] exe: $TARGET ==\e[m"
    ./_cpp_exec_tmpfile
    res=$?
    echo "\e[34m == [INFO] exit code: $res ==\e[m"
    \rm _cpp_exec_tmpfile
}

# ====================================
# テスト・提出
# ====================================

# テストケースをダウンロード
function _cpp_ac_DL() {
    echo "\e[34mAtCoderテストケースをダウンロード\e[m"
    # 現在、コンテストフォルダに居ること
    # ~/xx/abcXXX
    # 問題フォルダ一覧を取得 a z
    LIST=$(find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2)
    TARGET=$(echo $LIST | gum filter --limit=1 --fuzzy)
    # テストフォルダを削除
    cd $TARGET
    \rm -rf test
    URL=$(gum input --placeholder "問題URLを入力")
    oj d $URL
    cd ..
}


# ローカルでテストケース実行
function _cpp_ac_test() {
    echo "\e[34mAtCoderローカルテスト\e[m"
    # 現在、コンテストフォルダに居ること
    # ~/xx/abcXXX
    # 問題フォルダ一覧を取得 a z
    LIST=$(find . -type d -maxdepth 1 | grep / | cut -d '/' -f 2)
    TARGET=$(echo $LIST | gum filter --limit=1 --fuzzy)
    cd $TARGET
    gum spin --title "build..." -- zsh -c "$CPP_BUILD_CMD main main.cpp"
    gum spin --title "build..." -- zsh -c "$CPP_BUILD_CMD_SANITIZE sani main.cpp > /dev/null 2>&1"
    if [ ! -f "main" ]; then
        eval $CMD main $TARGET
        \rm main sani
        return 1
    fi

    # 出力を確認
    echo "\e[34m >> ケース1を実行\e[m"
    ./main < test/sample-1.in # debug情報(標準エラー)も画面に表示
    ./main < test/sample-1.in > res 2> /dev/null # 標準出力のみ保存
    echo "\e[34m << 実行完了\e[m"

    # 標準出力を比較
    ISOK=0
    echo "\e[34m >> 期待値\e[m"
    cat test/sample-1.out
    if diff -w test/sample-1.out res > /dev/null; then
        echo "\e[32m実行結果  : ✅出力一致\e[m"
        ISOK=1
    else
        echo "\e[31m実行結果  : ❌出力不一致\e[m"
        type delta > /dev/null 2>&1 || brew install git-delta
        delta -s test/sample-1.out res
    fi

    # ケース1がOKまたは、緩いoj tがOKであればテストに続く
    if [ $ISOK -eq 1 ] || oj t --ignore-spaces-and-newlines -e 1e-6 -c ./main > /dev/null 2>&1; then
        # サニタイザ付きで実行確認
        if ./sani < test/sample-1.in 1> /dev/null; then
            echo "\e[32mサニタイザ: ✅アドレス違反なし\e[m"
        else
            echo "\e[31mサニタイザ: ❌アドレス違反\e[m"
            ./sani < test/sample-1.in 1> /dev/null # 標準エラーのみ表示
        fi
        # ojでテスト
        if gum spin --title "test..." -- oj t -e 1e-6 -c ./main; then
            echo "\e[32mテスト結果: ✅OK\e[m"
            # 実行速度とメモリを表示
            TMP=$(oj t -e 1e-6 -c ./main 2> /dev/null)
            SEC=$(echo $TMP | tail -n 3 | head -n 1 | sed -e "s/.*slowest: \(.*\) sec.*/\1/g")
            [ `echo "$SEC < 2" | bc` -eq 1 ] && echo "\e[32m実行速度  : ✅2sec未満\e[m" || echo "\e[31m実行速度: ⚠️2sec超過\e[m"
            MEM=$(echo $TMP | tail -n 2 | head -n 1 | sed -e "s/.*memory: \(.*\) MB.*/\1/g")
            [ `echo "$MEM < 256" | bc` -eq 1 ] && echo "\e[32m使用メモリ: ✅256MB未満\e[m" || echo "\e[31m使用メモリ: ⚠️256MB超過\e[m"
            [ `echo "$MEM < 1024" | bc` -eq 1 ]&& echo "\e[32m使用メモリ: ✅1024MB未満\e[m" || echo "\e[31m使用メモリ: ⚠️1024MB超過\e[m"
            # バックグラウンド実行はsleep 5 &
            # PID表示を消す場合はsleep 5 &!
            afplay /System/Library/Sounds/Hero.aiff &!
        else
            echo "\e[31mテスト結果: ❌NG\e[m"
            echo "===================================="
            oj t -e 1e-6 -c ./main 2> /dev/null # debug情報(標準エラー)は非表示
            echo "===================================="
        fi
    fi

    \rm main res sani #ビルド失敗時など、削除対象なしエラーが見えた方がわかりやすい
    cd ..
    echo "\e[34m-- DONE --\e[m"
}


# C++ファイルのincludeライブラリをバンドル
function _cpp_ac_bundle() {
    echo "\e[34mC++バンドル\e[m"
    PWD=$(pwd)
    if [[ ! -e "$HOME/git/library-cpp/bundler/build/cpp-bundler" ]]; then
        echo "\e[34mC++バンドラをビルドします\e[m"
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

