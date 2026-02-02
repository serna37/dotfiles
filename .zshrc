clear

# ====================================
# 環境分岐
# ====================================

# Gitレポのルート
if [ -n "$CODESPACES" ]; then
    # CodeSpaces中の場合
    export GIT_REPO_ROOT="/workspaces"
else
    export GIT_REPO_ROOT="$HOME/git"
fi

# dotfilesのパス
if [ -n "$DOTFILES" ]; then
    # Codespaces が公式にセットする変数がある場合
    DOTFILES_DIR="$DOTFILES"
elif [ -n "$CODESPACES" ] && [ -d "/workspaces/.dotfiles" ]; then
    # 変数はないが、標準的なパスに存在する場合
    DOTFILES_DIR="/workspaces/.dotfiles"
else
    DOTFILES_DIR="${GIT_REPO_ROOT:-$HOME/git}/dotfiles"
fi

# Homebrewのパスを動的に取得
BREW_PREFIX=$(brew --prefix)

# ====================================
# プロンプト設定
# ====================================
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep

# zshの補完
autoload -Uz compinit
compinit -u

# シンタックスハイライト
[[ ! -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && brew install zsh-syntax-highlighting
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# コマンド補完 →キーで補完する
[[ ! -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && brew install zsh-autosuggestions
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# 外観
[[ ! -f "$BREW_PREFIX/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && brew install powerlevel10k
source "$BREW_PREFIX/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================
# カスタムコマンド・ツール
# ====================================

# 初期化用
type zoxide > /dev/null && eval "$(zoxide init zsh)"
type mise > /dev/null && eval "$(mise activate zsh)"

# fzf-previewのためにripgrepが必要
type rg > /dev/null || brew install ripgrep

# zoxide設定
export _ZO_FZF_OPTS='
--no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
--prompt="❯ "
--color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
--color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
--color prompt:#87afff,pointer:#ff5189,marker:#f09479
--preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'

# vim
alias vim='export VIM_PLUGIN_ENABLE=0 && \vim'
alias v='export VIM_PLUGIN_ENABLE=1 && \vim'

# LazyInstall
function li() {
    for c in "$@"; do type "$c" >/dev/null 2>&1 || brew install "$c"; done
}
alias z='li zoxide eza fzf bat; eval "$(zoxide init zsh)"; zi'
alias e='li yazi; yazi'
alias l='li eza; eza -abghHliS --icons --git'
alias g='li lazygit; lazygit'
alias dev='li mise; eval "$(mise activate zsh)"; mise run'

# ベースコマンド
alias cdg="cd $GIT_REPO_ROOT"
alias re='exec $SHELL -l'
alias rm='rm -i'
alias q='exit'


# ====================================
# 設定ファイルの書き出し
# ====================================

# vim コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cat - << "EOF" > ~/.vim/after/plugin/common-settings.vim
au FileType * setlocal formatoptions-=ro
EOF

# vim coc.json
cat - << "EOF" > ~/.vim/coc-settings.json
{
    "snippets.priority": 10000,
    "explorer.icon.enableNerdfont": true,
    "explorer.file.showHiddenFiles": true,
    "inlayHint.enable": false,
    "clangd.arguments": [
        "--header-insertion=never"
    ],
    "python.formatting.provider": "yapf",
    "snippets.ultisnips.pythonPrompt": false
}
EOF

# vim coc-snippets cpp
mkdir -p ~/.config/coc/ultisnips
ln -nfs $DOTFILES_DIR/cpp.snippets ~/.config/coc/ultisnips/cpp.snippets

# yaziの設定
mkdir -p ~/.config/yazi
cat - << "EOF" > ~/.config/yazi/yazi.toml
[manager]
show_hidden = true
EOF

# git設定
git config --global pull.prune true
git config --global fetch.prune true
if [[ "$(uname)" == "Darwin" ]]; then
    GIT_CREDENTIAL_HELPER="osxkeychain"
else
    GIT_CREDENTIAL_HELPER="store"
fi
cat - << EOF > ~/.gitconfig
[user]
    name = さーな
    email = 37serna37serna37serna@gmail.com

[credential]
    helper = $GIT_CREDENTIAL_HELPER
EOF

# ssh接続設定
mkdir -p ~/.ssh
if [[ "$(uname)" == "Darwin" ]]; then
cat - << "EOF" > ~/.ssh/config
# Added by OrbStack
# This only works if it's at the top of ssh_config (before any Host blocks).
Include ~/.orbstack/ssh/config

Host *
  # SSH接続を10倍速くする
  # https://qiita.com/suin/items/1708dc78fc412297f885
  ControlMaster auto
  ControlPath ~/.ssh/mux-%r@%h:%p
  ControlPersist 4h
  # パスフレーズの保存と複合
  # https://qiita.com/kaino5454/items/98dcf3a996f2074e0074
  AddKeysToAgent yes
  UseKeychain yes
EOF
fi


# ====================================
# C++とAtCoder用設定
# ====================================
source "$DOTFILES_DIR/cpp.zsh"


# ====================================
# 主要コマンドの表記
# ====================================
echo -e "\e[34mCommands:\e[32m v z e l g dev\e[m   \e[34mC++:\e[32m solve\e[m"

