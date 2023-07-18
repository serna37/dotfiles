PROMPT='%K{green}%F{white}[%~]%f%k🍎%F{cyan}(ง ˙˘˙ )ว%f$(git_super_status)>'
HISTSIZE=10000

# alias
alias ls='ls -FG --color=auto'
alias ll='ls -AFGlihrt --color=auto'
alias vi='/usr/local/bin/vim'
alias vim='vi'
alias v='(){cd $1 && vi}'
alias c='cd&&clear'
alias iniv='(){mkdir $1 && cd $1 && curl https://raw.githubusercontent.com/serna37/vim/master/.vimspector.json > .vimspector.json && vi}'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ripgrep
export PATH="$PATH:/opt/homebrew/bin/rg/bin"
# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# python
export PATH="$PATH:/opt/homebrew/bin/python3"
alias python='python3'
# go
export PATH="$PATH:$HOME/work/go/bin"

# completion
# brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# git branch preview
# brew install zsh-git-prompt
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
