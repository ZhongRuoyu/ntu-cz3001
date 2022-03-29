#include <stdio.h>

#define BLOCKS_COUNT 2
#define THREADS_PER_BLOCK 4

__host__ void hello_cpu() {
    printf("Hello from CPU!\n");
}

__global__ void hello_gpu() {
    printf("Hello from GPU%u[%u]!\n", blockIdx.x, threadIdx.x);
}

int main(void) {
    hello_cpu();
    hello_gpu<<<BLOCKS_COUNT, THREADS_PER_BLOCK>>>();
    cudaDeviceSynchronize();
    return 0;
}
