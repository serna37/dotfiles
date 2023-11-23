# TODO

# setup dotfile
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc

# copy file. to ignore commentout after LF
mkdir -p ~/.vim/after/plugin \
    && cp ~/git/dotfiles/after/plugin/common-settings.vim ~/.vim/after/plugin/

# ln coc-settings, snippets
mkdir -p ~/.vim/UltiSnips \
    && ln -nfs ~/git/dotfiles/cpp.snippets ~/.vim/UltiSnips/cpp.snippets \
    && ln -nfs ~/git/dotfiles/coc-settings.json ~/.vim/coc-settings.json

# junegunn/vim-plug (required) & plug install
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vi -c "PlugInstall"

echo '############################################################'
echo '## brew install  ##'
echo '############################################################'

# TODO 全部shellか、手順をreadmeにするかなやむな

repos=(
"vim"
"git"
"lazygit"
"node"
"starship"
"zsh-git-prompt"
"zsh-autosuggestions"
"romkatv/powerlevel10k/powerlevel10k"
"exa"
"zoxide"
"bat"
"fzf"
"fd"
"sd"
"procs"
"ripgrep"
"python3"
"go"
"java11"
)

install_cmd="brew"

for v in ${repos[@]}; do
    echo $v
    install_cmd="${install_cmd} ${v}"
    # brew install $v
done

echo $install_cmd








# reload zsh
exec $SHELL -l

