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
install_cmd=brew
for v in ${repos[@]}; do
    install_cmd="${install_cmd} ${v}"
done
# TODO unlock echo
echo $install_cmd

# setup dotfile
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

# reload zsh
exec $SHELL -l

# copy file. to ignore commentout after LF
mkdir -p ~/.vim/after/plugin \
    && cp ~/git/dotfiles/after/plugin/common-settings.vim ~/.vim/after/plugin/

# ln coc-settings, snippets
mkdir -p ~/.vim/UltiSnips \
    && ln -nfs ~/git/dotfiles/cpp.snippets ~/.vim/UltiSnips/cpp.snippets \
    && ln -nfs ~/git/dotfiles/coc-settings.json ~/.vim/coc-settings.json

# font
mkdir -p ~/git \
    && git clone --depth 1 https://github.com/powerline/fonts.git \
    && cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts

# junegunn/vim-plug (required) & plug install
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install vim plugin
vi -c "PlugInstall"
