repos=(
git
vim
zoxide
eza
fzf
bat
ripgrep
lazygit
lazydocker
gum
yazi
sshs
veeso/termscp/termscp
tako8ki/tap/gobang
ffmpeg
gh
silicon
code-minimap
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting
genact
tty-clock
cmatrix
gcc@12
node
python3
sqlite
postgresql@14
rust
go
java11
powerlevel10k
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
    brew reinstall ${v}
    wait $!
done

cask_repos=(
wezterm
orbstack
maccy
keycastr
)
echo "=========================================================="
echo "brew cask install"
echo "=========================================================="
for v in ${cask_repos[@]}; do
    echo "=========================================================="
    echo "${v}"
    echo "=========================================================="
    brew reinstall --cask ${v}
    wait $!
done

echo "=========================================================="
echo "brew clean list"
echo "=========================================================="
brew cleanup
brew list
sleep 2

# dotfilesの適用
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/setup.sh)"

