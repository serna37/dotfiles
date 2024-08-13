# TODO [WIP] OS判定だけど、CentOS系もLinuxなので、aptなのかyumなのか判断つかない。

source ~/git/dotfiles/conf/zsh/.zshrc.dotfiles_conf
source ~/git/dotfiles/conf/zsh/.zshrc.prompt
source ~/git/dotfiles/conf/zsh/.zshrc.lang_path
source ~/git/dotfiles/conf/zsh/.zshrc.install_necessary
source ~/git/dotfiles/conf/zsh/.zshrc.cmds
source ~/git/dotfiles/conf/zsh/.zshrc.dev_tools
source ~/git/dotfiles/conf/zsh/.zshrc.toolbox
source ~/git/dotfiles/conf/zsh/.zshrc.devbox

clear
info 'Load ~/.zshrc'
if [ "$(uname)" = "Darwin" ]; then
    _install_not_exist_fastfetch
    fastfetch
fi
if [ "$(uname)" = "Linux" ]; then
    _install_not_exist_screenfetch
    screenfetch
fi

