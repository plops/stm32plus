#!/bin/bash

# Collect all files in this project that can serve as useful input for a large language model.
# This is pre-existing documentation, code and example code.
# In order to keep the context below 2M tokens, we will only include files of a reasonable size (< 300kB)
# Limit implementation that exists for multiple hardware devices to stm32f405

# Recursively find all files in ../ that are not too large and not in the .git directory
# and have file ending *.cpp, *.h or *.md.

find .. -type f \
    -not -path '../.git/*' \
    -not -path '*/f0/*' \
    -not -path '*/f1/*' \
    -not -path '../lib/include/display/*' \
    -not -path '../lib/src/display/*' \
    -not -path '../utils/liblzg/*' \
    -not -path '../lib/fwlib/f4/cmsis/*' \
    -not -path '../lib/include/dma/f4/*' \
    -not -path '../lib/include/stl/*' \
    -size -50k -regex ".*\.\(cpp\|h\|md\)" > 01a_files.txt

# Print all files in 01a_files.txt with their size and sorted by size
ls -l $(cat 01a_files.txt) | awk '{print $5, $9}' | sort -n



# Merge all files into one large file to generate context
# Prefix every file with "// START FILE: <filename>"
# and suffix with "// END FILE: <filename>"

cat 01a_files.txt | while read file; do
    echo "// START FILE: $file"
    cat $file
    echo "// END FILE: $file"
done > 01b_all_files.txt

# This is 1.2M tokens