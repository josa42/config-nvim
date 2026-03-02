FROM ubuntu:24.04

ARG NVIM_VERSION=stable
ARG NODE_MAJOR=22

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    gzip \
    unzip \
    wget \
    ripgrep \
    fd-find \
    python3 \
    python3-pip \
    python3-venv \
    gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
       > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then \
      NVIM_ARCH="nvim-linux-arm64"; \
    else \
      NVIM_ARCH="nvim-linux-x86_64"; \
    fi && \
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCH}.tar.gz" \
    | tar xz -C /opt \
    && ln -s /opt/${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim

COPY . /root/.config/nvim

ENV HOME=/root

# Bootstrap plugins and install Mason packages headlessly
# Treesitter parsers compile on demand at runtime (building all 312 exceeds Docker memory)
RUN nvim --headless '+Lazy! sync' +qa \
    && nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'

WORKDIR /workspace

ENTRYPOINT ["nvim"]
