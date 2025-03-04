#!/bin/bash

TARGET_DIR="${1:-.}"

# .md 파일들을 재귀적으로 찾고, 각 파일에 대해 sed로 치환
find "$TARGET_DIR" -type f -name "*.md" | while read -r file; do
    echo "Processing $file"
    sed -E -i '' 's/!\[[^]]*\]\(\/assets\/img\/([^)]*)\)/![[content\/assets\/img\/\1]]/g' "$file"
done
