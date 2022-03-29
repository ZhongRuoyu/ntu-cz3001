#include <stdio.h>

#define N 4
#define THREADS_PER_BLOCK 256

__host__ void print_vector(const char *name, const int vector[], size_t size) {
    if (name != NULL) {
        printf("%s ", name);
    }
    for (size_t i = 0; i < size; ++i) {
        printf("%2d ", vector[i]);
    }
    printf("\n");
}

__global__ void vector_add_cuda(int result[], const int a[], const int b[],
                                size_t size) {
    size_t index = blockDim.x * blockIdx.x + threadIdx.x;
    if (index < size) {
        result[index] = a[index] + b[index];
    }
}

int main(void) {
    int a[N] = {22, 13, 16, 5};
    int b[N] = {5, 22, 17, 37};
    int c[N];

    int *cuda_a, *cuda_b, *cuda_c;
    cudaMalloc(&cuda_a, sizeof a);
    cudaMalloc(&cuda_b, sizeof b);
    cudaMalloc(&cuda_c, sizeof c);
    cudaMemcpy(cuda_a, a, sizeof a, cudaMemcpyHostToDevice);
    cudaMemcpy(cuda_b, b, sizeof b, cudaMemcpyHostToDevice);

    vector_add_cuda<<<(N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK,
                      THREADS_PER_BLOCK>>>(cuda_c, cuda_a, cuda_b,
                                           sizeof c / sizeof(int));
    cudaDeviceSynchronize();

    cudaMemcpy(c, cuda_c, sizeof c, cudaMemcpyDeviceToHost);
    cudaFree(cuda_a);
    cudaFree(cuda_b);
    cudaFree(cuda_c);

    print_vector("A", a, sizeof a / sizeof(int));
    print_vector("B", b, sizeof b / sizeof(int));
    print_vector("C", c, sizeof c / sizeof(int));

    return 0;
}
