#!/bin/bash
set -e

SOURCE="sections/interface"
DEST="HTML"

mkdir -p "$DEST"

find sections/interface -type f -name "*.tex" -print0 |
while IFS= read -r -d '' item; do
    output="$DEST/${item%.tex}.html"

    mkdir -p "$(dirname "$output")"

    pandoc "$item" -o "$output"

    echo "Converted: $item -> $output"
done