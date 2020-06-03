GPU?=1
DEBUG?=0
#for radiation setup
LOGS=1
OMP?=1

ALPHA=1.0
BETA=0.0
SIZE?=2048
ITERATIONS=1
PRECISION=float
CUBLAS=0
TENSOR_CORES=0
DMR=none
BUILDRELATIVEERROR=0
CHECKBLOCK=1

DIR=../data/gemm_tensorcores

OUTPUTPREFIX=$(PRECISION)_$(ALPHA)_$(BETA)_$(SIZE)_cublas_$(CUBLAS)_tensor_$(TENSOR_CORES).matrix

# This is what I use, uncomment if you know your arch and want to specify
ARCH= 	-gencode arch=compute_35,code=[sm_35,compute_35]		# Kepler
#ARCH+= 	-gencode arch=compute_61,code=[sm_61,compute_61]	# Titan X | Titan Xp
#ARCH+= 	-gencode arch=compute_62,code=[sm_62,compute_62]	# Tegra X2
ARCH+= 	-gencode arch=compute_70,code=[sm_70,compute_70]	# Titan V | Tesla V100

VPATH=./src/
TARGET=gemm
OBJDIR=./obj/

CXX=g++-7
CUDAPATH=/usr/local/cuda
NVCC=$(CUDAPATH)/bin/nvcc 
OPTS=-O3
LDFLAGS= -lm -lstdc++ 
COMMON= 
CFLAGS=-Wall -Wfatal-errors  -Wunknown-pragmas -Wunused-function

INCLUDE=-I$(CUDAPATH)/include -I../common

ifeq ($(DEBUG), 1) 
OPTS=-O0 -g -DDEBUG
NVCCFLAGS+= -g -G -DDEBUG
endif

CFLAGS+=$(OPTS) -fPIC
STDVERSION=--std=c++11

COMMON+= $(STDVERSION)

ifeq ($(GPU), 1) 
COMMON+= -DGPU -I$(CUDAPATH)/include/
CFLAGS+= -DGPU
LDFLAGS+= -L$(CUDAPATH)/lib64 -lcudart -lcurand -lcublas
endif

ifeq ($(OMP), 1) 
CFLAGS+= -DOMP -fopenmp
endif


OBJ= main.o setup_gemm.o Parameters.o common.o
#setup_tensor_cores.o

ifeq ($(LOGS), 1)
INCLUDE+=-I../common/include/
NVCCFLAGS+= -DLOGS
CFLAGS+= -DLOGS
LDFLAGS+= -L../common/lib -lLogHelper -DLOGS=1
endif

OBJS = $(addprefix $(OBJDIR), $(OBJ))
DEPS = $(wildcard src/*.h) Makefile

NVCCFLAGS+= -Xptxas -v

all: clean obj $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(COMMON) $(CFLAGS) $^ $(INCLUDE) -o $@  $(LDFLAGS)  

$(OBJDIR)%.o: %.cpp $(DEPS)
	$(CXX) $(COMMON) $(CFLAGS) -c $< -o $@ $(INCLUDE) 

$(OBJDIR)%.o: %.cu $(DEPS)
	$(NVCC) -ccbin $(CXX) $(ARCH) $(COMMON) $(NVCCFLAGS) --compiler-options "$(CFLAGS)" $(INCLUDE) -c $< -o $@ 


obj:
	mkdir -p obj


.PHONY: clean
clean:
	rm -rf $(OBJS) $(TARGET)


# GEMM options
generate:
	./$(TARGET) --size $(SIZE) --generate --verbose \
                        --precision $(PRECISION) --dmr none \
                        --alpha $(ALPHA) --beta $(BETA) \
                        --input_a $(DIR)/a_$(OUTPUTPREFIX) \
                        --input_b $(DIR)/b_$(OUTPUTPREFIX) \
                        --input_c $(DIR)/c_$(OUTPUTPREFIX) \
                        --gold $(DIR)/g_$(OUTPUTPREFIX) $(USECUBLAS) $(USETENSORS)

test:
	./$(TARGET) --size $(SIZE) --verbose \
                        --precision $(PRECISION) --dmr $(DMR) \
                        --iterations $(ITERATIONS)  \
                        --alpha $(ALPHA) --beta $(BETA) \
                        --input_a $(DIR)/a_$(OUTPUTPREFIX) \
                        --input_b $(DIR)/b_$(OUTPUTPREFIX) \
                        --input_c $(DIR)/c_$(OUTPUTPREFIX) \
                        --gold  $(DIR)/g_$(OUTPUTPREFIX)       \
                        --opnum $(CHECKBLOCK) $(USECUBLAS) $(USETENSORS)


golden:
	./$(TARGET) --size $(SIZE) --verbose \
                        --precision $(PRECISION) --dmr $(DMR) \
                        --iterations $(ITERATIONS)  \
                        --alpha $(ALPHA) --beta $(BETA) \
                        --input_a $(DIR)/a_$(OUTPUTPREFIX) \
                        --input_b $(DIR)/b_$(OUTPUTPREFIX) \
                        --input_c $(DIR)/c_$(OUTPUTPREFIX) \
                        --gold  $(DIR)/g_$(OUTPUTPREFIX)       \
                        --opnum $(CHECKBLOCK) $(USECUBLAS) $(USETENSORS) > golden_stdout.txt 2>golden_stderr.txt
						sed -i '/LOGFILENAME/c\' golden_stdout.txt 
						sed -i '/Time/c\' golden_stdout.txt 
						sed -i '/time/c\' golden_stdout.txt 
						sed -i '/^$$/d' golden_stdout.txt

