#!/bin/bash

set -x
#set -e

benchmarks=( lava_mp gemm_tensorcores bfs accl mergesort quicksort hotspot gaussian lud nw )

for dir in "${benchmarks[@]}";
do
    rm -rf data/${dir}
    make -C ${dir}/ clean
done

rm -rf data

make -C common/include/ clean
make -C common/include/log_helper_swig_wraper/ clean
