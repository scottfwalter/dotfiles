#!/bin/bash

# Create the destination directory if it doesn't exist
mkdir -p scott

# Use mdfind to search for files with both tags
# -0 flag handles filenames with spaces
# xargs -0 ensures proper handling of spaces in filenames
mdfind "kMDItemUserTags == 'favorite' && kMDItemUserTags == 'knots'" -0 | \
xargs -0 -I {} cp {} scott/

# Print copy completion message
echo "Files with tags 'favorite' and 'knots' have been copied to scott directory"

# Remove all tags from files in the scott directory
find scott -type f -print0 | while IFS= read -r -d '' file; do
    xattr -w com.apple.metadata:_kMDItemUserTags '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array/></plist>' "$file"
    echo "Removed tags from: $file"
done

# List the processed files
echo -e "\nProcessed files in scott directory:"
ls -la scott/
