# dev用コンテナ
FROM alpine
RUN apk update
RUN apk upgrade

# bash
RUN apk add bash zsh

# basic command
RUN apk add curl gzip

# for analyze
RUN apk add file exiftool

# for dev
RUN apk add vim git eza fzf fd bat ripgrep gum

# TODO ここからしたの入れ方を確かめてく
#gcc@12
#node
#python3 python-setuptools


# for zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# setup profile
COPY ./profile/.zshrc /root/.zshrc
COPY ./profile/.vimrc /root/.vimrc

# TODO nodeとgccは必須、pythonも必要かも

# ホストがarm64でもalpineはクロスアーキ
# x86_64でバイナリを実行させるためにglibcを入れる
# apk addはエラーが出るのでコンテナ立ち上げ時は無理、bashrcでやる
WORKDIR /tmp
RUN curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk

