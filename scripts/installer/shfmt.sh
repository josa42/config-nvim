#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

$DIR/lib/go-install.sh mvdan.cc/sh/v3/cmd/shfmt@latest
