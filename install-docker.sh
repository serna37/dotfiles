#!/bin/bash

repos=(
zoxide
fzf
bat
ripgrep
screenfetch
python3
python3-venv
pip
clangd
sqlite3
#postgresql@14
#rust
#go
#java11
)
echo "===========================START==========================="
echo "apt install"
echo "=========================================================="
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

# dotfilesの適用
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/setup.sh)"

