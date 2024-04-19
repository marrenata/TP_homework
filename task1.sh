#!/bin/bash

usage() {
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
}

if [ $# -ne 2 ]; then
    usage
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist."
    exit 1
fi

mkdir -p "$output_dir"

copy_file() {
    local src_file=$1
    local dest_file=$2

    local counter=1

    while [ -e "$dest_file" ]; do
        local extension="${src_file##*.}"
        local filename="${src_file%.*}"
        dest_file="${output_dir}/$(basename "${filename}")_${counter}.${extension}"
        ((counter++))
    done

    cp "$src_file" "$dest_file"
}

export -f copy_file

export input_dir
export output_dir

find "$input_dir" -type f -exec bash -c 'copy_file "{}" "${output_dir}/$(basename "{}")"' \;