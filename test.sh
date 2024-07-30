OS_NAME=$(uname -s)
if [[ $OS_NAME == "Darwin" ]]; then
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/test-mac.sh)"
elif [[ $OS_NAME == "Linux" ]]; then
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/test-docker.sh)"
fi

