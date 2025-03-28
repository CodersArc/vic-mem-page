#!/bin/bash

directory="src/assets"

for file in "$directory"/*.{jpg,jpeg,png}; do
    if [[ -f "$file" ]]; then
        echo "Optimizing $file"
        magick "$file" -strip -interlace Plane -gaussian-blur 0.05 -quality 85% "$file"
    fi
done