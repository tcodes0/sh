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

# Description: Print script usage
# STDOUT     : Help message
# Example    : usage
usage() {
  command cat <<-EOF
Usage:
Runs go linters on the provided path.
Expects linters to be installed.

$0 <path> \t lint fix the go package at <path>\t (required)
EOF
}

# Description: Validates user input
# Args       : $@
# STDERR     : Might print errors
# Example    : validate_input "$@"
validate_input() {
  local path=${1:-}

  if [ ! "$path" ]; then
    usage
    fatal $LINENO "path is required"
  fi
}

# Description: Runs linters on the provided path
# Args       : 1 - directory containing the go package
# STDERR     : Might print errors
# Sideeffects: Might call fatal
# Example    : lint storage
lint() {
  local linters=(
    defers
    fieldalignment
    findcall
    httpmux
    ifaceassert
    lostcancel
    nilness
    shadow
    stringintconv
    unmarshal
    unusedresult
    tagalign
  ) path="$1"

  for linter in "${linters[@]}"; do
    if [ ! -d "$PWD/$path" ]; then
      fatal $LINENO "expected $PWD/$path to be a directory with a go package"
    fi

    if ! $linter -fix "$PWD/$path"; then
      local status=$?

      if [ "$status" -gt 0 ] && [ "$status" != 3 ]; then
        fatal $LINENO "$linter $PWD/$path: exit status $status"
      fi
    fi

    if [ -d "$PWD/$path/${path}_test" ]; then
      $linter -fix "$PWD/$path/${path}_test"
    fi
  done
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

validate_input "$@"
lint "$@"
