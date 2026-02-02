#!/bin/bash

# ==============================================
# MacとCodeSpaces(Linux)に対応したインストーラ
# ==============================================

# 1. Homebrewのセットアップ
OS="$(uname)"

if command -v brew &> /dev/null; then
    # すでにパスが通っている場合（Dev Containerのfeaturesなど）
    echo "Homebrew is already installed."
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    # Linuxでインストール済みだがパスが通っていない場合
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "/opt/homebrew/bin/brew" ]; then
    # Mac (Apple Silicon) でパスが通っていない場合
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # どこにもないので新規インストール
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # インストール直後のパス設定
    if [ "$OS" == "Linux" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# =====================================
# パッケージリスト
REPOS=(vim git sqlite)

# Mac専用リスト
CASK_REPOS=(ghostty wezterm orbstack maccy keycastr google-drive dbeaver-community another-redis-desktop-manager)
MAS_IDS=(1429033973 1187652334)
# =====================================

# 共通パッケージのインストール
echo "Installing common packages..."
for v in ${REPOS[@]}; do
    brew install $v
done

# Mac専用の処理（CaskとMAS）
if [ "$OS" == "Darwin" ]; then
    echo "Installing Mac specific apps..."
    for v in ${CASK_REPOS[@]}; do
        brew install --cask $v
    done
    for v in ${MAS_IDS[@]}; do
        mas install $v
    done
fi

# =====================================
# 設定・ドットファイルのリンク
# =====================================
if [ "$OS" == "Darwin" ]; then
    # Macの場合
    export GIT_REPO_ROOT=$HOME/git
elif [ -d "/workspaces" ]; then
    # Dev Container / Codespaces の場合
    export GIT_REPO_ROOT="/workspaces"
else
    # それ以外の Linux 等
    export GIT_REPO_ROOT="/workspaces"
fi

mkdir -p $GIT_REPO_ROOT
echo "GIT_REPO_ROOT is set to: $GIT_REPO_ROOT"

# すでに dotfiles というディレクトリがあるかチェック
if [ -d "$GIT_REPO_ROOT/dotfiles" ]; then
    echo "dotfiles already exists."
    DOTFILES_DIR="$GIT_REPO_ROOT/dotfiles"
elif [ -n "$CODESPACES" ]; then
    # Codespacesの自動クローン先（環境によって異なるが、通常は実行ディレクトリ）
    DOTFILES_DIR=$(pwd)
else
    # Macなどで初回実行時
    echo "Cloning dotfiles..."
    git clone https://github.com/serna37/dotfiles "$GIT_REPO_ROOT/dotfiles"
    DOTFILES_DIR="$GIT_REPO_ROOT/dotfiles"
fi

# シンボリックリンク作成
echo "Setting up symlinks..."
ln -nfs $DOTFILES_DIR/.zshrc ~/.zshrc
ln -nfs $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh
ln -nfs $DOTFILES_DIR/.vimrc ~/.vimrc

mkdir -p ~/.config/ghostty ~/.config/mise
ln -nfs $DOTFILES_DIR/ghostty_config ~/.config/ghostty/config
ln -nfs $DOTFILES_DIR/config.toml ~/.config/mise/config.toml

# =====================================
# Git設定
# =====================================
if [ "$OS" == "Darwin" ]; then
    git config --global credential.helper osxkeychain
else
    # Linux (Dev Container) では store または cache を使用
    git config --global credential.helper store
fi
