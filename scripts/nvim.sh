#!/bin/bash

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." &> /dev/null && pwd)"
TMP="$DIR/.tmp"

rm -rf $TMP/config
mkdir -p $TMP/{share,state,cache,config}

ln -s $DIR $TMP/config/nvim
ln -s $HOME/.config/json-schema $TMP/config/json-schema 

export XDG_CONFIG_HOME=$TMP/config
export XDG_CACHE_HOME=$TMP/cache
# export XDG_DATA_HOME=$TMP/share
export XDG_STATE_HOME=$TMP/state
export NVIM_TOOLS_BIN="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-tools/bin"

nvim "$@"
