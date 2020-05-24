#Makefile common rules for all benchmarks

#gencode must be set to compute arch and sm
ARCH = -gencode arch=compute_35,code=sm_35 -gencode arch=compute_70,code=sm_70

CXX = g++-7
CC = gcc-7

CUDA_PATH = /usr/local/cuda
NVCC = $(CUDA_PATH)/bin/nvcc

NVCC_INCLUDE = $(CUDA_PATH)/include
NVCC_LIB = $(CUDA_PATH)/lib64
