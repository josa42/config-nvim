#!/bin/bash


[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
[[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1

version="v0.8.0"

curl -sSL "https://github.com/koalaman/shellcheck/releases/download/${version}/shellcheck-${version}.darwin.x86_64.tar.xz" \
   > $NVIM_TOOLS_TMP/shellcheck.tar.xz

cd $NVIM_TOOLS_TMP
tar -xf shellcheck.tar.xz
mv shellcheck-${version}/shellcheck $NVIM_TOOLS_BIN/shellcheck
    
