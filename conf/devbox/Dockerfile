FROM debian:bullseye-slim

# Enable multi-arch
# https://docs.orbstack.dev/machines/#multi-architecture
RUN dpkg --add-architecture amd64 \
    && apt update \
    && apt upgrade -y \
    && apt install -y libc6:amd64

RUN apt install -y \
    wget sudo time \
    curl zsh git \
    build-essential ca-certificates \
    gzip file exiftool

# for vim9
# https://uhoho.hatenablog.jp/entry/2023/05/09/033455
RUN apt install -y build-essential autoconf automake cproto \
    gettext libtinfo-dev libacl1-dev libgpm-dev \
    libxmu-dev libgtk-3-dev libxpm-dev \
    libperl-dev python3-dev ruby-dev \
    libncurses-dev \
    lua5.4 liblua5.4-dev \
    libsodium-dev libcanberra-dev tcl-dev \
    && git clone --depth 1 https://github.com/vim/vim.git \
    && cd vim/src \
    && ./configure --prefix=/root/.local --enable-multibyte --enable-cscope --enable-perlinterp --enable-python3interp --enable-rubyinterp --enable-luainterp --enable-fontset --enable-xim --enable-terminal --enable-fail-if-missing --with-x --enable-gui=gtk3 --enable-tclinterp \
    && make && make install \
    && ln -nfs /root/.local/bin/vim /usr/bin/vim

# for shared-register (clipboard)
RUN mkdir /shared-register

# dotfiles
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"

