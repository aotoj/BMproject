#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <ctime>
#include <ctime>
#include <cstring>
#include <stdlib.h>
#include <stdio.h>
#include <random>
#include <chrono>

#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

using namespace std;

#define N 256

__global__ void BMwp(float f_new[], float dw[], const float dt, curandState *state)
{
  int tid = threadIdx.x + blockIdx.x * blockDim.x;

  dw[tid] = dt*getrand(&state[tid]);
  f_new[tid+1] = f_new[tid] + dw[tid];
}

__global__ void initialize(float f[], float x[])
{
    int tid = threadIdx.x + blockIdx.x*blockDim.x;

	  x[tid] = 0.0f;
	  f[tid] = 0.0f;
}

__global__ void init_r(curandState *state, unsigned long seed)
{
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  curand_init(seed,0,0, &state[idx]);
}
__device__ float getrand(curandState *state)
{
  return (float)(curand_normal(state));
}

void io_fun(std::string file, float *x, const int N)
{
 std::ofstream myfile_tsN;
 myfile_tsN.open(file);
 for(int i = 0; i< N; i++)
 {
   myfile_tsN << x[i] << std::endl;
 }
 myfile_tsN.close();
}

int main()
{
  const int T = 1;
  const float dt = sqrt(T/float(N));

  size_t sz = N*sizeof(float);

  float *f, *dw, *devstate;
  f  = new float[N];
  dw = new float[N];
  rin= new float[N];


  float *d_f, *d_dw;
  cudaMalloc(&d_f,sz);
  cudaMalloc(&d_dw,sz);
  cudaMalloc(&devstate, sz)

  dim3 dimBlock(16,1,1);
  dim3 dimGrid(N/dimBlock.x,1,1);

  initialize<<<dimGrid, dimBlock>>>(d_f, d_dw);
  cudaDeviceSynchonize();
  init_r<<<dimGrid, dimBlock>>>(devstate,0);
  cudaDeviceSynchonize();

  std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
  BMwp<<<dimGrid, dimBlock>>>(d_f, d_dw, dt, devstate);
  cudaDeviceSynchonize();
  std::chrono::steady_clock::time_point end = chrono::steady_clock::now();

  cout << "Parallel Weiner Process time in microseconds: "
       << chrono::duration_cast<chrono::microseconds>(end - start).count()
       << " microseconds" << endl;

  cudaMemcpy(f, d_f,sz, cudaMemcpyDeviceToHost);
  cudaMemcpy(dw, d_dw,sz,cudaMemcpyDeviceToHost);


  std::string f3;
  f3 = "PARwp.dat";

  io_fun(f3, f, N);

  delete f, dw;

  cudaFree(d_f);
  cudaFree(devstate);
  cudaFree(d_dw);
}
