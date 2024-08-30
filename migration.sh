#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.

set -euo pipefail
shopt -s globstar
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
# Args       : $@
# STDERR     : Might print errors
# Example    : validate_input "$@"
validate_input() {
  name=${1-}

  if [ ! "$name" ]; then
    err $LINENO "missing migration name"
    usage
    exit 1
  fi
}

# Description: Create a new timestamped migration file
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

if requested_help "$*"; then
  usage
  exit 1
fi

validate_input "$@"

source .env

create "up" "$1"
create "down" "$1"
