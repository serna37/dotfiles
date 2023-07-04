PROMPT='%K{green}%F{white}[%~]%f%k🍎%F{cyan}(ง ˙˘˙ )ว%f$(git_super_status)>'
HISTSIZE=10000

# vim
alias vi='/usr/local/bin/vim'
alias vim='/usr/local/bin/vim'

# ripgrep
export PATH="$PATH:/opt/homebrew/bin/rg/bin"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# python
export PATH="$PATH:/opt/homebrew/bin/python3"

# go
export PATH="$PATH:$HOME/work/go/bin"

# alias
alias ll='ls -AFGlihrt --color=auto'

# completion
# brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# git branch preview
# brew install zsh-git-prompt
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
