#!/usr/bin/env bash
set -Eeuo pipefail

FILE_1="$(realpath "$1")"
FILE_2="$(realpath "$2")"
OUTPUT="$3"

TMP_FILE="$(mktemp)"

echo "file '$FILE_1'" > "$TMP_FILE"
echo "file '$FILE_2'" >> "$TMP_FILE"

ffmpeg -f concat -safe 0 -i "$TMP_FILE" -c copy "$OUTPUT"

rm -r "$TMP_DIR"
