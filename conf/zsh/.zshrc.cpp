# ====================================
# C++とAtCoder用設定
# ====================================
function _logo_atcoder() {
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

# C++用設定、AtCoder用設定を導入
function _setup_cpp_atcoder() {
    # C++デバッガのlldbのためにllvmを導入
    if [ ! -d /opt/homebrew/opt/llvm ]; then
        info 'INSTALL: llvm'
        brew install llvm
    fi
    # gitignore
    cp -f ~/git/dotfiles/conf/cpp/cpp_gitignore .gitignore
    # LSP用設定
    cp -f ~/git/dotfiles/conf/cpp/.clang-format .
    cp -f ~/git/dotfiles/conf/cpp/compile_flags.txt .
    # vimspector デバッグ設定を追加
    cp -f ~/git/dotfiles/conf/vim/.vimspector.json .
    # C++ロゴフォーマッタとAAを追加
    cp -fR ~/git/dotfiles/conf/cpp/AA .
    # AtCoderロゴ
    _logo_atcoder
    # atcoder-cliを入れる
    if ! type acc > /dev/null 2>&1; then
        npm install -g atcoder-cli
    fi
    # 仮想環境
    spin 'Python venv activation' python -m venv venv
    . venv/bin/activate
    # AtCoderテスト用ライブラリをインストール
    spin 'pip install --upgrade pip' pip install --upgrade pip
    spin 'pip install --upgrade setuptools' pip install --upgrade setuptools
    spin 'pip install online-judge-tools' pip install online-judge-tools
}

# AtCoder用フォルダを開く
# 書き捨てで解く: solve
# AtCoderコンテスト: solve abc100
function solve() {

    # 書き捨てで解く場合
    SAND_DIR="$HOME/work/algo_practice"
    if [ $# -eq 0 ]; then
        mkdir -p $SAND_DIR > /dev/null 2>&1
        cd $SAND_DIR
        _setup_cpp_atcoder
        # a問題、z問題を作成
        mkdir -p a > /dev/null 2>&1
        mkdir -p z > /dev/null 2>&1
        touch a/main.cpp z/main.cpp
        # z問題として開く
        v z/main.cpp
        return
    fi

    # AtCoderコンテストの場合
    CONTEST_CODE=$1
    AC_DIR="$HOME/work/atcoder_contest"
    mkdir -p $AC_DIR > /dev/null 2>&1
    cd $AC_DIR
    _setup_cpp_atcoder
    if [ "$(acc contest $CONTEST_CODE)" = "" ]; then
        error "コンテストコード $CONTEST_CODE が正しくありません"
        return
    fi
    # atcoder-cliとojのセットアップ
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
    # 順位表とa問題を開く
    open "https://atcoder.jp/contests/$CONTEST_CODE/standings"
    open "https://atcoder.jp/contests/$CONTEST_CODE/tasks/${CONTEST_CODE}_a"
    v
}
function _solve() { _values '' '[ 書き捨て]' 'abc[ AtCoderコンテスト番号]' }
compdef _solve solve


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
function cpp_exe() {
    _lazy_install gum gum
    # C++デバッガのlldbのためにllvmを導入
    if [ ! -d /opt/homebrew/opt/llvm ]; then
        info 'INSTALL: llvm'
        brew install llvm
    fi
    # 実行ファイルを選択
    TARGET=$(find . -name '*.cpp' | gum choose)
    # 通常起動 / サニタイズ起動 を選択
    RUN_MODE=$(gum choose "normal" "sanitize")
    CMD=$CPP_BUILD_CMD
    if [ $RUN_MODE = "sanitize" ]; then
        CMD=$CPP_BUILD_CMD_SANITIZE
    fi
    # ビルドと実行
    echo "==================================="
    info "build :$TARGET processing..."
    eval "$CMD _cpp_exec_tmpfile $TARGET 2>&1"
    info "build :$TARGET complete."
    echo "==================================="
    printf "\e[33m-----------------------------\e[m\n"
    ./_cpp_exec_tmpfile
    res=$?
    printf "\e[33m-----------------------------\e[m\n"
    if [ $res -eq 0 ]; then
        info "exit code:$res"
    else
        error "exit code:$res"
    fi
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

