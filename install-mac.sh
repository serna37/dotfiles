repos=(
git
vim
zoxide
eza
fzf
bat
ripgrep
lazygit
lazydocker
gum
yazi
sshs
veeso/termscp/termscp
tako8ki/tap/gobang
ffmpeg
gh
silicon
code-minimap
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting
genact
tty-clock
cmatrix
gcc@12
node
python3
sqlite
postgresql@14
rust
go
java11
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

cask_repos=(
wezterm
orbstack
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

# =====================================================================================
# brew系設定終了
# dotfilesの設定開始
# =====================================================================================
echo "=========================================================="
echo "[setup] dotfiles"
echo "=========================================================="
# dotfilesレポをクローン
mkdir -p ~/git && cd ~/git
git clone https://github.com/serna37/dotfiles
# dotfilesをシンボックスリンク
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua

echo "=========================================================="
echo "[setup] conf"
echo "=========================================================="
# エクスプローラ
mkdir -p ~/.config/yazi/
ln -nfs ~/git/dotfiles/conf/yazi/yazi.toml ~/.config/yazi/yazi.toml
# DB Viewer
mkdir -p ~/.config/gobang/
ln -nfs ~/git/dotfiles/conf/gobang/config.toml ~/.config/gobang/config.toml
# ssh接続設定
mkdir -p ~/.ssh
ln -nfs ~/git/dotfiles/conf/sshs/config ~/.ssh/config
# コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cp ~/git/dotfiles/conf/vim/common-settings.vim ~/.vim/after/plugin/
# coc用設定をシンボリックリンク
mkdir -p ~/.vim/UltiSnips
ln -nfs ~/git/dotfiles/conf/vim/coc-settings.json ~/.vim/coc-settings.json
# C++ snippets
mkdir -p ~/.vim/UltiSnips
ln -nfs ~/git/dotfiles/conf/cpp/snippets/* ~/.vim/UltiSnips/
# C++ library
zsh ~/git/dotfiles/conf/cpp/library.zsh

echo "=========================================================="
echo "[tool] atcoder-cli"
echo "=========================================================="
npm install -g atcoder-cli

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
echo "[vim] install vim plugins"
echo "=========================================================="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall" -c "qa"

# end
exec $SHELL -l

