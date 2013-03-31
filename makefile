ROOT ?= $(HOME)/sandbox/bin/
BLOCK_SIZE ?= 512
NVCC = nvcc -L/usr/lib/nvidia-current -lcuda #-arch=sm_20
NVOPENCC = nvopencc #-m64 -TARG:compute_20
#DRAGONEGG = $(ROOT)dragonegg
DRAGONEGG = /home/oslab/sandbox/bin/gcc -fplugin=/home/oslab/sandbox/lib/dragonegg.so -fplugin-arg-dragonegg-emit-ir -fplugin-arg-dragonegg-llvm-ir-optimize=0 -S 
OPT = $(ROOT)opt
LLC = $(ROOT)llc -march=nvptx64 #-cpu=sm_20

all: loader addition_kernel.nvcc.o addition_kernel.ada.ptx

addition_kernel.nvcc.o: addition_kernel.cu
	$(NVCC) -c $< -o $@

#no use
addition_kernel.nvopencc.ptx: addition_kernel.c
	$(NVOPENCC) $< -o $@

addition_kernel.ada.ptx: addition_kernel.ada.ll.opt
	$(LLC) $< -o $@

addition_kernel.ada.ll.opt: addition_kernel.ada.ll 
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. $(OPT) -load ./libcudada.so -O3 -cudada -print-module $< -o $@

addition_kernel.ada.ll: addition_kernel.adb
	$(DRAGONEGG) $< -o $@

loader: addition_kernel_loader.cu
	$(NVCC) -g -DBLOCK_SIZE=$(BLOCK_SIZE) $< -o $@

#libcudada.so: cudada.cpp
#	~/sandbox/clang-bin/bin/clang++ -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -I$(ROOT)../include -fPIC -shared $< -o $@ -L$(ROOT)../lib/ -lLLVM-3.2svn

clean:
	rm -rf *.o *.ll *.ll.opt *.ali *.ptx loader

test_nvcc:
	./loader 512 addition_kernel.sm_10.cubin

test_nvopencc:
	./loader 512 addition_kernel.nvopencc.ptx

test_ada:
	./loader 512 addition_kernel.ada.ptx
