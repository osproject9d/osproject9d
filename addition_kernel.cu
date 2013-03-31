
__global__ void addition_kernel(float* a, float* b, float* c)
{
	int idx = threadIdx.x + blockIdx.x * blockDim.x;

	c[idx] = a[idx] + b[idx];
}
/*
#define N (2048*2048)
#define THREADS_PER_BLOCK 512
__global__ void dot( int *a, int *b, int *c ) {
__shared__ int temp[THREADS_PER_BLOCK];
int index = threadIdx.x + blockIdx.x * blockDim.x;
temp[threadIdx.x] = a[index] * b[index];
__syncthreads();
if( 0 == threadIdx.x ) {
int sum = 0;
for( int i = 0; i < THREADS_PER_BLOCK; i++ )
sum += temp[i];
atomicAdd(
*c += sum; c , sum );
}
}
*/
