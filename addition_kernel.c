struct uint3 { unsigned int x, y, z; };
struct uint3 extern const threadIdx, blockIdx, blockDim;

__attribute__((global)) __attribute__((__used__)) void addition_kernel(float* a, float* b, float* c)
{
	__syncthreads();
	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	__syncthreads();
	c[idx] = a[idx] + b[idx];
	__syncthreads();
}

