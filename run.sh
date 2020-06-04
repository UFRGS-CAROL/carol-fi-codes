#!/bin/bash

set -e

#uncomment to a more verbose script
#set -x

FAULTS=10
cfc=carol-fi-codes

declare -A benchmarks=( 
        ["lava_mp"]="${cfc}/lava_mp/float_dmr_none.conf"
        ["gemm_tensorcores"]="${cfc}/gemm_tensorcores/single_mxm_no_tensor.conf"
        ["bfs"]="${cfc}/bfs/bfs.conf"
        ["accl"]="${cfc}/accl/accl.conf"
        ["mergesort"]="${cfc}/mergesort/mergesort.conf"
        ["quicksort"]="${cfc}/quicksort/quicksort.conf"
        ["hotspot"]="${cfc}/hotspot/single_hotspot.conf"
        ["gaussian"]="${cfc}/gaussian/gaussian.conf"
        ["lud"]="${cfc}/lud/lud.conf"
        ["nw"]="${cfc}/nw/nw.conf"
        )
          
cd ../

for bench in "${!benchmarks[@]}";
do
    #bench=${benchmarks[$i]}
    conf="${benchmarks[$bench]}"

    echo "Step 1 - Profiling $bench for fault injection"
    ./app_profiler.py -c ${conf}


    echo "Step 2 - Running ${FAULTS} on ${conf}"
    #./fault_injector.py -i ${FAULTS} -c ${conf}

    #tar czf ${bench}_carolfi_2k.tar.gz *.csv /var/radiation-benchmarks/log/
    #rm -rf /var/radiation-benchmarks/log/*.log logs/* *.csv
done

cd -

echo "Fault injection finished"


exit 0
