#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.

set -euo pipefail
shopt -s globstar
# shellcheck source=lib.sh
source "$PWD/sh/lib.sh"

linters=(
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
)

if requestedHelp "$*"; then
  msgln "fixes for a few standalone linters"
  msgln "Inputs:"
  msgln "<module>\t lint fix the module\t (required)"
  exit 1
fi

for linter in "${linters[@]}"; do
  $linter -fix "$PWD/$1"

  if [ -d "$PWD/$1/${1}_test" ]; then
    $linter -fix "$PWD/$1/${1}_test"
  fi
done
