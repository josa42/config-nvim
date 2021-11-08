#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

$DIR/lib/node-pkg.sh docker-langserver --package dockerfile-language-server-nodejs
