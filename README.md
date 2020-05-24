# CAROL-FI-CODES 

Benchmark suite used on CAROL-FI for NVIDIA Boards

# Requisites

1 - Tested with CUDA 10.1, but can work with newer versions

2 - Tested with Tesla K40c and Titan V

3 - G++ >=7

# Install

The installation process verifies the input data files and build the log library that will log the SDC/DUE information.

To install the suite execute the install script
```{r, engine='bash', code_block_name} 
$ ./install.sh
```

# Benchmarks info

| Benchmark | Description | Reference |
| ------------- | ------------- | ------------- |
| lava_mp   | N-Body      | http://rodinia.cs.virginia.edu/doku.php |
| bfs       | Graph       |                                         |
| hotspot   | Structured Grid         |                                         | 
| gaussian  |  Dense Linear Algebra   |                                         | 
| lud       |  Dense Linear Algebra   |                                         | 
| nw        |  Dynamic Programming    |                                         |
| gemm_tensorcores | NVIDIA BLAS | NVIDIA Samples |
| mergesort        |  Sorting    | NVIDIA Samples |
| quicksort        |  Sorting    | NVIDIA Samples |
| accl              |             | |
| darknet_v2    | Machine learning | https://github.com/pjreddie/darknet |
| darknet_v3    | Machine learning | https://github.com/pjreddie/darknet |
 
 
   
