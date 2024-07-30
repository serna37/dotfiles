# 依存
# git zsh

# =====================================================================================
# dotfilesの設定
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
\rm -rf fonts

# end
exec $SHELL -l

