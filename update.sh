#!/bin/bash

MAJOR="${1:-3}"
MINOR="${2:-27}"
PATCH="${3:-2}"

VER_INT="$(printf "%d%02d%02d00" "$MAJOR" "$MINOR" "$PATCH")"

# TODO check sha256sum

ZIP="sqlite-amalgamation-$VER_INT.zip"
[ -f "$ZIP" ] || wget https://www.sqlite.org/2019/$ZIP

unzip -jo $ZIP "sqlite-amalgamation-$VER_INT/sqlite3.c" "sqlite-amalgamation-$VER_INT/sqlite3.h"

# TODO Lock down version
nimble install -y nimterop@0.4.4

nim c --verbosity:0 --hints:off wrap.nim > sqlite3_gen.nim
./wrap

# TODO upstream is working on removing these

sed -i \
  -e 's|^import nimterop/types||' \
  -e "s|$PWD/||" \
  sqlite3_gen.nim
