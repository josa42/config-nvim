#!/bin/bash

run() {
  [[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
  [[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1

  local BIN_DIR="$NVIM_TOOLS_BIN"
  local TMP_DIR="$NVIM_TOOLS_TMP/vscode-eslint"


  rm -rf $TMP_DIR
  git clone https://github.com/microsoft/vscode-eslint.git $TMP_DIR
  cd $TMP_DIR

  npm install
  npm install pkg
  npm run compile:server

  ./node_modules/.bin/pkg server/out/eslintServer.js \
    --targets node14-macos-x64 \
    --output $BIN_DIR/eslint-ls

}

run
