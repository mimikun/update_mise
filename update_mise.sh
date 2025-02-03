#!/bin/bash

#=======================
# 変数定義
#=======================

readonly PRODUCT_VERSION="0.7.0"
PRODUCT_NAME="$(basename "${0}")"

#=======================
# 関数定義
#=======================

# 使い方、ヘルプメッセージ
usage() {
  cat <<EOF
$PRODUCT_NAME(bash)
Update mise-tools

Usage:
    $PRODUCT_NAME <COMMAND> <SUBCOMMANDS>

Commands:
    neovim-master                  Run update mise neovim master
    neovim-latest                  Run update mise neovim latest
    neovim-stable                  Run update mise neovim stable
    neovim-nightly                 Run update mise neovim nightly
    paleovim-master                Run update mise paleovim master
    paleovim-latest                Run update mise paleovim latest
    zig-master                     Run update mise zig master
    zig-latest                     Run update mise zig latest

Command options:
    --use-pueue                    Run command with pueue

Options:
    --version, -v, version         print $PRODUCT_NAME version
    --help, -h, help               print this help
EOF
}

# バージョン情報出力
version() {
  echo "$PRODUCT_NAME(bash) v$PRODUCT_VERSION"
}

#=======================
# メイン処理
#=======================
while (("$#")); do
  case "$1" in
  -h | --help | help)
    usage
    exit 1
    ;;
  -v | --version | version)
    version
    exit 1
    ;;
  neovim-master | neovim-latest | neovim-stable | neovim-nightly | paleovim-master | paleovim-latest | zig-master | zig-latest)
    cmd=$1
    opt=$2
    shift
    ;;
  *)
    break
    ;;
  esac
done

case $cmd in
neovim-master)
  echo "WIP"
  ;;
neovim-latest)
  echo "WIP"
  ;;
neovim-stable)
  echo "WIP"
  ;;
neovim-nightly)
  echo "WIP"
  ;;
paleovim-master)
  update_mise_paleovim_master "$opt"
  ;;
paleovim-latest)
  update_mise_paleovim_latest "$opt"
  ;;
zig-master)
  update_mise_zig_master "$opt"
  ;;
zig-latest)
  update_mise_zig_latest "$opt"
  ;;
*)
  usage
  exit 1
  ;;
esac
