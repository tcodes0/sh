#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# calls git diff and exists if there are changes

set -euo pipefail
shopt -s globstar nullglob
trap 'err $LINENO' ERR

##############
### script ###
##############

diff=$(git diff .)

if [ "$diff" ]; then
  echo "$diff"
  echo "update files and commit changes"
  exit 1
fi
