#!/bin/bash

# Homebrewのパス追加
export PATH="$PATH:/opt/homebrew/bin/"

# =====================================
# コマンド
REPOS=(vim git mas sqlite)

# アプリ
CASK_REPOS=(
ghostty wezterm
orbstack
maccy keycastr google-drive
dbeaver-community another-redis-desktop-manager
)

# GUIアプリ
MAS_IDS=(
1429033973 # RunCat
1187652334 # Fuwari
)
# =====================================

for v in ${REPOS[@]}; do
    brew reinstall $v
    wait $!
done
for v in ${CASK_REPOS[@]}; do
    brew reinstall --cask $v
    wait $!
done
for v in ${MAS_IDS[p]}; do
    mas install $v
    wait $!
done

# =====================================
# 1回だけ必要な作業
# =====================================

export GIT_REPO_ROOT=$HOME/git
mkdir -p $GIT_REPO_ROOT

# 本リポジトリを用意しリンクする
cd $GIT_REPO_ROOT
git clone https://github.com/serna37/dotfiles

# エミュレータ
mkdir -p ~/.config/ghostty
ln -nfs $GIT_REPO_ROOT/dotfiles/ghostty_config ~/.config/ghostty/config

# zsh
ln -nfs $GIT_REPO_ROOT/dotfiles/.zshrc ~/.zshrc
ln -nfs $GIT_REPO_ROOT/dotfiles/.p10k.zsh ~/.p10k.zsh

# mise(ツールチェーン)
mkdir -p ~/.config/mise
ln -nfs $GIT_REPO_ROOT/dotfiles/config.toml ~/.config/mise/config.toml

# vim
ln -nfs $GIT_REPO_ROOT/dotfiles/.vimrc ~/.vimrc

# fontを入れる 三角のやつ
cd $GIT_REPO_ROOT
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
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# デフォルトで隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -bool true

# shell再起動
exec $SHELL -l

# XXX old
#if [ ! -d ~/.vim/UltiSnips ]; then
#    # snippets
#    mkdir -p ~/.vim/UltiSnips > /dev/null 2>&1
#    ln -nfs ~/git/dotfiles/conf/cpp/snippets/* ~/.vim/UltiSnips/
#    zsh ~/git/dotfiles/conf/cpp/library.zsh
#    # TODO library更新時、新規ファイルのリンクがない
#    ln -nfs ~/git/dotfiles/conf/snippets/* ~/.vim/UltiSnips/
#fi

