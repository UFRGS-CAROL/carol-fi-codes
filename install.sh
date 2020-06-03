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
echo "Downloading"

# BFS
cd data/bfs
FILE=graphs_rodinia.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exist"
else 
    wget https://github.com/UFRGS-CAROL/radiation-benchmarks/raw/master/data/bfs/${FILE}
fi
tar xzf $FILE
cd -

# accl
cd data/accl
FILE=7Frames.pgm
if [ -f "$FILE" ]; then
    echo "$FILE exist"
else 
    wget https://github.com/UFRGS-CAROL/radiation-benchmarks/raw/master/data/accl/7Frames.pgm
fi

cd -


# hotspot
cd data/hotspot
FILE=power_and_temp_files.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exist"
else 
    wget https://github.com/UFRGS-CAROL/radiation-benchmarks/raw/master/data/hotspot/power_and_temp_files.tar.gz
fi
tar xzf $FILE

cd -

make -C common/include/
make -C common/include/log_helper_swig_wraper/


