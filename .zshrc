
# 使用時に必要なコマンドを入れる
source ~/git/dotfiles/conf/zsh/.zshrc.lazyload

if [ "$(uname)" = "Darwin" ]; then
    # brew
    export PATH="$PATH:/opt/homebrew/bin/"

    # Python
    _lazy_install_python
    export PATH="$PATH:/opt/homebrew/bin/python3"
    alias python='python3'
    alias pip='python -m pip'

    # nvm
    _lazy_install_nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ "$(uname)" = "Linux" ]; then
    export SHELL=/bin/zsh
    export PATH="$PATH:$HOME/.local/bin"
    alias python='python3'
fi

source ~/git/dotfiles/conf/zsh/.zshrc.dotfiles_conf
source ~/git/dotfiles/conf/zsh/.zshrc.prompt
source ~/git/dotfiles/conf/zsh/.zshrc.cmds
source ~/git/dotfiles/conf/zsh/.zshrc.dev_tools
source ~/git/dotfiles/conf/zsh/.zshrc.toolbox
source ~/git/dotfiles/conf/zsh/.zshrc.hackbox
source ~/git/dotfiles/conf/zsh/.zshrc.devbox

clear
info 'Load ~/.zshrc'
# TODO [WIP] 各所でやってるOS判定だけど、CentOS系もLinuxなので、aptなのかyumなのか判断つかない。
# パッケージ管理コマンド自体で判断しようにもMacはapt、複雑なifになるかも?
if [ "$(uname)" = "Darwin" ]; then
    _lazy_install fastfetch
    fastfetch
fi
if [ "$(uname)" = "Linux" ]; then
    _lazy_install screenfetch
    screenfetch
fi

