# brew install
repos=(
git
vim
zoxide
fzf
bat
fd
exa
ripgrep
sd
dust
procs
bottom
silicon
watch
broot
gping
sl
cmatrix
lazygit
lazydocker
gh
ffmpeg
code-minimap
gcc
node
python3
rust
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
brew list
brew cleanup
for v in ${repos[@]}; do
    brew install ${v}
    eval "${v} --version"
done
