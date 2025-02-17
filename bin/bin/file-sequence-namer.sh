#!/bin/bash

# Default ignore patterns
DEFAULT_IGNORE_PATTERNS=(
    ".DS_Store"
    ".metadata.stash"
    #"*.iml"
)

# Print usage information
usage() {
    echo "Usage: $0 [-d] [-r] [-i pattern] [directory]"
    echo "  -d  Dry run (preview changes without renaming)"
    echo "  -r  Recursive (process subdirectories)"
    echo "  -i  Additional ignore pattern (can be used multiple times)"
    echo "  directory  Starting directory (default: current directory)"
    echo
    echo "Default ignore patterns:"
    for pattern in "${DEFAULT_IGNORE_PATTERNS[@]}"; do
        echo "  - $pattern"
    done
    exit 1
}

# Function to check if a filename matches the pattern "## - filename"
is_properly_named() {
    [[ $1 =~ ^[0-9]{2}[[:space:]]-[[:space:]].*$ ]]
}

# Function to check if a file should be ignored
should_ignore() {
    local filename="$1"

    # Check default ignore patterns
    for pattern in "${DEFAULT_IGNORE_PATTERNS[@]}"; do
        if [[ "$filename" == $pattern ]]; then
            return 0
        fi
    done

    # Check custom ignore patterns
    for pattern in "${CUSTOM_IGNORE_PATTERNS[@]}"; do
        if [[ "$filename" == $pattern ]]; then
            return 0
        fi
    done

    return 1
}

# Find the next available number in sequence for a given directory
find_next_number() {
    local dir="$1"
    local max=0

    # Loop through all files in the directory
    while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        # Skip if file should be ignored
        if should_ignore "$filename"; then
            continue
        fi
        # Skip if file already matches our pattern
        if is_properly_named "$filename"; then
            # Extract the number from the filename
            num=$(echo "$filename" | cut -d' ' -f1)
            # Remove leading zeros and compare
            num=$((10#$num))
            if (( num > max )); then
                max=$num
            fi
        fi
    done < <(find "$dir" -maxdepth 1 -type f -print0)

    # Return next number in sequence
    echo $((max + 1))
}

# Process files in a directory
process_directory() {
    local current_dir="$1"
    local is_dry_run="$2"
    local next_num=$(find_next_number "$current_dir")

    # Process each file in the current directory
    while IFS= read -r -d '' file; do
        # Get just the filename without the path
        filename=$(basename "$file")

        # Skip if file should be ignored
        if should_ignore "$filename"; then
            echo "Ignoring: $file (matches ignore pattern)"
            continue
        fi

        # Skip if file already matches our pattern
        if ! is_properly_named "$filename"; then
            # Format the new number with leading zero if needed
            formatted_num=$(printf "%02d" $next_num)

            # Create new filename
            new_name="${current_dir}/${formatted_num} - ${filename}"

            if [ "$is_dry_run" = true ]; then
                echo "Would rename: $file -> $new_name"
            else
                mv "$file" "$new_name"
                echo "Renamed: $file -> $new_name"
            fi

            # Increment counter
            next_num=$((next_num + 1))
        fi
    done < <(find "$current_dir" -maxdepth 1 -type f -print0)
}

# Initialize array for custom ignore patterns
declare -a CUSTOM_IGNORE_PATTERNS=()

# Parse command line options
dry_run=false
recursive=false
start_dir="."

while getopts "dri:h" opt; do
    case $opt in
        d) dry_run=true ;;
        r) recursive=true ;;
        i) CUSTOM_IGNORE_PATTERNS+=("$OPTARG") ;;
        h) usage ;;
        \?) usage ;;
    esac
done

shift $((OPTIND-1))
if [ "$1" ]; then
    start_dir="$1"
fi

# Ensure start directory exists
if [ ! -d "$start_dir" ]; then
    echo "Error: Directory '$start_dir' does not exist"
    exit 1
fi

# Show current ignore patterns
echo "Active ignore patterns:"
for pattern in "${DEFAULT_IGNORE_PATTERNS[@]}"; do
    echo "  - $pattern (default)"
done
for pattern in "${CUSTOM_IGNORE_PATTERNS[@]}"; do
    echo "  - $pattern (custom)"
done
echo

# Process files
if [ "$recursive" = true ]; then
    # Process each directory recursively
    while IFS= read -r -d '' dir; do
        echo "Processing directory: $dir"
        process_directory "$dir" "$dry_run"
    done < <(find "$start_dir" -type d -print0)
else
    # Process only the start directory
    process_directory "$start_dir" "$dry_run"
fi
