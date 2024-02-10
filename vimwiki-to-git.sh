#!/bin/bash

cd ~/OneDrive/vimwiki/
git add .
git commit -m "UPDATE: $(date +%Y-%m-%d)"
git push origin main