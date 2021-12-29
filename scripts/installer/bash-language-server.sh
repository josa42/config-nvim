#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

$DIR/lib/node-pkg.sh bash-language-server --assets '"node_modules/web-tree-sitter/tree-sitter.wasm"'
