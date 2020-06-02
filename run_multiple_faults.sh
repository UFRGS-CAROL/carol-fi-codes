#!/bin/bash

set -e

#uncomment to a more verbose script
#set -x

FAULTS=10


benchmarks=( lava_mp gemm_tensorcores bfs accl mergesort quicksort hotspot gaussian lud nw )
cfc=carol-fi-codes
conffiles=( 
            ${cfc}/lava_mp/float_dmr_none.conf
            ${cfc}/gemm_tensorcores/single_mxm_no_tensor.conf
            ${cfc}/bfs/bfs.conf
            ${cfc}/accl/accl.conf
            ${cfc}/mergesort/mergesort.conf
            
            )
            
cd ../

for((i = 0; i < ${#benchmarks[@]}; i++));
do
    bench=${benchmarks[$i]}
    conf=${conffiles[$i]}
    echo $bench
    #echo $conf
    ls $conf
    #echo "Step 1 - Profiling the application for fault injection"
    #./app_profiler.py -c ${CONFFILE}


    #echo "Step 2 - Running ${FAULTS} on ${CONFFILE}"
    #./fault_injector.py -i ${FAULTS} -c ${CONFFILE}

    #tar czf ${i}_carolfi_2k.tar.gz *.csv /var/radiation-benchmarks/log/
    #rm -rf /var/radiation-benchmarks/log/*.log logs/* *.csv
done

cd -

echo "Fault injection finished"


exit 0
