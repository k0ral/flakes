#!/usr/bin/env bash
set -Eeuo pipefail

FROM="$1"
TO="$2"
FILE_PATH="$3"

TMP_DIR="$(mktemp -d)"
TMP_FILE="$TMP_DIR/$(basename "$FILE_PATH")"

ffmpeg \
  -ss "$FROM" \
  -to "$TO" \
  -i "$FILE_PATH" \
  -acodec copy \
  -vcodec copy \
  -avoid_negative_ts make_zero \
  "$TMP_FILE"

mv -i "$TMP_FILE" "$FILE_PATH"
rm -r "$TMP_DIR"

