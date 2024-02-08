#!/bin/bash

input_file="$HOME/OneDrive/vimwiki/index.md"
output_file="$HOME/OneDrive/vimwiki/done_tasks.md"

exists_title() {
    grep -n "$1" "$output_file" | cut -d: -f1
}

mv_title() {
    local title_line_number
    if title_line_number=$(exists_title "$1"); then
        sed -i "${title_line_number}a $2" "$output_file"
    else
        echo "$1" >> "$output_file"
        echo "$2" >> "$output_file"
    fi
}

while read -r LINE; do

    if [[ "$LINE" == "#"* ]]; then
        CURR_TITLE="$LINE"
    fi

	if [[ "$LINE" == *"[X]"* ]]; then
        mv_title "$CURR_TITLE" "$LINE"
	fi

done < "$input_file"

sed -i '/[X]/d' $input_file