#!/bin/bash

cd ~/OneDrive/vimwiki/
git add .
git commit -m "UPDATE: $(date +%Y-%m-%d)"
git push origin main 

echo "$(date '+%d-%m-%Y %H:%M:%S') zenbook: (m1tus) CMD(vimwiki-to-git.sh)" >> ~/.log/vimwiki-to-git.log
