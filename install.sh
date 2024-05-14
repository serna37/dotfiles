# brew install
repos=(
# base
vim
git

# enhanced command
# cd ls find
zoxide
eza
fzf
fd
fselect

# cat sed grep
bat
sd
ripgrep
ripgrep-all

# summary
tokei

# utils
coreutils
watch
ffmpeg

# TUI tools
# diff
git-delta
# df
dust
# ps
procs
# top
bottom
# ping
gping
# DB viewer
tako8ki/tap/gobang
# explorer #broot(not reccomend)
yazi
# Docker
lazydocker
# Git
lazygit
# Network Monitor
trippy
# SSH
sshs
# SCP
veeso/termscp/termscp

# GitHub CLI
gh

# Code Tool
silicon
code-minimap

# zsh suggestion
navi
peco
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting

# make me happy
sl
cmatrix
tty-clock
genact

# lang
gcc@12
node
python3
sqlite
postgresql@14
rust
go
java11

# zsh prompt
powerlevel10k
)

echo "===========================START==========================="
echo "brew install"
echo "=========================================================="
brew list
brew cleanup
for v in ${repos[@]}; do
    echo "=========================================================="
    echo "${v}"
    echo "=========================================================="
    brew reinstall ${v}
    wait $!
done

# brew cask install
cask_repos=(
wezterm
maccy
keycastr
)

echo "=========================================================="
echo "brew cask install"
echo "=========================================================="
for v in ${cask_repos[@]}; do
    echo "=========================================================="
    echo "${v}"
    echo "=========================================================="
    brew reinstall --cask ${v}
    wait $!
done

echo "=========================================================="
echo "brew clean list"
echo "=========================================================="
brew cleanup
brew list
sleep 2

echo "=========================================================="
echo "[dotfiles] clone & setup .zshrc .vimrc .wezterm.lua"
echo "=========================================================="
# dotfilesレポをクローン
mkdir -p ~/git
cd ~/git
git clone https://github.com/serna37/dotfiles
# dotfilesをシンボックスリンク
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua

echo "=========================================================="
echo "[vim] setup common-settings.vim"
echo "=========================================================="
# コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cp ~/git/dotfiles/conf/vim/common-settings.vim ~/.vim/after/plugin/

echo "=========================================================="
echo "[vim] install vim-plug"
echo "=========================================================="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "=========================================================="
echo "[vim] setup coc-settings.json"
echo "=========================================================="
# coc用設定をシンボリックリンク
mkdir -p ~/.vim/UltiSnips
ln -nfs ~/git/dotfiles/conf/vim/coc-settings.json ~/.vim/coc-settings.json

echo "=========================================================="
echo "[tool] install font"
echo "=========================================================="
cd ~/git
git clone --depth 1 https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts

echo "=========================================================="
echo "[tool] atcoder-cli"
echo "=========================================================="
npm install -g atcoder-cli

echo "=========================================================="
echo "[C++] setup stdc++.h debug.hpp snippets"
echo "=========================================================="
BITS_PATH=/opt/homebrew/Cellar/gcc@12/12.3.0/include/c++/12/aarch64-apple-darwin23/bits
cp ~/git/dotfiles/conf/cpp/stdc++.h $BITS_PATH
cp ~/git/dotfiles/conf/cpp/debug.hpp $BITS_PATH
ln -nfs ~/git/dotfiles/snippets/* ~/.vim/UltiSnips/

echo "=========================================================="
echo "[C++] install serna/37/library"
echo "=========================================================="
cd ~/git
git clone https://github.com/serna37/library
cd library
zsh snippets.sh

echo "=========================================================="
echo "[setup] yazi toml"
echo "=========================================================="
mkdir -p ~/.config/yazi/
ln -nfs ~/git/dotfiles/conf/yazi/yazi.toml ~/.config/yazi/yazi.toml

echo "=========================================================="
echo "[setup] gobang toml"
echo "=========================================================="
mkdir -p ~/.config/gobang/
ln -nfs ~/git/dotfiles/conf/gobang/config.toml ~/.config/gobang/config.toml

echo "=========================================================="
echo "[setup] sshs"
echo "=========================================================="
mkdir -p ~/.ssh
ln -nfs ~/git/dotfiles/conf/sshs/config ~/.ssh/config

echo "=========================================================="
echo "[setup] trip sudo"
echo "=========================================================="
# パスワード入力が必要
sudo chown root $(which trip) && sudo chmod +s $(which trip)

echo "=========================================================="
echo "[tool] install unfog"
echo "=========================================================="
# パスワード入力が必要
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | sh

echo "=========================================================="
echo "[vim] install vim plugins"
echo "=========================================================="
vi -c "PlugInstall" -c "qa"

