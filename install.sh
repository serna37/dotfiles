#!/bin/bash

# Homebrewを入れる
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH="$PATH:/opt/homebrew/bin/"

# 必要なコマンド等を入れる
REPOS=(vim git gh mas python3 sqlite)
for v in ${REPOS[@]}; do
    brew reinstall $v
    wait $!
done

# 必要なアプリをCL版で入れる
CASK_REPOS=(wezterm orbstack maccy keycastr)
for v in ${CASK_REPOS[@]}; do
    brew reinstall --cask $v
    wait $!
done

# 必要なGUIアプリを入れる
MAS_IDS=(
1429033973 # RunCat
1187652334 # Fuwari
)
for v in ${MAS_IDS[p]}; do
    mas install $v
    wait $!
done

# 1回だけ必要な作業

# dotfilesのファイルをリンク
mkdir -p ~/git
cd ~/git
git clone https://github.com/serna37/dotfiles
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/conf/zsh/.p10k.zsh ~/.p10k.zsh
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua
if [ ! -L ~/.ssh/config ]; then
    # ssh接続設定
    mkdir -p ~/.ssh > /dev/null 2>&1
    ln -nfs ~/git/dotfiles/conf/ssh/config ~/.ssh/config
fi
if [ ! -f ~/.vim/after/plugin/common-settings.vim ]; then
    # vim コメント行から改行した際、次の行をコメントにしない設定
    mkdir -p ~/.vim/after/plugin > /dev/null 2>&1
    cp ~/git/dotfiles/conf/vim/common-settings.vim ~/.vim/after/plugin/
fi
# TODO けすかも
if [ ! -L ~/.vim/coc-settings.json ]; then
    # coc用設定
    mkdir -p ~/.vim > /dev/null 2>&1
    ln -nfs ~/git/dotfiles/conf/vim/coc-settings.json ~/.vim/coc-settings.json
fi
# TODO けすかも
if [ ! -d ~/.vim/UltiSnips ]; then
    # snippets
    mkdir -p ~/.vim/UltiSnips > /dev/null 2>&1
    ln -nfs ~/git/dotfiles/conf/cpp/snippets/* ~/.vim/UltiSnips/
    zsh ~/git/dotfiles/conf/cpp/library.zsh
    # TODO library更新時、新規ファイルのリンクがない
    ln -nfs ~/git/dotfiles/conf/snippets/* ~/.vim/UltiSnips/
fi
if [ ! -L ~/.gitconfig ]; then
    # gitconfig
    ln -nfs ~/git/dotfiles/.gitconfig ~/.gitconfig
fi

# fontを入れる 三角のやつ
cd ~/git
git clone --depth 1 https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
\rm -rf fonts

# fontを入れる icon系
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh
cd ..
\rm -rf nerd-fonts

# gitの認証設定 最初だけ認証が必要です
# OSキーチェーンに保存する
git config --global credential.helper osxkeychain
# git config --global credential.helper store
# git config --global credential.helper store --file ファイルパス

# ghを設定
if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi


# shell再起動
exec $SHELL -l

