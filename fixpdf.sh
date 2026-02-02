#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: fixpdf <filename.pdf>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.*}_f.pdf"

echo "Fixing PDF: $INPUT_FILE"

gs -o "$OUTPUT_FILE" \
   -sDEVICE=pdfwrite \
   -dEmbedAllFonts=true \
   -dPDFSETTINGS=/prepress \
   -dCompatibilityLevel=1.4 \
   "$INPUT_FILE"

if [ $? -eq 0 ]; then
    echo "[OK] File saved as $OUTPUT_FILE"
else
    echo "[KO]: Something went wrong."
fi
