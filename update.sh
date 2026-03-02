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

(cd ~/.config/nvim && git pull)

echo ""
echo "################################################################################"
echo "# Update plugins"

nvim --headless "+Lazy! sync" -c "qall"

echo ""
echo "################################################################################"
echo "# Update tools"

nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'

echo ""
echo "################################################################################"
echo "# Update treesitter"

nvim --headless -c 'lua vim.notify = function(msg, ...) io.write(msg .. "\n") end' -c "TSUpdateSync" -c "qall"

