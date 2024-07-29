# ======================================================
# 持ち込んだプロファイルのインストールなど
# dotfilesのinstall.shに該当するもの
# ======================================================
mkdir -p ~/git && cd ~/git

# vim共通設定
mkdir -p ~/.vim/after/plugin
cp -f ~/vim/common-settings.vim ~/.vim/after/plugin/

# vim coc用設定
mkdir -p ~/.vim/UltiSnips
cp -f ~/vim/coc-settings.json ~/.vim/coc-settings.json

# atcoder
npm install -g atcoder-cli

# C++ スニペット
mkdir -p ~/git/dotfiles/snippets/
cp ~/snippets/* ~/git/dotfiles/snippets/
cp ~/git/dotfiles/snippets/* ~/.vim/UltiSnips

# C++ ライブラリ
git clone -b develop https://github.com/serna37/library
cd library
zsh snippets.sh
# library/snipet.shはシンボリックリンクを無視するが、cpしているので
# もっかいコピーする (cpp.snippetsに書き込むために、事前にも必要)
cp ~/git/dotfiles/snippets/* ~/.vim/UltiSnips

# vim initiation
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall" -c "qa"

