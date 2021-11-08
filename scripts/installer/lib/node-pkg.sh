#!/bin/bash

set -e


usage() {
  echo "Usage: node-pkg.sh <name>"
  echo ""
  echo "Options"
  echo "  -h|--help    Show help"
}

run() {
  # name="$1"
  # path="$2"

  local name="$1"; shift || true
  local pkg="$name"
  local path=""
  local assets="[]"

  while test $# -gt 0; do
    case "$1" in
      -h|--help)
        usage; exit ;;
      --package)
        pkg="$2"; shift; shift ;;
      --path)
        path="$2"; shift; shift ;;
      --assets)
        assets="$2"; shift; shift ;;
      *)
        echo "[error] Unknown option: $1" >&2
        usage; exit 1 ;;
    esac
  done


  if [[ "$name" == "" ]]; then
    echo "[error] Name missing" >&2
    usage; exit 1
  fi

  echo "name: $name | $pkg"


  [[ "$NVIM_TOOLS_BIN" != "" ]] || exit 1
  [[ "$NVIM_TOOLS_TMP" != "" ]] || exit 1

  local BIN_DIR="$NVIM_TOOLS_BIN"
  local TMP_DIR="$NVIM_TOOLS_TMP/$name"

  rm -rf $TMP_DIR

  mkdir -p $TMP_DIR
  mkdir -p $BIN_DIR
  #
  cd $TMP_DIR

  echo '{ "name": "tmp--'$name'" }' > package.json
  # jq . package.json

  npm install pkg $pkg

  if [[ "$path" == "" ]]; then
    # local fpath="$(readlink -f $TMP_DIR/node_modules/.bin/$name)"
    local fpath="$TMP_DIR/node_modules/.bin/$(readlink $TMP_DIR/node_modules/.bin/$name)"
  else
    local fpath="$TMP_DIR/node_modules/$pkg/$path"
  fi

  echo '{ "name": "'$name'", "pkg": { "assets": '$assets' }, "bin" : { "'$name'" : "'$fpath'" } }' > package.json
  jq . package.json

  ./node_modules/.bin/pkg . \
    --targets node14-macos-x64 \
    --output $BIN_DIR/$name

  rm -rf $TMP_DIR
}

run $@
