CXX=g++-7
CXXFLAGS= -std=c++11 -o3  -fPIC -fopenmp 
EXEC=cudaACCL
LOGS=1
ITERATIONS=10
SIZE=7
FRAMES=7
GOLD=../data/accl/gold_$(SIZE)_$(FRAMES).data
INPUT=../data/accl/7Frames.pgm

VPATH=./src/
CUDAPATH=/usr/local/cuda
NVCC=$(CUDAPATH)/bin/nvcc


NVCCFLAGS= -std=c++11 -O3 -Xptxas -v -dc  -Wno-deprecated-gpu-targets


ARCH= -gencode arch=compute_35,code=[sm_35,compute_35] #Kepler
ARCH+= -gencode arch=compute_70,code=[sm_70,compute_70] #Titan V

INCLUDE= -I./src -I$(CUDAPATH)/include -I$(CUDAPATH)/samples/common/inc -I../common/include

OBJDIR=./obj/
GPUOBJ= accl.o_dlink.o
OBJ= accl.o main.o Parameters.o


ifeq ($(DEBUG), 1) 
CXXFLAGS+=-O0 -g
NVCCFLAGS+= -g -G
endif

ifeq ($(LOGS), 1)
CXXFLAGS+= -DLOGS
NVCCFLAGS+= -DLOGS
LDFLAGS+= -L../common/include  -lLogHelper
endif

LDFLAGS+= -L$(CUDAPATH)/lib64  -lcudart  -lcurand -lcudadevrt  -Wno-deprecated-gpu-targets

OBJS = $(addprefix $(OBJDIR), $(OBJ))
GPUOBJS = $(addprefix $(OBJDIR), $(GPUOBJ))
DEPS = $(wildcard src/*.h) Makefile


all: mkdir $(EXEC)


$(EXEC): $(OBJS)  
	$(CXX) $(CXXFLAGS) $(GPUOBJS) $^ -o $@ $(LDFLAGS) $(INCLUDE)

$(OBJDIR)%.o: %.cpp $(DEPS)
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(INCLUDE)
	
$(OBJDIR)%.o: %.cu $(DEPS)
	$(NVCC) $(ARCH) $(NVCCFLAGS) -c $< -o $@ $(INCLUDE) 
	$(NVCC) $(ARCH)  -dlink $@ -o $@_dlink.o -lcudadevrt

mkdir:
	mkdir -p $(OBJDIR)

clean:
	rm -f $(OBJDIR)* $(EXEC)
	

generate:
	./$(EXEC) --size $(SIZE) --frames $(FRAMES) --input $(INPUT) --gold $(GOLD) --iterations $(ITERATIONS) --verbose --generate ;

test:
	./$(EXEC) --size $(SIZE) --frames $(FRAMES) --input $(INPUT) --gold $(GOLD) --iterations $(ITERATIONS) --verbose;
	
