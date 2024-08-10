#!/bin/bash

# brew install用
REPOS=(

# 開発ツール
git
vim
zoxide
eza
fzf
bat
ripgrep
jq

# TUIツール
lazygit
lazydocker
gum
yazi
sshs
veeso/termscp/termscp
tako8ki/tap/gobang

# Mac Apple Store CLI
mas

# GitHub CLI
gh

# Utility
ffmpeg
silicon
code-minimap

# Make me happy
genact
tty-clock
cmatrix
fastfetch
screenfetch

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
echo "===========================START==========================="
echo "brew install"
echo "=========================================================="
brew list
brew cleanup
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
echo "=========================================================="
echo "brew cask install"
echo "=========================================================="
for v in ${CASK_REPOS[@]}; do
    brew reinstall --cask $v
    wait $!
done

echo "=========================================================="
echo "brew clean list"
echo "=========================================================="
brew cleanup
brew list

echo "=========================================================="
echo "mas install apps"
echo "=========================================================="
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

