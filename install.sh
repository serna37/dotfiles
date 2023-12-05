# brew install
repos=(
git
vim
zoxide
fzf
exa
bat
fd
ripgrep
sd
procs
lazygit
lazydocker
gh
code-minimap
gcc
node
python3
go
java11
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting
romkatv/powerlevel10k/powerlevel10k
starship
)

echo "===========================START==========================="
echo "brew install"
echo "=========================================================="
brew cleanup
for v in ${repos[@]}; do
    brew install ${v}
done

echo "=========================================================="
echo "dotfiles"
echo "=========================================================="
mkdir -p ~/git \
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
echo "coc"
echo "=========================================================="
# ln coc-settings, snippets
npm install -g yarn
mkdir -p ~/.vim/UltiSnips \
    && ln -nfs ~/git/dotfiles/cpp.snippets ~/.vim/UltiSnips/cpp.snippets \
    && ln -nfs ~/git/dotfiles/coc-settings.json ~/.vim/coc-settings.json

echo "=========================================================="
echo "rust"
echo "=========================================================="
curl https://sh.rustup.rs -sSf | sh

echo "=========================================================="
echo "silicon"
echo "=========================================================="
cargo install silicon

echo "=========================================================="
echo "unfog"
echo "=========================================================="
# need password
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | zsh

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
echo "=========================================================="
sudo vi -c "PlugInstall" -c "qa"

echo "=========================================================="
echo "END"
echo "exec $SHELL -l"
echo "=========================================================="

# reload zsh
exec $SHELL -l
