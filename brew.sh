# brew install
repos=(
# base
vim git
# enhanced
# cd ls find
zoxide exa
fzf fd fselect
# cat sed grep
bat sd
ripgrep ripgrep-all
# diff summary explorer
git-delta tokei broot
# df ps top ping
dust procs bottom gping
# suggestion utils
navi
silicon
code-minimap
lazygit lazydocker
watch
ffmpeg
gh
# happy
sl cmatrix tty-clock genact
# lang
gcc
rust
python3
node
go
java11
postgresql@14
sqlite
# zsh
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting
romkatv/powerlevel10k/powerlevel10k
starship
)

echo "===========================START==========================="
echo "brew install"
echo "=========================================================="
brew list
brew cleanup
for v in ${repos[@]}; do
    echo "=========================================================="
    echo "${v}"
    echo "=========================================================="
    brew install ${v}
    eval "${v} --version"
done

echo "=========================================================="
echo "service"
echo "=========================================================="
brew services list
brew services restart postgresql

