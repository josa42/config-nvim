#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
TMP_DIR=$(mktemp -d -t "typescript")

[[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
[[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1


$DIR/lib/node-pkg.sh tsserver --package typescript --assets '["node_modules/typescript/lib/typingsInstaller.js"]'

pushd $NVIM_TOOLS_TMP
npm init --yes
npm install typescript
mv ./node_modules/typescript $NVIM_TOOLS_BIN
popd
