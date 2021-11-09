#!/bin/bash

[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
[[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1

mkdir -p $NVIM_TOOLS_TMP/{target,root}

cargo install stylua \
  --features lua52 \
  --root $NVIM_TOOLS_TMP/root \
  --bin stylua \
  --target-dir $NVIM_TOOLS_TMP/target \
  --git https://github.com/JohnnyMorganz/StyLua.git \
  --branch master

mv $NVIM_TOOLS_TMP/root/bin/stylua $NVIM_TOOLS_BIN/stylua

