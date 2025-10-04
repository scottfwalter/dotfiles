#! /bin/bash

# Create the destination directory if it doesn't exist
DEST_DIR="$HOME/myfavs"
mkdir -p "$DEST_DIR"

# Find all files with "favorite" tag, excluding those already in ~/myfavs
mdfind "tag:scott123" | while IFS= read -r file; do
    # Check if the file is NOT already in the destination directory
    if [[ "$file" != "$DEST_DIR"* ]]; then
        # Get just the filename
        filename=$(basename "$file")

        # Copy the file to the destination (will overwrite if exists)
        cp "$file" "$DEST_DIR/"

        if [ $? -eq 0 ]; then
            echo "Copied: $filename"
        fi
    fi
done

echo "Done! Files copied to $DEST_DIR"
