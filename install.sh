echo "=========================================================="
echo "npm yarn install"
echo "=========================================================="
npm install -g npm
npm install -g yarn

echo "=========================================================="
echo "brew clean list"
echo "=========================================================="
brew cleanup
brew list
sleep 2

echo "=========================================================="
echo "dotfiles"
echo "=========================================================="
# dotfilesレポをクローン
mkdir -p ~/git
cd ~/git
git clone https://github.com/serna37/dotfiles
# dotfilesをシンボックスリンク
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

echo "=========================================================="
echo "vim"
echo "=========================================================="
# コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cp ~/git/dotfiles/conf/vim/common-settings.vim ~/.vim/after/plugin/

echo "=========================================================="
echo "vim-plug"
echo "=========================================================="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "=========================================================="
echo "coc settings"
echo "=========================================================="
# coc用設定をシンボリックリンク
mkdir -p ~/.vim/UltiSnips
ln -nfs ~/git/dotfiles/conf/vim/coc-settings.json ~/.vim/coc-settings.json

echo "=========================================================="
echo "unfog"
echo "=========================================================="
# パスワード入力が必要
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | sh

echo "=========================================================="
echo "font"
echo "=========================================================="
cd ~/git
git clone --depth 1 https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts

echo "=========================================================="
echo "AtCoder"
echo "=========================================================="
cd ~/git
npm install -g atcoder-cli
# TODO 仮想環境必要！
#pip3 install --user online-judge-tools

echo "=========================================================="
echo "cpp debug snippets"
echo "=========================================================="
cp ~/git/dotfiles/conf/cpp/stdc++.h /opt/homebrew/Cellar/gcc@13/13.2.0/include/c++/13/aarch64-apple-darwin23/bits
cp ~/git/dotfiles/conf/cpp/debug.hpp /opt/homebrew/Cellar/gcc@13/13.2.0/include/c++/13/aarch64-apple-darwin23/bits
ln -nfs ~/git/dotfiles/snippets/* ~/.vim/UltiSnips/
cd ~/git
git clone https://github.com/serna37/library
cd library
zsh snippets.sh

echo "=========================================================="
echo "vim plug install"
echo "!! This is the last step."
echo "=========================================================="
vi -c "PlugInstall" -c "qa"

# zsh prompt
brew reinstall powerlevel10k

