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
  "stylelint-lsp"
  "shfmt"
  "stylua"
)

tools="$1"
if [[ "$tools" == "" ]]; then
  tools="${TOOLS[@]}"
fi

node_version="node16"
node_arch="x64"
if [[ "$(arch)" == "arm64" ]]; then
  node_arch="arm64"
fi

export NVIM_TOOLS_BIN="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-tools/bin"
export NVIM_TOOLS_NODE_TARGET="${node_version}-macos-${node_arch}"

mkdir -p $NVIM_TOOLS_BIN

DIR=$(cd $(dirname $BASH_SOURCE) && pwd)

for f in $(find $DIR/installer -type f -depth 1); do
  if [[ " ${tools} " == *" $(echo $f | sed 's#\.sh$##' | xargs basename) "* ]]; then
    export NVIM_TOOLS_TMP="$TMPDIR/nvim-tools_$(date +%s)"
    mkdir -p $NVIM_TOOLS_TMP

    $f

    rm -rf $NVIM_TOOLS_TMP
  fi
done


