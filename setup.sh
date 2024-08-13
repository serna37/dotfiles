#!/bin/bash

# dotfiles
mkdir -p ~/git && cd ~/git
git clone https://github.com/serna37/dotfiles
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/conf/zsh/.p10k.zsh ~/.p10k.zsh
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua

# font
cd ~/git
git clone --depth 1 https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
\rm -rf fonts

# git
if [ "$(uname)" = "Darwin" ]; then
    # 最初だけ認証が必要 netrcに書いてもよいが...
    # OSキーチェーンに保存する
    git config --global credential.helper osxkeychain
    # git config --global credential.helper store
    # git config --global credential.helper store --file ファイルパス
fi

# end
exec $SHELL -l

