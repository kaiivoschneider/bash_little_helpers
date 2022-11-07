#!/bin/bash

for path_file in $HELPERS_DIRECTORY/.paths/.*; do
    while read scripts_path; do
        export PATH="$PATH:$scripts_path"
    done <$path_file
done
