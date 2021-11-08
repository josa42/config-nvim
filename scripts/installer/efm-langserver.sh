#!/bin/bash

[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1

GOBIN="$NVIM_TOOLS_BIN" GO111MODULE=on go get github.com/mattn/efm-langserver

