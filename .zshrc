# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================================
# START MY CUSTOM
# ======================================================
# git (over 2.20~)
# brew install git

# ======================================================
# PROMPT SETTINGS
# ======================================================
#PROMPT='%K{green}%F{white}[%~]%f%k🍎%F{cyan}(ง ˙˘˙ )ว%f$(git_super_status)>'
HISTSIZE=100000
SAVEHIST=100000
setopt no_beep

# font-icon
# https://github.com/powerline/fonts
# https://github.com/ryanoasis/nerd-fonts
# https://github.com/ryanoasis/vim-devicons

# starship-default-setting + powerlevel10k
# brew install starship
eval "$(starship init zsh)"

# brew install romkatv/powerlevel10k/powerlevel10k
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme

# cmd syntax
# git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git
source ~/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# completion
# brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# github cli
eval "$(gh completion -s zsh)"

# git branch preview
# brew install zsh-git-prompt
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

# ======================================================
# ALIAS
# ======================================================
# ls
alias ls='ls -FG --color=auto'
alias ll='ls -AFGlihrt --color=auto'
alias l='exa -abghHliS'
alias tree='exa -bghHliST'
alias zls='zoxide query -ls'
alias zrm='(){zoxide remove $1}'

# find
alias fd='fd -H -E .git -E .DS_Store -t f'
alias fzf="fzf --preview 'bat -n --color=always {}'"

# vi
alias v='vi -c "CocCommand explorer --no-focus --width 30" -c "echo '\''`basename $(pwd)`'\''"'
# for AtCoder
AtCoder() {
    cd ~/git/ac
    contest_cd=$1
    file_name="main.cpp"
    acc check-oj
    oj login https://atcoder.jp
    acc login
    acc config default-task-choice all
    acc config default-test-dirname-format test
    valid=`acc contest $contest_cd`
    if [[ $valid == ''  ]]; then
        echo -e "[\e[31mERROR\e[m]create faild."
        return
    fi
    acc new $contest_cd
    cd $contest_cd
    dirs=(`\fd -d 1 -t d`)
    for v in ${dirs[@]}; do
        echo -e "[\e[34mINFO\e[m]create file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    pd=`basename $(pwd)`
    vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify" -c "AtCoderTimer" -c "echom '$(basename $(pwd))'"
}
# cpp init
alias cppini='cp ~/git/dotfiles/.clang-format . && cp ~/git/dotfiles/compile_flags.txt .'

# zoxide & vi
alias zv='zi&&v'
export _ZO_FZF_OPTS='
    --no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
    --bind ctrl-f:page-down,ctrl-b:page-up
    --bind pgdn:preview-page-down,pgup:preview-page-up
    --prompt="❯ "
    --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
    --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
    --color prompt:#87afff,pointer:#ff5189,marker:#f09479
    --preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || exa --color=always --group-directories-first --oneline {2..}"
'

# dotfiles
alias zshrc='v ~/.zshrc'
alias vimrc='v ~/.vimrc'

# git
alias git='/opt/homebrew/Cellar/git/2.41.0_2/bin/git'
alias g='lazygit'

# util
alias ..='cd ..'
alias c='cd ~/git && clear'
alias w='date && cal && unfog'
alias cw='c&&w'
alias localhost_here='python -m http.server 8000'
alias q='exit'
alias rezsh='exec $SHELL -l'
alias app='open "$(\fd -t d -d 1 . /Applications | \fzf)"'
google() {
  local str opt
  if [ $# != 0 ]; then
    for i in $*; do
      str="$str${str:++}$i"
    done
    opt='search?num=100'
    opt="${opt}&q=${str}"
  fi
  open -a Google\ Chrome http://www.google.co.jp/$opt
}

# ======================================================
# ENHANCED COMMANDS
# ======================================================
# vim9.0
# brew install vim

# cd -> zoxide
# brew install zoxide
eval "$(zoxide init zsh)"

# ls -> exa
# brew install exa

# cat -> bat
# brew install bat

# grep -> ripgrep
# brew install ripgrep
export PATH="$PATH:/opt/homebrew/bin/rg/bin"

# find -> fd
# brew install fd

# fzf
# brew install fzf
# https://github.com/junegunn/fzf
# !! I clone this by vim function as plugin
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# sed -> sd
# brew install sd

# ps -> procs
# brew install procs

# git -> lazygit
# brew install lazygit

# ======================================================
# DEV-TOOLS, LANGUAGES, PATH
# ======================================================
# yarn
# brew install node
# npm install -g yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# python
# brew install python3
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
alias pip='python -m pip'

# go
# brew install go
export PATH="$PATH:$HOME/work/go/bin"

# java
# brew install java11
PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home -v 11`

# Rust
# Install cargo
#curl https://sh.rustup.rs -sSf | sh
# Install silicon
#cargo install silicon
# Add cargo-installed binaries to the path
export PATH="$PATH:$CARGO_HOME/bin"

# Chat GPT
# python -m pip install openai
# XXX OLD
# export OPENAI_API_KEY='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'

# ======================================================
# NOTE
# ======================================================

# -- how to kill finder
# defaults write com.apple.Finder QuitMenuItem -boolean true
# killall Finder

# ======================================================
# EOF
# ======================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
