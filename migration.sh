#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.

set -euo pipefail
shopt -s globstar nullglob
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

usage() {
  command cat <<-EOF
Usage:
Create a new sql migration with a structured name

$0 [migration name]
EOF
}

# Description: Validates user input
# Globals    : MIGRATIONS_DIR (github workflow or .env)
# Args       : $@
# STDERR     : Might print errors
# Returns    : 1 if fail
# Example    : validate "$@"
validate() {
  local name=${1-}

  if [ ! "${MIGRATIONS_DIR:-}" ]; then
    fatal $LINENO "missing MIGRATIONS_DIR env variable"
  fi

  if [ ! "$name" ]; then
    usage
    fatal $LINENO "missing migration name"
  fi
}

# Description: Create a new timestamped migration file
# Globals    : MIGRATIONS_DIR (github workflow or .env)
# Args       : 1=(up | down) 2=name
# STDOUT     : Path to the new file
# Sideeffects: Creates a new file
# Example    : create "up" "create_table"
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

##############
### script ###
##############

if [ ! "${LIB_LOADED:-}" ]; then
  echo -e "INFO  ($0:$LINENO) BASH_ENV=${BASH_ENV:-}" >&2
  echo -e "FATAL ($0:$LINENO) lib.sh not found. use 'export BASH_ENV=<lib.sh location>' or 'BASH_ENV=<lib.sh location> $0'" >&2
  exit 1
fi

if requested_help "$*"; then
  usage
  exit 1
fi

validate "$@"

create "up" "$1"
create "down" "$1"
