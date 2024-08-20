#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.

set -euo pipefail
shopt -s globstar
# shellcheck source=lib.sh
source "$PWD/sh/lib.sh"
trap 'err $LINENO' ERR

### vars and functions ###

usage() {
  if requestedHelp "$*"; then
    msgln "usage: $0 [migration name]"
    exit 1
  fi
}

validateInput() {
  name=${1-}

  if [ ! "$name" ]; then
    err $LINENO "missing migration name"
    usage -h
  fi
}

create() {
  # shellcheck disable=2155
  local epoch=$(date +"%s") ymd=$(date +"%Y_%m_%d") prefix="$1" raw_name="$2" name filename

  name=${raw_name/ /_}
  name=${name/-/_}
  name=$(printf %s "$name" | tr '[:upper:]' '[:lower:]')

  filename="${epoch}_${ymd}_${name}.${prefix}.sql"
  touch "$PWD/$MIGRATIONS_DIR/$filename"
  msgln "$PWD/$MIGRATIONS_DIR/$filename"
}

### script ###

validateInput "$@"

source .env

create "up" "$1"
create "down" "$1"
