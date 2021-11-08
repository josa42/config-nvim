#!/bin/bash

[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
[[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1


BIN_DIR="$NVIM_TOOLS_BIN"
TMP_DIR="$NVIM_TOOLS_TMP/lua-language-server"

rm -rf $TMP_DIR

mkdir -p $TMP_DIR
mkdir -p $BIN_DIR

filePath="lua-language-server-macos.tar.gz"

# Latest release
url="https://github.com/josa42/coc-lua-binaries/releases/latest/download/${filePath}"

cd $TMP_DIR

curl -sSL "$url" > "$filePath"
tar xf "$filePath"

rm -rf $BIN_DIR/lua-language-server
mv lua-language-server $BIN_DIR/

rm -rf $TMP_DIR

