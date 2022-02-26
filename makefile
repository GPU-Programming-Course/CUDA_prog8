
NVCC = /usr/bin/nvcc
CC = g++

#No optmization flags
#--compiler-options sends option to host compiler; -Wall is all warnings
#NVCCFLAGS = -c --compiler-options -Wall

#Optimization flags: -O2 gets sent to host compiler; -Xptxas -O2 is for
#optimizing PTX
NVCCFLAGS = -c -O2 -Xptxas -O2 --compiler-options -Wall

#Flags for debugging
#NVCCFLAGS = -c -G --compiler-options -Wall --compiler-options -g

OBJS = blur.o wrappers.o h_blur.o d_blur.o
.SUFFIXES: .cu .o .h 
.cu.o:
	$(NVCC) $(CC_FLAGS) $(NVCCFLAGS) $(GENCODE_FLAGS) $< -o $@

all: blur generate

blur: $(OBJS)
	$(CC) $(OBJS) -L/usr/local/cuda/lib64 -lcuda -lcudart -ljpeg -o blur

blur.o: blur.cu wrappers.h h_blur.h d_blur.h

h_blur.o: h_blur.cu h_blur.h CHECK.h

d_blur.o: d_blur.cu d_blur.h CHECK.h

wrappers.o: wrappers.cu wrappers.h

generate: generate.c
	gcc -O2 generate.c -ljpeg -o generate

clean:
	rm generate blur *.o h_blur*.jpg d_blur*.jpg
