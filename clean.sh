#!/bin/bash

set -x
set -e

for dir in lava_mp;
do
    rm -rf data/${dir}
    make -C ${dir}/ clean
done

rm -rf data

make -C common/include/ clean
make -C common/include/log_helper_swig_wraper/ clean
