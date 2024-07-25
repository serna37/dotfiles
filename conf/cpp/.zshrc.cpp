alias debug='cpp_exe_atcoder'

# C++ 初期化
cpp_ini() {
    # ojコマンドのためにPython仮想環境を作成
    python_venv
    pip install --upgrade pip
    pip install --upgrade setuptools
    pip install online-judge-tools
    # AA
    logo_cpp_setup
    # gitignore
    cp ~/git/dotfiles/conf/cpp/cpp_gitignore ./.gitignore
    # LSP server用設定
    cp ~/git/dotfiles/conf/cpp/.clang-format .
    cp ~/git/dotfiles/conf/cpp/compile_flags.txt .
    # vimspector debug設定を追加
    cp -f ~/.vim/plugged/vim-IDE-menu/.vimspector.json .vimspector.json
}

# C++ビルド
CC_INCLUDE_PATH="/opt/homebrew/Cellar/gcc@12/12.4.0/include/c++/12/aarch64-apple-darwin23/"
export CC_BUILD_CMD="g++ -std=c++20 -I $CC_INCLUDE_PATH -Wall -Wextra -mtune=native -march=native -fconstexpr-depth=2147483647 -ftrapv -fsanitize-undefined-trap-on-error -o "
#-fconstexpr-loop-limit=2147483647 \
#-fconstexpr-ops-limit=2147483647 \
#-fsanitize=address,undefined \

# たんにC++実行
cpp_exe() {
    A="./tools/CaesarCipher.cpp"
    if [ $# -eq 1 ]; then
        A=$1
    fi
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$A processing...\e[m"
    eval "$CC_BUILD_CMD _cpp_tmp $A 2>&1"
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$A complete.\e[m"
    echo -e "==================================="
    echo -e "\e[33m-----------------------------\e[m"
    ./_cpp_tmp
    res=$?
    echo -e "\e[33m-----------------------------\e[m"
    if [ $res -eq 0 ]; then
        echo -e "[\e[34mINFO\e[m] \e[32mexit code:$res.\e[m"
    else
        echo -e "[\e[31mERROR\e[m] \e[mexit code:$res."
    fi
}

# フォルダ名を指定してC++実行
export CC_EXE_PROBLEM="z"
cpp_exe_atcoder() {
    if [ $# -eq 1 ]; then
        export CC_EXE_PROBLEM=$1
    fi
    echo -e "==================================="
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_EXE_PROBLEM/main.cpp processing...\e[m"
    eval "$CC_BUILD_CMD ./$CC_EXE_PROBLEM/main ./$CC_EXE_PROBLEM/main.cpp"
    echo -e "[\e[34mINFO\e[m] \e[32mbuild :$CC_EXE_PROBLEM/main.cpp complete.\e[m"
    echo -e "==================================="
    echo -e "\e[33m-----------------------------\e[m"
    ./$CC_EXE_PROBLEM/main
    res=$?
    echo -e "\e[33m-----------------------------\e[m"
    if [ $res -eq 0 ]; then
        echo -e "[\e[34mINFO\e[m] \e[32mexit code:$res.\e[m"
    else
        echo -e "[\e[31mERROR\e[m] \e[mexit code:$res."
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
    eval "$CC_BUILD_CMD main main.cpp"
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
    eval "$CC_BUILD_CMD main main.cpp"
    echo -e "[\e[34mINFO\e[m] \e[32mテスト実行\e[m"
    echo -e "==================================="
    echo -e "==================================="
    oj t -c "./main"
    cd ..
}

# AtCoderコンテスト
export AC_DIR="$HOME/git/contest"
AtCoder() {
    logo_atcoder
    cd $AC_DIR
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
        echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    #vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
    v
}
#AtCoderResolve() {
    #cd $AC_DIR && rm -rf $1 && AtCoder $1
#}

## 朝活
#export ASA_DIR="$HOME/git/asakatu"
#AsakatuAtCoder() {
    #logo_atcoder
    #cd $ASA_DIR
    #file_name="main.cpp"
    #dirname=`date '+%Y%m%d'`
    #mkdir $dirname
    #cd $dirname
    #mkdir a b c d e f
    #dirs=(`\fd -d 1 -t d`)
    #for v in ${dirs[@]}; do
        #echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        #touch "${v}${file_name}"
    #done
    #if [[ -n $ASA_SAMPLE_DL ]]; then
        #for v in ${dirs[@]}; do
            #rm -rf "${v}test"
        #done
        #eval $ASA_SAMPLE_DL
        #cd ../
    #fi
    ##vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
    #v
#}

## ADT
#export ADT_DIR="$HOME/git/adt"
#ADTAtCoder() {
    #logo_atcoder
    #cd $ADT_DIR
    #file_name="main.cpp"
    #dirname=`date '+%Y%m%d'`
    #mkdir $dirname
    #cd $dirname
    #mkdir c d e f g
    #dirs=(`\fd -d 1 -t d`)
    #for v in ${dirs[@]}; do
        #echo -e "[\e[34mINFO\e[m] touch file :\e[32m${v}${file_name}\e[m"
        #touch "${v}${file_name}"
    #done
    ##vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify"
    #v
#}

# 単一で解く
export SAND_DIR="$HOME/work/sandbox"
solve() {
    logo_atcoder
    mkdir -p $SAND_DIR && cd $SAND_DIR
    cpp_ini
    mkdir a && touch a/main.cpp
    mkdir z && touch z/main.cpp
    #echo -n > z/main.cpp
    rm -rf a/test z/test
    cd z && oj d $(pbpaste)
    cd $SAND_DIR && v z/main.cpp
}

# util
echo "-[C++]---------"
echo "cpp_ini        | setup C++ project"
echo "cpp_exe [file] | execute C++ program"
echo "AtCoder abcXXX | create DIR & DL test cases"
echo "solve          | DL tests by clipboard & solve"
echo "---------------"
#echo "ADTAtCoder     | only create DIR"
echo "debug [z]      | test z/main.cpp and stdin"
echo "cpp_test [z]   | test z/main.cpp with downloaded test cases"
echo "cpp_test_url   | DL test cases by URL & test some/main.cpp "
echo "---------------"

