#!/bin/bash

ARCHIVE_DIR="$1"
COMMITLOG_DIR="$2"

mkdir -p "$COMMITLOG_DIR"

# Copy all non-zero sized files from archive directory back to commitlog directory
find "$ARCHIVE_DIR" -type f -size +0c -exec cp {} "$COMMITLOG_DIR" \;

echo "Restored non-zero commitlog files from $ARCHIVE_DIR to $COMMITLOG_DIR"


