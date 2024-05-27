#!/bin/bash
# To be executed in at the root of the directories to assess

set -eu

exclude_dirs=( example_dir_to_exclude )
datasets=( $(ls -d *) )
# Creating dir under home to be sure to have write access, the dataset dir might be readonly.
checksums_dir=$HOME/checksums
mkdir $checksums_dir

for d in ${datasets[@]}; do
    if [[ ${exclude_dirs[@]} =~ (^|[[:space:]])$d($|[[:space:]]) ]]; then
        echo "[info] directory $d skipped."
        continue;
    fi
    dest_file=$checksums_dir/checksum_$d.md5
    if [[ -f $dest_file ]]; then
        mv $dest_file $dest_file.bkp
    fi
    echo "[info] Creating md5 file for directory $d under $dest_file."
    pushd $d > /dev/null
    file_list=( $(find . -type f) )
    for f in ${file_list[@]}; do
        md5sum $f >> $dest_file
    done
    popd > /dev/null
done
