#!/bin/bash

input_file="$HOME/OneDrive/vimwiki/index.md"
output_file="$HOME/.log/done_tasks.log"

exists_title() {
    grep -n "$1" "$output_file" | cut -d: -f1
}

while read -r LINE; do

	if [[ "$LINE" == *"[X]"* ]]; then
		echo "$LINE" >> "$output_file"
	fi

done < "$input_file"

sed -i '/[X]/d' $input_file
