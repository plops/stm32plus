#!/bin/bash

# Collect all files in this project that can serve as useful input for a large language model.
# This is pre-existing documentation, code and example code.
# In order to keep the context below 2M tokens, we will only include files of a reasonable size (< 300kB)
# Limit implementation that exists for multiple hardware devices to stm32f405

# Recursively find all files in ../ that are not too large and not in the .git directory
# and have file ending *.cpp, *.h or *.md. Store in a variable and print

files = $(find .. -type f -not -path '../.git/*' -not -path '../doc/*' -not -path '../data/*' -not -path '../models/*' -not -path '../.vscode/*' -not -path '../.github/*' -not -path '../.gitignore' -not -path '../README.md' -not -path '../LICENSE' -not -path '../.gitmodules' -not -path '../.gitattributes

