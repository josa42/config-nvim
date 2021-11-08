#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

$DIR/lib/node-pkg.sh vscode-html-language-server --package vscode-langservers-extracted --path dist/html-language-server/node/htmlServerMain.js
$DIR/lib/node-pkg.sh vscode-css-language-server --package vscode-langservers-extracted --path dist/css-language-server/node/cssServerMain.js
$DIR/lib/node-pkg.sh vscode-json-language-server --package vscode-langservers-extracted --path dist/json-language-server/node/jsonServerMain.js
$DIR/lib/node-pkg.sh vscode-eslint-language-server --package vscode-langservers-extracted --path dist/eslint-language-server/eslintServer.js

