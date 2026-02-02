#!/bin/bash

# MacとCodeSpaces(Linux)に対応したインストーラ
OS="$(uname)"

# =====================================
# 1. Homebrewのセットアップ
# =====================================
# Macならsudo実行のため対話、codespaces中ではnon interactiveで実行
/bin/bash -c "$( [[ -n "$CODESPACES" ]] && echo "NONINTERACTIVE=1 " )$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ "$OS" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# =====================================
# 2. 共通パッケージのインストール
# =====================================
REPOS=(vim git sqlite)
for v in ${REPOS[@]}; do
    brew reinstall $v
done
# Mac専用
CASK_REPOS=(ghostty wezterm orbstack maccy keycastr google-drive dbeaver-community another-redis-desktop-manager)
MAS_IDS=(
1429033973 # RunCat
1187652334 # Fuwari
)
if [[ "$OS" == "Darwin" ]]; then
    for v in ${CASK_REPOS[@]}; do
        brew reinstall --cask $v
    done
    brew reinstall mas
    for v in ${MAS_IDS[@]}; do
        mas install $v
    done
fi

# =====================================
# 3. ファイルのリンク
# =====================================
if [ -n "$CODESPACES" ]; then
    # CodeSpaces中の場合
    export GIT_REPO_ROOT="/workspaces"
else
    export GIT_REPO_ROOT="$HOME/git"
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
ln -nfs $DOTFILES_DIR/.zshrc ~/.zshrc
ln -nfs $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh
ln -nfs $DOTFILES_DIR/.vimrc ~/.vimrc
mkdir -p ~/.config/ghostty ~/.config/mise
ln -nfs $DOTFILES_DIR/ghostty_config ~/.config/ghostty/config
ln -nfs $DOTFILES_DIR/config.toml ~/.config/mise/config.toml

# =====================================
# 4. Git認証設定
# =====================================
if [[ "$OS" == "Darwin" ]]; then
    GIT_CREDENTIAL_HELPER="osxkeychain"
else
    GIT_CREDENTIAL_HELPER="store"
fi
git config --global credential.helper $GIT_CREDENTIAL_HELPER

# =====================================
# 5. Mac固有設定
# =====================================
if [[ "$OS" == "Darwin" ]]; then
    # fontを入れる 三角のやつ
    cd $GIT_REPO_ROOT
    git clone --depth 1 https://github.com/powerline/fonts.git
    cd fonts
    ./install.sh
    cd ..
    \rm -rf fonts

    # fontを入れる icon系
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh
    cd ..
    \rm -rf nerd-fonts

    # Finderのキルを有効化するコマンド
    defaults write com.apple.Finder QuitMenuItem -boolean true
    # Finderが.DS_sotreを作らないようにするコマンド
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    # デフォルトで隠しファイルを表示する
    defaults write com.apple.finder AppleShowAllFiles -bool true
fi

# =====================================
# END. reboot shell
# =====================================
exec $SHELL -l
