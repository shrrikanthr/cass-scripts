#!/bin/bash

SRC_DIR="$1"
ARCHIVE_DIR="$2"

mkdir -p "$ARCHIVE_DIR"

# Copy all non-zero sized files from source directory to archive directory
find "$SRC_DIR" -type f -size +0c -exec cp {} "$ARCHIVE_DIR" \;

echo "Archived non-zero commitlog files from $SRC_DIR to $ARCHIVE_DIR"

