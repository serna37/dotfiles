clear

# ====================================
# プロンプト設定
# ====================================
# zshの補完
autoload -Uz compinit
compinit

HISTSIZE=1000
SAVEHIST=1000
setopt no_beep

# シンタックスハイライト
[[ ! -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && brew install zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# コマンド補完 →キーで補完する
[[ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 外観
[[ ! -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]] && brew install powerlevel10k
source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================
# カスタムコマンド・ツール
# ====================================

# rmのセーフガード
alias rm='rm -i'
# shell再起動
alias re='exec $SHELL -l'
# exit
alias q='exit'

# python3を使う
alias python='python3'
alias pip='python3 -m pip'

# miseで入れたツールのパスを通す
eval "$(mise activate zsh)"
alias dev='mise run'

# zoxide
# + eza fzf bat
function _zoxide() {
    type zoxide > /dev/null 2>&1 || brew install zoxide
    type eza > /dev/null 2>&1 || brew install eza
    type fzf > /dev/null 2>&1 || brew install fzf
    type bat > /dev/null 2>&1 || brew install bat
    eval "$(zoxide init zsh)"
    zi
}
export _ZO_FZF_OPTS='
    --no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
    --prompt="❯ "
    --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
    --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
    --color prompt:#87afff,pointer:#ff5189,marker:#f09479
    --preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'
alias z='_zoxide'

# yazi
function e() {
    type yazi > /dev/null 2>&1 || brew install yazi
    yazi
}

# eza (ls -AFGlihrt --color=auto)
function l() {
    type eza > /dev/null 2>&1 || brew install eza
    eza -abghHliS --icons --git $@
}

# lazygit
function g() {
    type lazygit > /dev/null 2>&1 || brew install lazygit
    lazygit
}

# ====================================
# 設定ファイルの書き出し
# ====================================

# vim コメント行から改行した際、次の行をコメントにしない設定
mkdir -p ~/.vim/after/plugin
cat - << "EOF" > ~/.vim/after/plugin/common-settings.vim
au FileType * setlocal formatoptions-=ro
EOF

# yaziの設定
mkdir -p ~/.config/yazi
cat - << "EOF" > ~/.config/yazi/yazi.toml
[manager]
show_hidden = true
EOF

# git設定
cat - << "EOF" > ~/.gitconfig
[user]
    name = さーな
    email = 37serna37serna37serna@gmail.com

[credential]
    helper = osxkeychain
EOF

# ssh接続設定
mkdir -p ~/.ssh
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

echo -e "\e[34mCommands \e[35m(file)\e[32m z e l \e[35m(tool)\e[33m g dev\e[m"

