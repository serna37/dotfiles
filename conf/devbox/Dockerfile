# dev用コンテナ
FROM alpine
RUN apk update
RUN apk upgrade

# 必要なコマンド
RUN apk add bash file curl
RUN apk add vim git

# ホストがarm64でもalpineはクロスアーキ
# x86_64でバイナリを実行させるためにglibcを入れる
# apk addはエラーが出るのでコンテナ立ち上げ時は無理、bashrcでやる
WORKDIR /tmp
RUN curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk

