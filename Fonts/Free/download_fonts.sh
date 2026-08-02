#!/usr/bin/env bash
set -euo pipefail

# Downloads all .ttf and .otf files from AungMyoKyaw/Myanmar-Unicode-Fonts
# and stores them in Fonts/Free using only the filename (no directories).
# Usage: ./Fonts/Free/download_fonts.sh [--overwrite]

REPO_OWNER="AungMyoKyaw"
REPO_NAME="Myanmar-Unicode-Fonts"
BRANCH="master"
DEST_DIR="Fonts/Free"
OVERWRITE=0

if [[ "${1-}" == "--overwrite" ]]; then
  OVERWRITE=1
fi

mkdir -p "$DEST_DIR"

echo "Fetching file list from $REPO_OWNER/$REPO_NAME (branch $BRANCH) ..."
TREE_JSON=$(curl -sSf "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/trees/$BRANCH?recursive=1")

if ! command -v jq >/dev/null 2>&1; then
  echo "This script requires jq. Please install jq and re-run."
  exit 2
fi

FILES=$(echo "$TREE_JSON" | jq -r '.tree[] | select(.path | test("\\.(ttf|otf)$"; "i")) | .path')

if [[ -z "$FILES" ]]; then
  echo "No .ttf or .otf files found in the repository tree."
  exit 0
fi

for path in $FILES; do
  filename=$(basename "$path")
  dest="$DEST_DIR/$filename"
  if [[ -f "$dest" && $OVERWRITE -eq 0 ]]; then
    echo "Skipping existing file: $filename (use --overwrite to replace)"
    continue
  fi
  raw_url="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$path"
  echo "Downloading $filename from $raw_url"
  curl -sSfL "$raw_url" -o "$dest"
  echo "Saved: $dest"
done

echo "All done. Downloaded $(ls -1 "$DEST_DIR" | wc -l) files to $DEST_DIR"
