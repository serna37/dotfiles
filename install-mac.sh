#!/bin/bash

# 以下はzsh中で、必要になった時にinstallされる
# 開発ツール
#git
#vim
#zoxide
#eza
#fzf
#bat
#ripgrep
#jq

# TUIツール
#lazygit
#lazydocker
#gum
#yazi
#veeso/termscp/termscp
#tako8ki/tap/gobang

# GitHub CLI
#gh

# Utility
#ffmpeg
#silicon
#code-minimap

# Make me happy
#genact
#tty-clock
#cmatrix
#fastfetch
#screenfetch

# =========================================-

# brew install用
REPOS=(
# Mac Apple Store CLI
mas

# shell支援
powerlevel10k
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting

# 言語系
llvm
gcc@12
node
python3
sqlite
#postgresql@14
#rust
#go
#java11
)
for v in ${REPOS[@]}; do
    brew reinstall $v
    wait $!
done

# brew install cask用
CASK_REPOS=(
wezterm
orbstack
maccy
keycastr
)
for v in ${CASK_REPOS[@]}; do
    brew reinstall --cask $v
    wait $!
done

MAS_IDS=(
1429033973 # RunCat
1187652334 # Fuwari
)
for v in ${MAS_IDS[p]}; do
    mas install $v
    wait $!
done

sleep 2
# dotfilesの適用
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/setup.sh)"

