#!/bin/bash

TARGET_DIR="${1:-.}"
find "$TARGET_DIR" -type f -name "*.md" | while read -r file; do
    echo "Processing $file"
    sed -E -i '' 's/!\[\[content\/(assets\/images\/[^]]+)\]\]/!\[\[\1\]\]/g' "$file"
done
