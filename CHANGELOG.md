# spellcheck and updates: v0.2.6 *(2024-09-08)*
### [Diff with v0.2.5](github.com/tcodes0/sh/compare/v0.2.6..v0.2.5)

### PRs in this release: [#20](github.com/tcodes0/sh/pull/20)
## Features
- **workflows**: spellcheck commit messages ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))

## Bug Fixes
- **workflows**: missing vars ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))
- **workflows**: set write permission on release ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))

## Documentation
- scripts ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))

#### Other
- **workflows**: bump actions ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))
- update workflow docs ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))
- rename cspell.config to .cspell.config ([84549583](github.com/tcodes0/sh/commit/84549583ff01eeae504a30a82c3cd9e4c3576042))

# nullglob: v0.2.5 *(2024-09-06)*
### [Diff with v0.2.4](https://github.com/tcodes0/sh/compare/v0.2.5..v0.2.4)

### PRs in this release: [#18](https://github.com/tcodes0/sh/pull/18)
## Features
- add nullglob opt everywhere ([8fda1a85](https://github.com/tcodes0/sh/commit/8fda1a852d16c39f156a906e119e8d1dd94d85f0))

## Bug Fixes
- **workflows**: pass GITHUB_TOKEN ([b85346c7](https://github.com/tcodes0/sh/commit/b85346c7b6e51c151eada0b2c1da854168d829b7))

# Workflows/unpin changelog version: v0.2.4 *(2024-09-06)*
### [Diff with v0.2.3](https://github.com/tcodes0/sh/compare/v0.2.4..v0.2.3)

### PRs in this release: [#16](https://github.com/tcodes0/sh/pull/16)
#### Other
- **workflows**: unpin changelog version ([6305d2dd](https://github.com/tcodes0/sh/commit/6305d2ddd50955f6c9aa3b6a657a1b98b95b033d))

# Fix tag.sh log parsing: v0.2.3 *(2024-09-05)*
### [Diff with v0.2.2](https://github.com/tcodes0/sh/compare/v0.2.3..v0.2.2)

### PRs in this release: [#14](https://github.com/tcodes0/sh/pull/14)
## Bug Fixes
- **workflows/release**: correct log parse in tag.sh ([93621825](https://github.com/tcodes0/sh/commit/93621825911e407321537729ea2351a3b694b3ff))

# Improve tag.sh: v0.2.2 *(2024-09-05)*
### [Diff with v0.2.1](https://github.com/tcodes0/sh/compare/v0.2.2..v0.2.1)

### PRs in this release: [#12](https://github.com/tcodes0/sh/pull/12)
## Features
- add LIB_LOADED checks and errors ([1e45aba1](https://github.com/tcodes0/sh/commit/1e45aba1808789d3245179a4b846ef2fcd5eb9cf))

## Bug Fixes
- **workflows/release**: add TAGS_FILE env ([3de7e530](https://github.com/tcodes0/sh/commit/3de7e53084665e87e55a4e616e69ca1deba0e554))

## Improvements
- **workflows/release**: update tag.sh to work with TAGS_FILE ([7b4472bf](https://github.com/tcodes0/sh/commit/7b4472bfe3775a54341d36be7aafb53201abfc04))
- remove .env local sourcing to avoid confusion ([9a44f2c9](https://github.com/tcodes0/sh/commit/9a44f2c99f090e392a8fab74317a224d0aece578))

#### Other
- vscode settings, empty .env-default ([67651938](https://github.com/tcodes0/sh/commit/6765193816b83c730f1dfdbf28c5a45b2733cac9))
- use fatal instead of exit 1 ([025f6829](https://github.com/tcodes0/sh/commit/025f682921aa0dda0946cb85741be9d3370d4d29))

# workflow updates: v0.2.1 *(2024-09-05)*
### [Diff with v0.2.0](https://github.com/tcodes0/sh/compare/v0.2.1..v0.2.0)

### PRs in this release: [#9](https://github.com/tcodes0/sh/pull/9)
## Features
- **workflows/release**: add TAGS_FILE global ([17354579](https://github.com/tcodes0/sh/commit/173545795d19b008e92347ff56ea24a68d4540da))

## Bug Fixes
- **workflows/release**: correct changelog flag name ([17354579](https://github.com/tcodes0/sh/commit/173545795d19b008e92347ff56ea24a68d4540da))
- **workflows/release**: correct unset env DRY_RUN ([17354579](https://github.com/tcodes0/sh/commit/173545795d19b008e92347ff56ea24a68d4540da))

#### Other
- add tags.txt ([17354579](https://github.com/tcodes0/sh/commit/173545795d19b008e92347ff56ea24a68d4540da))

# go 1 23: v0.2.0 *(2024-09-04)*

### PRs in this release: [#7](https://github.com/tcodes0/sh/pull/7), [#6](https://github.com/tcodes0/sh/pull/6)
### [Diff with v0.1.0](https://github.com/tcodes0/sh/compare/v0.2.0..v0.1.0)

## Breaking changes
- **go**: update workflows to go 1.23 ([ee261e98](https://github.com/tcodes0/sh/commit/ee261e9832ba397a498ea2e8db40ba7a7f2211e2))

## Bug Fixes
- **workflows**: remove local setup go step ([ee261e98](https://github.com/tcodes0/sh/commit/ee261e9832ba397a498ea2e8db40ba7a7f2211e2))
- **workflows/release**: correct regex, add missing line numbers ([5585e577](https://github.com/tcodes0/sh/commit/5585e57713f895233a40de118c19073446c81cec))
- **workflows/release**: parse * and _ in markdown h1, correct release title ([5585e577](https://github.com/tcodes0/sh/commit/5585e57713f895233a40de118c19073446c81cec))

## Documentation
- document global DRY_RUN var better ([5585e577](https://github.com/tcodes0/sh/commit/5585e57713f895233a40de118c19073446c81cec))

#### Other
- update regex link ([5585e577](https://github.com/tcodes0/sh/commit/5585e57713f895233a40de118c19073446c81cec))

# Initial Release: v0.1.0 _(2024-08-30)_

## Features

- **changelog.sh**: update to new changelog flags, update workflow and ci.sh ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- **ci.sh**: trap SIGINT and print log location ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- **go**: add go dir and add lint-fix script ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- **lib.sh**: lib loaded checks and error messages ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- **scripts**: add scripts to be shared ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- **workflows/release-pr**: tweak script to pass locally ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))

## Bug Fixes

- **commitlint**: extend base config ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- **scripts**: correct lib.sh path ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- rename commitlint script ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))

## Improvements

- **lib.sh**: do not source lib directly with hardcoded path ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- **scripts**: improvements, code-review, refactors to be shareable ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- **tag.sh**: update h1 regex parsing, document regex ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- source lib.sh via BASH_ENV ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- handle missing global vars with better errors ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))

## Documentation

- improve script documentation a lot, refactor lib.sh log functions ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))
- document more scripts ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))

#### Other

- renames to snake case ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- add ci wrapper script ([53f219ad](https://github.com/tcodes0/sh/commit/53f219ad7d0d58274eabb4e0ecc971d81ca0bd3c))
- small fixes ([c5eac59a](https://github.com/tcodes0/sh/commit/c5eac59ad72cb8f9a1292ebe5adf0229170bbb86))