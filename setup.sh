echo "=========================================================="
echo "dotfiles"
echo "=========================================================="
mkdir -p ~/git \
    && cd ~/git \
    && git clone https://github.com/serna37/dotfiles
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

echo "=========================================================="
echo "vim"
echo "=========================================================="
# copy file. to ignore commentout after LF
mkdir -p ~/.vim/after/plugin \
    && cp ~/git/dotfiles/after/plugin/common-settings.vim ~/.vim/after/plugin/

echo "=========================================================="
echo "vim-plug"
echo "=========================================================="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "=========================================================="
echo "coc settings"
echo "=========================================================="
# ln coc-settings, snippets
npm install -g yarn
mkdir -p ~/.vim/UltiSnips \
    && ln -nfs ~/git/dotfiles/cpp.snippets ~/.vim/UltiSnips/cpp.snippets \
    && ln -nfs ~/git/dotfiles/coc-settings.json ~/.vim/coc-settings.json

echo "=========================================================="
echo "unfog"
echo "=========================================================="
# need password
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | sh

echo "=========================================================="
echo "font"
echo "=========================================================="
# font
git clone --depth 1 https://github.com/powerline/fonts.git \
    && cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts

echo "=========================================================="
echo "AtCoder"
echo "=========================================================="
pip3 install online-judge-tools
npm install -g atcoder-cli
cd ~/git && git clone https://github.com/serna37/ac

echo "=========================================================="
echo "vim plug install"
echo "This is the last step."
echo "=========================================================="
echo "After this, you should execute"
echo "$ exec \$SHELL -l"
echo "to apply new configurations."
# TODO gdbいらんかも？？
echo "And sign code for gdb."
echo "ref) https://blog.symdon.info/posts/1610113408/"
echo "=========================================================="
vi -c "PlugInstall" -c "qa"

