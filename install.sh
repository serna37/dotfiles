#!/bin/bash

# Homebrewのパス追加
export PATH="$PATH:/opt/homebrew/bin/"

# 必要なコマンド等を入れる
REPOS=(vim git mise mas sqlite)
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

# 本リポジトリをクローンする
mkdir -p ~/git
cd ~/git
git clone https://github.com/serna37/dotfiles

# dotfilesのファイルをリンク
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/conf/zsh/.p10k.zsh ~/.p10k.zsh
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.config/mise
ln -nfs ~/git/dotfiles/config.toml ~/.config/mise/config.toml

# TODO けすかも
#if [ ! -L ~/.vim/coc-settings.json ]; then
#    # coc用設定
#    mkdir -p ~/.vim > /dev/null 2>&1
#    ln -nfs ~/git/dotfiles/conf/vim/coc-settings.json ~/.vim/coc-settings.json
#fi

# TODO けすかも
#if [ ! -d ~/.vim/UltiSnips ]; then
#    # snippets
#    mkdir -p ~/.vim/UltiSnips > /dev/null 2>&1
#    ln -nfs ~/git/dotfiles/conf/cpp/snippets/* ~/.vim/UltiSnips/
#    zsh ~/git/dotfiles/conf/cpp/library.zsh
#    # TODO library更新時、新規ファイルのリンクがない
#    ln -nfs ~/git/dotfiles/conf/snippets/* ~/.vim/UltiSnips/
#fi

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

# gitの認証設定 最初だけ認証が必要
# OSキーチェーンに保存する
git config --global credential.helper osxkeychain
# git config --global credential.helper store
# git config --global credential.helper store --file ファイルパス


# Finderのキルを有効化するコマンド
defaults write com.apple.Finder QuitMenuItem -boolean true
# Finderが.DS_sotreを作らないようにするコマンド
defaults write com.apple.desktopservices DSDontWriteNetworkStores True

# shell再起動
exec $SHELL -l

