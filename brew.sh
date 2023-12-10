# brew install
repos=(
git
vim
zoxide
fzf
bat
exa
ripgrep
ripgrep-all
fd
sd
dust
procs
bottom
gping
silicon
code-minimap
broot
ffmpeg
sl
cmatrix
watch
lazygit
lazydocker
gh
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

echo "=========================================================="
echo "service"
echo "=========================================================="
brew services list
brew services restart postgresql

# TODO いらんかも
#echo "=========================================================="
#echo "gdb"
#echo "=========================================================="
#arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#arch -x86_64 /usr/local/bin/brew install gdb
