#!/bin/bash

set -x
set -e

mkdir -p data

benchmarks=( lava_mp gemm_tensorcores bfs accl mergesort quicksort hotspot gaussian lud nw )

for dir in "${benchmarks[@]}";
do
    mkdir -p data/${dir}
done

# Download the input data
echo "Download"


make -C common/include/
make -C common/include/log_helper_swig_wraper/


