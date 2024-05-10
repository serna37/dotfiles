alias debug='cpp_exe'
alias algo='cpp_test'

# C++ 初期化
cpp_ini() {
    cp ~/git/dotfiles/conf/cpp/cpp_gitignore .
    cp ~/git/dotfiles/conf/cpp/.clang-format .
    cp ~/git/dotfiles/conf/cpp/compile_flags.txt .
    # ojコマンドのためにPython仮想環境を作成
    python -m venv .
    . bin/activate
    pip install --upgrade setuptools
    sudo pip3 install online-judge-tools
}

# C++ビルド
cpp_build() {
    filename=$1
    file="${filename%.*}"
    g++ \
        -std=c++20 \
        -I /opt/homebrew/Cellar/gcc@12/12.3.0/include/c++/12/aarch64-apple-darwin23/ \
        -Wall \
        -Wextra \
        -mtune=native \
        -march=native \
        -fconstexpr-depth=2147483647 \
        -ftrapv \
        -fsanitize-undefined-trap-on-error \
        -o $file $1
        #-fconstexpr-loop-limit=2147483647 \
        #-fconstexpr-ops-limit=2147483647 \
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

# フォルダ名を指定して、ダウンロード済みからoj t
export CC_TEST_PROBLEM="z"
cpp_test() {
    if [ $# -eq 1 ]; then
        export CC_TEST_PROBLEM=$1
    fi
    cd $CC_TEST_PROBLEM
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_TEST_PROBLEM/main.cpp processing...\e[m"
    cpp_build main.cpp
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_TEST_PROBLEM/main.cpp complete.\e[m"
    echo -e "==================================="
    echo -e "\e[33m-----------------------------\e[m"
    oj t -c "./main"
    cd ..
}

# URLからojでC++テスト(vim atcoder menuに同機能あり)
cpp_test_url() {
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mmain.cppのあるフォルダ名を入力\e[m"
    read A
    cd $A
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
    cd ..
}

# AtCoderコンテスト
export AC_DIR="$HOME/git/contest"
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

# 朝活
export ASA_DIR="$HOME/git/asakatu"
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

# ADT
export ADT_DIR="$HOME/git/adt"
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

# 単一で解く
export SAND_DIR="$HOME/git/sandbox"
solve() {
    cd $SAND_DIR
    echo -n > z/main.cpp
    cd z
    rm -rf test
    oj d $(pbpaste)
    cd ..
    v z/main.cpp
}

