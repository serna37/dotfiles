<img src="https://img.shields.io/badge/-Vim-019733.svg?logo=vim&style=flat">

## v2
my vim custom with many plugins.

## installation
need [junegunn/vim-plug](https://github.com/junegunn/vim-plug) .
```sh
# junegunn/vim-plug (required)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy file. to ignore commentout after LF
mkdir -p ~/.vim/after/plugin && cp after/plugin/common-settings.vim ~/.vim/after/plugin/

# node & yarn
brew install node
npm install -g yarn

# lazygit
brew install lazygit

# bat
brew install bat

# ripgrep
brew install ripgrep

# code-minimap
brew install code-minimap

# unfog
curl -sSL https://raw.githubusercontent.com/soywod/unfog/master/install.sh | bash

# silicon
# Install cargo
curl https://sh.rustup.rs -sSf | sh

# Install silicon
cargo install silicon

# Add cargo-installed binaries to the path
export PATH="$PATH:$CARGO_HOME/bin"

# for Ac
pip3 install online-judge-tools
npm install -g atcoder-cli
acc check-oj
```

## monolithic version
https://github.com/serna37/vim
