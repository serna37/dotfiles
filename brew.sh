# brew install
repos=(
# base
vim
git
# enhanced cd ls find
zoxide
eza
fzf
fd
fselect
# cat sed grep
bat
sd
ripgrep
ripgrep-all
# diff summary
git-delta
tokei
# explorer
broot
# df ps top ping
dust
procs
bottom
gping
# utils
coreutils
watch
ffmpeg
# TUI
lazygit
lazydocker
# GitHub CLI
gh
# Code Tool
silicon
code-minimap
# zsh suggestion
navi
peco
zsh-git-prompt
zsh-autosuggestions
zsh-syntax-highlighting
# happy
sl
cmatrix
tty-clock
genact
# lang
gcc@13
rust
python3
node
go
java11
postgresql@14
sqlite
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
    eval "${v} --version"
done
echo "npm yarn install"
npm install -g npm
npm install -g yarn

