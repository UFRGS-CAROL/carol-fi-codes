#!/bin/bash

set -x
set -e

mkdir -p data

for dir in lava;
do
    mkdir -p data/${dir}
done

# Download the input data
echo "Download"


make -C common/include/
make -C common/include/log_helper_swig_wraper/


