# brew install
repos=(
# base
vim
git
# enhanced command
# cd ls find
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
trippy
yazi
veeso/termscp/termscp
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
gcc@12
node
python3
sqlite
postgresql@14
rust
go
java11
# zsh prompt
powerlevel10k
)

# 時間がかかるとfor文の次のコマンド実行しちゃうので、このshellではfor文だけ。
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
done

