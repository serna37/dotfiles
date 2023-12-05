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

brew cleanup
for v in ${repos[@]}; do
    brew install ${v}
done

# setup dotfile
mkdir -p ~/git \
    && git clone https://github.com/serna37/dotfiles
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

# copy file. to ignore commentout after LF
mkdir -p ~/.vim/after/plugin \
    && cp ~/git/dotfiles/after/plugin/common-settings.vim ~/.vim/after/plugin/

# ln coc-settings, snippets
npm install -g yarn
mkdir -p ~/.vim/UltiSnips \
    && ln -nfs ~/git/dotfiles/cpp.snippets ~/.vim/UltiSnips/cpp.snippets \
    && ln -nfs ~/git/dotfiles/coc-settings.json ~/.vim/coc-settings.json

# font
git clone --depth 1 https://github.com/powerline/fonts.git \
    && cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts

# silicon
# Install cargo
curl https://sh.rustup.rs -sSf | sh
# Install silicon
cargo install silicon

# AtCoder
pip3 install online-judge-tools
npm install -g atcoder-cli
cd ~/git && git clone https://github.com/serna37/ac

# unfog
# need password
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | zsh

# junegunn/vim-plug (required) & plug install
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install vim plugin
vi -c "PlugInstall" -c "qa"

# reload zsh
exec $SHELL -l
