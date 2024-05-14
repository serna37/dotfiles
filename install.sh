echo "=========================================================="
echo "brew clean list"
echo "=========================================================="
brew cleanup
brew list
sleep 2

echo "=========================================================="
echo "[dotfiles] clone & setup .zshrc .vimrc"
echo "=========================================================="
# dotfilesレポをクローン
mkdir -p ~/git
cd ~/git
git clone https://github.com/serna37/dotfiles
# dotfilesをシンボックスリンク
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

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
echo "[setup] trip sudo"
echo "=========================================================="
sudo chown root $(which trip) && sudo chmod +s $(which trip)

echo "=========================================================="
echo "[setup] yazi toml"
echo "=========================================================="
mkdir -p ~/.config/yazi/
ln -nfs ~/git/dotfiles/conf/yazi/yazi.toml ~/.config/yazi/yazi.toml

echo "=========================================================="
echo "[setup] sshs"
echo "=========================================================="
mkdir -p ~/.ssh
ln -nfs ~/git/dotfiles/conf/sshs/config ~/.ssh/config

echo "=========================================================="
echo "[tool] install unfog"
echo "=========================================================="
# パスワード入力が必要
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | sh

echo "=========================================================="
echo "[vim] install vim plugins"
echo "=========================================================="
vi -c "PlugInstall" -c "qa"

