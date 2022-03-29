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

__global__ void vector_dot_product_cuda(int *result, const int a[],
                                        const int b[], size_t size) {
    __shared__ int temp[THREADS_PER_BLOCK];
    size_t index = blockIdx.x * blockDim.x + threadIdx.x;
    temp[threadIdx.x] = index < size ? a[index] * b[index] : 0;
    __syncthreads();
    if (threadIdx.x == 0) {
        int sum = 0;
        for (size_t i = 0; i < sizeof temp / sizeof(int); ++i) {
            sum += temp[i];
        }
        atomicAdd(result, sum);
    }
}

int main(void) {
    int a[N] = {22, 13, 16, 5};
    int b[N] = {5, 22, 17, 37};
    int answer;

    int *cuda_a, *cuda_b, *cuda_answer;
    cudaMalloc(&cuda_a, sizeof a);
    cudaMalloc(&cuda_b, sizeof b);
    cudaMalloc(&cuda_answer, sizeof answer);
    cudaMemcpy(cuda_a, a, sizeof a, cudaMemcpyHostToDevice);
    cudaMemcpy(cuda_b, b, sizeof b, cudaMemcpyHostToDevice);

    vector_dot_product_cuda<<<(N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK,
                              THREADS_PER_BLOCK>>>(cuda_answer, cuda_a, cuda_b,
                                                   sizeof a / sizeof(int));
    cudaDeviceSynchronize();

    cudaMemcpy(&answer, cuda_answer, sizeof answer, cudaMemcpyDeviceToHost);
    cudaFree(cuda_a);
    cudaFree(cuda_b);
    cudaFree(cuda_answer);

    print_vector("A", a, sizeof a / sizeof(int));
    print_vector("B", b, sizeof b / sizeof(int));
    printf("Answer = %d\n", answer);

    return 0;
}
