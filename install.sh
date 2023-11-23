# TODO


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








