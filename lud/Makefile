CXX=g++-7
CXXFLAGS= -std=c++11 -o3  -fPIC -fopenmp 
EXEC=cudaLUD
LOGS=1
ITERATIONS=10
SIZE=8192

VPATH=./src/
CUDAPATH=/usr/local/cuda
NVCC=$(CUDAPATH)/bin/nvcc


NVCCFLAGS= -std=c++11 -O3 -Xptxas -v


ARCH= -gencode arch=compute_35,code=[sm_35,compute_35] #Kepler
ARCH+= -gencode arch=compute_70,code=[sm_70,compute_70] #Titan V

INCLUDE= -I./src -I$(CUDAPATH)/include -I$(CUDAPATH)/samples/common/inc -I$(CUDAPATH)/samples/common/inc -I../common/include

OBJDIR=./obj/
OBJ=  lud_kernel.o  main.o Parameters.o

ifeq ($(DEBUG), 1) 
CXXFLAGS+=-O0 -g
NVCCFLAGS+= -g -G
endif

ifeq ($(LOGS), 1)
CXXFLAGS+= -DLOGS
NVCCFLAGS+= -DLOGS
LDFLAGS+= -L../common/lib  -lLogHelper
endif

LDFLAGS+= -L$(CUDAPATH)/lib64  -lcudart  -lcurand

OBJS = $(addprefix $(OBJDIR), $(OBJ))
DEPS = $(wildcard src/*.h) Makefile


all: mkdir $(EXEC)


$(EXEC): $(OBJS)  
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS) $(INCLUDE)

$(OBJDIR)%.o: %.cpp $(DEPS)
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(INCLUDE)
	
$(OBJDIR)%.o: %.cu $(DEPS)
	$(NVCC) $(ARCH) $(NVCCFLAGS) -c $< -o $@ $(INCLUDE) 

mkdir:
	mkdir -p $(OBJDIR)

clean:
	rm -f $(OBJDIR)* $(EXEC)
	
DATA=../data/lud
generate:
	./cudaLUD --size $(SIZE) --generate --input $(DATA)/input_$(SIZE).data --gold $(DATA)/gold_$(SIZE).data --iterations $(ITERATIONS) --verbose;

test:
	./cudaLUD --size $(SIZE) --input $(DATA)/input_$(SIZE).data --gold $(DATA)/gold_$(SIZE).data --iterations $(ITERATIONS) --verbose;
	
