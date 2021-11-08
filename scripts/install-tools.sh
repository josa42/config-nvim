#!/bin/bash

set -e

TOOLS=(
  "bash-language-server"
  "docker-langserver"
  "eslint_d"
  "fixjson"
  "gopls"
  "lua-language-server"
  "tsserver"
  "vim-language-server"
  "vscode-langservers-extracted"
  "yaml-language-server"
)

export NVIM_TOOLS_BIN="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-tools/bin"

mkdir -p $NVIM_TOOLS_BIN

DIR=$(cd $(dirname $BASH_SOURCE) && pwd)

for f in $(find $DIR/installer -type f -depth 1); do
  if [[ " ${TOOLS[@]} " == *" $(echo $f | sed 's#\.sh$##' | xargs basename) "* ]]; then
    export NVIM_TOOLS_TMP="$TMPDIR/nvim-tools_$(date +%s)"
    mkdir -p $NVIM_TOOLS_TMP

    $f

    rm -rf $NVIM_TOOLS_TMP
  fi
done


