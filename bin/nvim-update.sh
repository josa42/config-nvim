#!/usr/bin/env bash

set -eo pipefail

echo ""
echo "################################################################################"
echo "# Update neovim"

URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"

bin_dir="$HOME/bin"
dir="$bin_dir/neovim"
backup_name="neovim_${date}.tar.gz"
date=$(date "+%Y-%m-%d")

if [[ -d $dir ]]; then
  i=1

  while [[ -f "${bin_dir}/${backup_name}" ]]; do
    backup_name="neovim_${date}_${i}.tar.gz"
    i=$((i + 1))
  done

  echo "Backing up... $backup_name"
  (cd $bin_dir && tar -zcvf "${backup_name}" "neovim" 2>/dev/null)
fi

rm -rf $dir && mkdir -p $dir

curl -SsL $URL | tar zxv --strip-components=1 --directory=$dir 2>/dev/null

echo ""
echo "################################################################################"
echo "# Update config"

if [[ ! -d ~/.config/nvim ]]; then
  git clone git@github.com/josa42/config-nvim ~/.config/nvim
fi

(cd ~/.config/nvim && \
  if [[ -n "$(git status --porcelain)" ]]; then \
    echo "Local changes detected, creating temporary commit..." && \
    git add -A && \
    git commit -m "temp: auto-commit before update $(date '+%Y-%m-%d %H:%M:%S')" ; \
  fi && \
  git pull --rebase)

echo ""
echo "################################################################################"
echo "# Update plugins"

nvim --headless "+Lazy! sync" -c "qall"

echo ""
echo "################################################################################"
echo "# Update tools"

nvim --headless -c "MasonInstallAll" -c "qall"

echo ""
echo "################################################################################"
echo "# Update treesitter"

nvim --headless -c "TSUpdateSync" -c "qall"

