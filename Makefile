C = nvcc
NVCCFLAGS = -arch=sm_60 
CFLAGS = -std=c++11

all: Brown

Brown: BMpar.cu  
	$(C) $(NVCCFLAGS) $(CFLAGS) -o paru.exe BMpar.cu 
clean:
	rm -f paru.exe *.dat *.o
