#!/bin/bash

input_file="$HOME/OneDrive/vimwiki/index.md"
output_file="$HOME/OneDrive/vimwiki/done_tasks.md"

# Create the 'done_tasks.md' file if it doesn't exist
touch "$output_file"

# Read tasks from the input file
while IFS= read -r line || [[ -n "$line" ]]; do
    # Check if the line contains a completed task (assumes tasks are marked with [x])
    if [[ "$line" == *"[X]"* ]]; then
        # Move the completed task to the 'done_tasks.md' file
        echo "$line" >> "$output_file"
        echo "Moved: $line"
    else
        # Keep non-completed tasks in the original file
        echo "$line" >> "$input_file.tmp"
    fi
done < "$input_file"

# Replace the original file with the temp file
mv "$input_file.tmp" "$input_file"
echo "done"

