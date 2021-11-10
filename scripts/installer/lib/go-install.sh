#!/bin/bash

[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1

GOBIN="$NVIM_TOOLS_BIN" go install $1
