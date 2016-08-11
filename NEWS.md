# githubinstall 0.1.0

## New features

- `gh_install_package()` gains `ref` argument to specify Git references (#6).
- `gh_suggest_username()` returns `"yutannihilation"` by passing `"yutani"` etc (#3, @teramonagi).

## Improvements

- `gh_install_package()` changes from asking number (1: Yes, 2: No) to asking [Y/n]. (#5)

## Bug fixes

- `gh_install_package()` records GitHub to the package description (#4).
- `gh_install_package()` overwite packages if it already installed (#6).
