# dev用コンテナ
FROM alpine
RUN apk update && apk upgrade

# bash
RUN apk add bash zsh

# basic command
RUN apk add curl gzip

# for analyze
RUN apk add file exiftool

# for dev
RUN apk add vim git eza fzf fd bat ripgrep gum

# languages
RUN apk add nodejs npm python3
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/v3.18/main g++~=12

# TODO gobangいれたい
# TODO vim中のfzfが動かない
# TODO vim中でclangdがないと言われる
# TODO vim中のヤンクがクリップボードにこない
# TODO install.shが悪い？スニペットがUltiSnips内にコピーできてない

# for zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# setup profile
COPY profile/ /root/
RUN zsh /root/install.sh

# ホストがarm64でもalpineはクロスアーキ
# x86_64でバイナリを実行させるためにglibcを入れる
# apk addはエラーが出るのでコンテナ立ち上げ時は無理、bashrcでやる
WORKDIR /tmp
RUN curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk

