# brew install
repos=(
# base
git
vim
# enhanced
# ls cd
zoxide exa
# find
fzf fd fselect
# grep
ripgrep ripgrep-all
# cat
bat
# sed
sd
# diff chk-files
git-delta tokei
# df ps top ping
dust procs bottom gping
# help
navi
# text -> png
silicon
# IDE
code-minimap
# explorer
broot
# gif
ffmpeg
# lazy
lazygit lazydocker
# happy
sl cmatrix
# CLI
gh
# etc
watch
# lang
gcc
node
python3
rust
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
    brew install ${v}
    eval "${v} --version"
done

echo "=========================================================="
echo "service"
echo "=========================================================="
brew services list
brew services restart postgresql

# TODO いらんかも
echo "=========================================================="
echo "gdb"
echo "=========================================================="
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
arch -x86_64 /usr/local/bin/brew install gdb
