# ======================================================
# PROMPT SETTINGS
# ======================================================
HISTSIZE=100000
SAVEHIST=100000
setopt no_beep
echo " 'hello' command is tutorial !!"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# starship-default-setting + powerlevel10k
eval "$(starship init zsh)"
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme

# cmd syntax
source ~/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# completion
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# github cli
eval "$(gh completion -s zsh)"

# git branch preview
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

# ======================================================
# ALIAS
# ======================================================

# enhanced

# vi
alias v='vi -c "CocCommand explorer --no-focus --width 30" -c "echom '\''$(basename $(pwd))'\''"'
alias zv='zi && v'

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
alias f='bat "$(fd | fzf)"'

# grep cat
alias grep='rg'
alias cat='bat'

# df ps top
alias df='dust'
alias ps='procs'
alias top='btm'

# cd
alias ..='cd ..'
alias c='cd ~/git && clear'
alias cc='cd'

# tools
alias g='lazygit'
alias d='lazydocker'
alias localhost_here='python -m http.server 8000'
alias cppini='cp ~/git/dotfiles/.clang-format . && cp ~/git/dotfiles/compile_flags.txt .'
alias app='open "$(\fd -t d -d 1 . /Applications | \fzf)"'

# util
alias q='exit'
alias rezsh='exec $SHELL -l'
alias w='c && date && cal && unfog'
alias sl='sl -aFc'
alias hello='c && df && sleep 1 \
    && ps && top && c && l && sleep 1 \
    && w && sleep 1 \
    && zv && g && AtCoder abc100 && sl && cmatrix && echo HELLO WORLD !!'
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
        echo -e "[\e[34mINFO\e[m]touch file :\e[32m${v}${file_name}\e[m"
        touch "${v}${file_name}"
    done
    vi -c "CocCommand explorer --no-focus --width 30" -c "AtCoderStartify" -c "AtCoderTimer" -c "echom '$(basename $(pwd))'"
}

# ======================================================
# ENHANCED COMMAND SETTINGS
# ======================================================
export PATH="$PATH:/opt/homebrew/bin/"
eval "$(zoxide init zsh)"
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

# ======================================================
# DEV-TOOLS, LANGUAGES, PATH
# ======================================================
# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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

# Chat GPT
# python -m pip install openai
# export OPENAI_API_KEY=''

# ======================================================
# NOTE
# ======================================================

# -- how to kill finder
# defaults write com.apple.Finder QuitMenuItem -boolean true
# killall Finder

# ======================================================
# EOF
# ======================================================
