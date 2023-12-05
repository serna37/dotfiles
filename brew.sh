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
watch
lazygit
lazydocker
gh
ffmpeg
code-minimap
gcc
node
python3
go
java11
postgresql@14
sqlite
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
    ${v} --version
done

exa -abghHliS
