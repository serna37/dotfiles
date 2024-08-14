#!/bin/bash

# いったん不要と判断
#sshs
#postgresql@14
#rust
#go
#java11
if [ "$(uname)" = "Darwin" ]; then
# ===============================
REPOS=(vim git gh mas
llvm gcc@12 node python3 sqlite
)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH="$PATH:/opt/homebrew/bin/"
for v in ${REPOS[@]}; do
    brew reinstall $v
    wait $!
done
CASK_REPOS=(wezterm orbstack maccy keycastr)
for v in ${CASK_REPOS[@]}; do
    brew reinstall --cask $v
    wait $!
done
MAS_IDS=(
1429033973 # RunCat
1187652334 # Fuwari
)
for v in ${MAS_IDS[p]}; do
    mas install $v
    wait $!
done
# ===============================
else
# ===============================
repos=(zoxide fzf bat ripgrep screenfetch
python3 python3-venv pip clangd sqlite3)
for v in ${repos[@]}; do
    apt install -y $v
    wait $!
done
# node
apt install -y nodejs npm
npm install n -g
n lts
n latest
apt purge -y nodejs npm
# eza
sudo apt install -y gpg
mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
# batcat -> bat
mkdir -p ~/.local/bin
ln -nfs /usr/bin/batcat ~/.local/bin/bat
# gum
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install -y gum
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# デフォルトのshellをzshに
chsh -s /bin/zsh
export SHELL=/bin/zsh
# ===============================
fi

# dotfiles
mkdir -p ~/git && cd ~/git
git clone https://github.com/serna37/dotfiles
ln -nfs ~/git/dotfiles/.zshrc ~/.zshrc
ln -nfs ~/git/dotfiles/conf/zsh/.p10k.zsh ~/.p10k.zsh
ln -nfs ~/git/dotfiles/.vimrc ~/.vimrc
ln -nfs ~/git/dotfiles/.wezterm.lua ~/.wezterm.lua

# font
cd ~/git
git clone --depth 1 https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
\rm -rf fonts

# git
if [ "$(uname)" = "Darwin" ]; then
    # 最初だけ認証が必要
    # OSキーチェーンに保存する
    git config --global credential.helper osxkeychain
    # git config --global credential.helper store
    # git config --global credential.helper store --file ファイルパス

    # gh
    if ! gh auth status > /dev/null 2>&1; then
        gh auth login
    fi
fi

exec $SHELL -l

