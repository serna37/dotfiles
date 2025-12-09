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
    cp -f ~/git/dotfiles/conf/cpp/.clang-format .
    cp -f ~/git/dotfiles/conf/cpp/compile_flags.txt .
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
        touch "$v/main.cpp"
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
-I $HOME/git/dotfiles/conf/cpp \
-Wall -Wextra \
-mtune=native -march=native \
-fconstexpr-depth=2147483647 \
-o "

# C++ビルドコマンド (サニタイザ版)
# -ftrapv 符号あり整数計算でover under flow
# -fsanitize-undefined-trap-on-error 未定義サニタイザ
# -fsanitize=address アドレスサニタイザ
export CPP_BUILD_CMD_SANITIZE="g++ -std=c++20 \
-I $HOME/git/dotfiles/conf/cpp \
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

# ==============================================
# 以下、oj実行環境を前提とする関数
# solveまたはsolve abcXXXで構成したフォルダ中から
# vimスクリプト経由で呼び出すことを想定
# ==============================================
# より高速なC++実行
# cpp_debug z のように実行
function cpp_debug() {
    cd $1
    info " >> ビルド: $1/main.cpp"
    eval $CPP_BUILD_CMD main main.cpp
    eval $CPP_BUILD_CMD_SANITIZE sani main.cpp > /dev/null 2>&1

    # 出力を確認
    info " >> ケース1を実行"
    ./main < test/sample-1.in # debug情報(標準エラー)も画面に表示
    ./main < test/sample-1.in > res 2> /dev/null # 標準出力のみ保存
    info " << 実行完了"

    # 標準出力を比較
    ISOK=0
    info " >> 期待値"
    cat test/sample-1.out
    if diff -w test/sample-1.out res > /dev/null; then
        info "実行結果  : ✅出力一致"
        ISOK=1
    else
        error "実行結果  : ❌出力不一致"
        _lazy_install delta git-delta
        delta -s test/sample-1.out res
        warn "単純差分でないテストの実行はAtCoderTestPopup"
    fi

    # ケース1がOKまたは、緩いoj tがOKであればテストに続く
    if [ $ISOK -eq 1 ] || oj t --ignore-spaces-and-newlines -e 1e-6 -c ./main > /dev/null 2>&1; then
        # サニタイザ付きで実行確認
        if ./sani < test/sample-1.in 1> /dev/null; then
            info 'サニタイザ: ✅アドレス違反なし'
        else
            warn 'サニタイザ: ❌アドレス違反'
            ./sani < test/sample-1.in 1> /dev/null # 標準エラーのみ表示
        fi
        # ojでテスト
        if spin 'test...' oj t -e 1e-6 -c ./main; then
            info "テスト結果: ✅OK"
            # 実行速度とメモリを表示
            TMP=$(oj t -e 1e-6 -c ./main 2> /dev/null)
            SEC=$(echo $TMP | tail -n 3 | head -n 1 | sed -e "s/.*slowest: \(.*\) sec.*/\1/g")
            [ `echo "$SEC < 2" | bc` -eq 1 ] && info "実行速度  : ✅2sec未満" || warn "実行速度: ⚠️2sec超過"
            MEM=$(echo $TMP | tail -n 2 | head -n 1 | sed -e "s/.*memory: \(.*\) MB.*/\1/g")
            [ `echo "$MEM < 256" | bc` -eq 1 ] && info "使用メモリ: ✅256MB未満" || warn "使用メモリ: ⚠️256MB超過"
            [ `echo "$MEM < 1024" | bc` -eq 1 ]&& info "使用メモリ: ✅1024MB未満" || warn "使用メモリ: ⚠️1024MB超過"
            # バックグラウンド実行はsleep 5 &
            # PID表示を消す場合はsleep 5 &!
            afplay /System/Library/Sounds/Hero.aiff &!
        else
            error "テスト結果: ❌NG"
            echo "===================================="
            oj t -e 1e-6 -c ./main 2> /dev/null # debug情報(標準エラー)は非表示
            echo "===================================="
        fi
    fi

    \rm main res sani #ビルド失敗時など、削除対象なしエラーが見えた方がわかりやすい
    cd ..
    info "-- DONE --"
}

# 提出コマンド
# 書き捨ての場合: atcoder_submit z https://xxxx...
# コンテストの場合: atcoder_submit a
function atcoder_submit() {
    TARGET=$1
    if [ $# -eq 2 ]; then
        # 書き捨ての場合
        URL=$2
    else
        # コンテストの場合、jsonからURL抽出
        _lazy_install jq jq
        URL=$(cat contest.acc.json | jq -r ".tasks.[] | select(.directory.path == \"$TARGET\") | .url")
    fi
    cd $TARGET
    spin 'submit...' oj s -y --no-open $URL main.cpp
    cd ..
    CONTEST_URL=$(echo $URL | sed -e 's/tasks.*//g')
    echo "===================================="
    echo "see: ${CONTEST_URL}submissions/me"
    info "-- DONE --"
}

