#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

$DIR/lib/node-pkg.sh tsserver --package typescript --assets '["node_modules/typescript/lib/typingsInstaller.js"]'
$DIR/lib/node-pkg.sh typescript-language-server

