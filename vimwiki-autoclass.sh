#!/bin/bash

cd ~/OneDrive/vimwiki

DIR=~/OneDrive/UPM/

YEAR="$1"
COURSE="$2"
COURSE_TRUE_NAME="$3"
CURRENT_FILE="$4"

#echo -n "What year is this course from: "
#read YEAR

#echo -n "What is the course's name: "
#read COURSE 

case $YEAR in
  1) DIR="$DIR/primero_informatica_upm/" ;;
  2) DIR="$DIR/segundo_informatica_upm/" ;;
  3) DIR="$DIR/tercero_informatica_upm/" ;;
  4) DIR="$DIR/cuarto_informatica/" ;;
  *) echo "Eso no es un numero en el rango 1-4"
esac

DIR="$DIR$COURSE"

mkdir -p "$DIR/notes"
touch "$DIR/notes/index.md"

ln -s "$DIR/notes" "$COURSE"

echo "- ["$COURSE_TRUE_NAME"]($COURSE/index.md)" >> "$CURRENT_FILE"
