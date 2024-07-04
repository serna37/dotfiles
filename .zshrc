
echo -e "[\e[34mINFO\e[m] \e[32mload zshrc\e[m"
echo "===[Utility Summary]==="

# ======================================================
# PROMPT SETTINGS
# ======================================================
HISTSIZE=100000
SAVEHIST=100000
setopt no_beep

# alias
source ~/git/dotfiles/conf/zsh/.zshrc.alias
# 強化コマンド
source ~/git/dotfiles/conf/zsh/.zshrc.enhanced
# C++用設定
source ~/git/dotfiles/conf/cpp/.zshrc.cpp

# ======================================================
# PATH
# ======================================================
# brew
export PATH="$PATH:/opt/homebrew/bin/"

# Rust
export PATH="$PATH:$CARGO_HOME/bin"

# Python
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
alias pip='python -m pip'

# Go
export PATH="$PATH:$HOME/work/go/bin"

# Java
PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home -v 11`

