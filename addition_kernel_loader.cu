#include <assert.h>
#include <cuda.h>
#include <stdio.h>

int sum_host(const char* source, float* aDev, float* bDev, float* cDev, float *c, int n)
{
	int nb = n * sizeof(float);
	void* args[] = { (void*)&aDev, (void*)&bDev, (void*)&cDev };
	// Load module.
	CUmodule module;
	CUresult cuerr;
	cuerr = cuModuleLoad(&module, source);
	assert(cuerr == CUDA_SUCCESS);

	// Load kernel.
	CUfunction kernel;
	cuerr = cuModuleGetFunction(&kernel, module, "addition_kernel");
	assert(cuerr == CUDA_SUCCESS);
	
	// Launch kernel.
	cuerr = cuLaunchKernel(kernel,
		n / BLOCK_SIZE, 1, 1, BLOCK_SIZE, 1, 1, 512,
		0, args, NULL);

	// Check error status from the launched kernel.
	cudaError_t cudaerr = cudaGetLastError();
	// Wait for kernel completion.
	cudaerr = cudaDeviceSynchronize();

	// Copy the resulting array back to the host memory.
	cudaerr = cudaMemcpy(c, cDev, nb, cudaMemcpyDeviceToHost);

	return 1;
}

#include <malloc.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

double getTime()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	double seconds = tv.tv_sec*1000000;
	double milliseconds = tv.tv_usec;
	//printf("%lf\n", milliseconds);
	return (seconds+milliseconds);
}

int main ( int argc, char* argv[] )
{
	long long power = 1;
	int n = 512000000, nb = n * sizeof(float);
	float* a = (float*)malloc(nb);
	float* b = (float*)malloc(nb);
	float* c = (float*)malloc(nb);
	double idrandmax = 1.0 / RAND_MAX;

	float* aDev = NULL;
	float* bDev = NULL;
	float* cDev = NULL;
	
	int result = 0;	


	CUresult cuerr;

	// Allocate memory on the GPU.
	cudaError_t cudaerr = cudaMalloc((void**)&aDev, nb);
	cudaerr = cudaMalloc((void**)&bDev, nb);
	cudaerr = cudaMalloc((void**)&cDev, nb);

	// Copy input data to device memory.
	cudaerr = cudaMemcpy(aDev, a, nb, cudaMemcpyHostToDevice);
	cudaerr = cudaMemcpy(bDev, b, nb, cudaMemcpyHostToDevice);

	for (int i = 0; i < n; i++)
	{
		a[i] = rand() * idrandmax;
		b[i] = rand() * idrandmax;
	}
	double startTime = getTime();
	for(int count=1; count<=20; count++)
	{
		int k=0;
		//power = power*10;

		//while(k<power)
		{
			int status = sum_host (argv[1], aDev, bDev, cDev, c, n);
			//if (status) return status;
			k++;
		}
		
	}
	double endTime = getTime();
	printf("%lf ", (endTime-startTime)/1000000.0);
	// Release device memory.
	if (aDev) cudaFree(aDev);
	if (bDev) cudaFree(bDev);
	if (cDev) cudaFree(cDev);
	return 0;
}

