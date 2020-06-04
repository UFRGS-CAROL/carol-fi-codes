#!/bin/bash

set -e

#uncomment to a more verbose script
#set -x

declare -A BENCHMARKS=( 
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


install(){
    mkdir -p data

    for bench in "${!BENCHMARKS[@]}";
    do
        mkdir -p data/${bench}
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
    
    if ldconfig -p | grep -q liblua;
    then
        make -C common/include/log_helper_swig_wraper/
    fi

    for bench in "${!BENCHMARKS[@]}";
    do
        cd ${bench}
        make clean
        make -j4
        make generate
        cd -
    done
}

clean(){
        
    for bench in "${!BENCHMARKS[@]}";
    do
        rm -rf data/${bench}
        make -C ${bench}/ clean
    done

    rm -rf data

    make -C common/include/ clean
    make -C common/include/log_helper_swig_wraper/ clean
}

inject_faults() {
    
    FAULTS=10
    cfc=carol-fi-codes
            
    cd ../

    for bench in "${!BENCHMARKS[@]}";
    do
        #bench=${benchmarks[$i]}
        conf="${BENCHMARKS[$bench]}"

        echo "Step 1 - Profiling $bench for fault injection"
        ./app_profiler.py -c ${conf}


        echo "Step 2 - Running ${FAULTS} on ${conf}"
        #./fault_injector.py -i ${FAULTS} -c ${conf}

        #tar czf ${bench}_carolfi_2k.tar.gz *.csv /var/radiation-benchmarks/log/
        #rm -rf /var/radiation-benchmarks/log/*.log logs/* *.csv
    done

    cd -

    echo "Fault injection finished"
}


case $1 in
    "clean") 
        clean
        ;;
    "install")
        install
        ;;
    "") 
        inject_faults
        ;;
    *) 
        echo "Invalid option" 
        ;;

esac

exit 0
