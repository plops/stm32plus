#!/bin/bash

# Convert all *.puml files in this folder into svg files

find . -type f -name "*.puml" | while read file; do
    echo "Converting $file to ${file%.puml}.svg"
    plantuml -tsvg $file
done