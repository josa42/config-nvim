# FROM ubuntu:latest
# COPY . /root/.config/nvim
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt update && \
#   apt install -y curl && \
#   rm -rf /var/lib/apt/lists/*
#
# RUN \
#   curl -sSL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz > nvim-linux64.tar.gz \
#   tar -xf nvim-linux64.tar.gz
#
#
# CMD bash

FROM ubuntu:20.04 AS builder

ARG BUILD_APT_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils"
ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt update && apt upgrade -y && \
  apt install -y ${BUILD_APT_DEPS}

RUN \
  git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
  git fetch --all --tags -f

ARG TARGET=master
RUN \
  cd /tmp/neovim && \
  git checkout ${TARGET} && \
  make CMAKE_BUILD_TYPE=Release && \
  make CMAKE_INSTALL_PREFIX=/usr/local install && \
  strip /usr/local/bin/nvim

RUN \
  apt update && apt upgrade -y && \
  apt install -y curl

RUN \
  curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ENV XDG_DATA_HOME=/root/.local/share
ENV XDG_CONFIG_HOME=/root/.config

RUN \
  apt update && apt upgrade -y && \
  apt install -y make golang

COPY . /root/.config/nvim
RUN \
  /usr/local/bin/nvim -c 'PlugInstall --sync | qa!'


FROM ubuntu:20.04
RUN \
  apt update && apt upgrade -y && \
  apt install -y git golang && \
  rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local /usr/local/
COPY --from=builder /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder /root/.config/nvim /root/.config/nvim

CMD ["/usr/local/bin/nvim"]
