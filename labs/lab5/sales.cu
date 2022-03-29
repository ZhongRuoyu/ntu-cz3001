#include <stdio.h>
#include <stdlib.h>

#define THREADS_PER_BLOCK 256

__global__ void aggregate(unsigned int items_count, unsigned int days_count,
                          const float prices[], unsigned int *const records[],
                          float total[]) {
    __shared__ float temp[THREADS_PER_BLOCK];
    unsigned int day = blockIdx.x;
    unsigned int index = threadIdx.x;
    unsigned int stride = THREADS_PER_BLOCK;
    temp[index] = 0;
    for (unsigned int i = index; i < items_count; i += stride) {
        temp[i] += prices[i] * records[i][day];
    }
    __syncthreads();
    if (index == 0) {
        float sum = 0;
        for (size_t i = 0; i < sizeof temp / sizeof(float); ++i) {
            sum += temp[i];
        }
        total[day] = sum;
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <path-to-records>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char *records_filename = argv[1];
    FILE *records_file = fopen(records_filename, "r");
    if (records_file == NULL) {
        fprintf(stderr, "Failed to open file %s.\n", records_filename);
        exit(EXIT_FAILURE);
    }

    unsigned int items_count, days_count;
    fscanf(records_file, "%u%u", &items_count, &days_count);
    float *prices = (float *)malloc(items_count * sizeof(float));
    unsigned int **records =
        (unsigned int **)malloc(items_count * sizeof(unsigned int *));
    for (unsigned int i = 0; i < items_count; ++i) {
        fscanf(records_file, "%f", &prices[i]);
        records[i] = (unsigned int *)malloc(days_count * sizeof(unsigned int));
    }
    for (unsigned int i = 0; i < items_count; ++i) {
        for (unsigned int j = 0; j < days_count; ++j) {
            fscanf(records_file, "%u", &records[i][j]);
        }
    }
    fclose(records_file);

    float *prices_cuda;
    cudaMalloc(&prices_cuda, items_count * sizeof(float));
    cudaMemcpy(prices_cuda, prices, items_count * sizeof(float),
               cudaMemcpyHostToDevice);
    unsigned int **records_cuda;
    cudaMalloc(&records_cuda, items_count * sizeof(unsigned int *));
    unsigned int **records_cuda_ptrs =
        (unsigned int **)malloc(items_count * sizeof(unsigned int *));
    for (unsigned int i = 0; i < items_count; ++i) {
        cudaMalloc(&records_cuda_ptrs[i], days_count * sizeof(unsigned int));
        cudaMemcpy(records_cuda_ptrs[i], records[i],
                   days_count * sizeof(unsigned int), cudaMemcpyHostToDevice);
    }
    cudaMemcpy(records_cuda, records_cuda_ptrs,
               items_count * sizeof(unsigned int *), cudaMemcpyHostToDevice);
    float *total_cuda;
    cudaMalloc(&total_cuda, days_count * sizeof(float));

    aggregate<<<days_count, THREADS_PER_BLOCK>>>(
        items_count, days_count, prices_cuda, records_cuda, total_cuda);
    cudaDeviceSynchronize();

    float *total = (float *)malloc(days_count * sizeof(float));
    cudaMemcpy(total, total_cuda, days_count * sizeof(float),
               cudaMemcpyDeviceToHost);
    cudaFree(total_cuda);
    for (unsigned int i = 0; i < items_count; ++i) {
        cudaFree(records_cuda_ptrs[i]);
    }
    free(records_cuda_ptrs);
    cudaFree(records_cuda);
    cudaFree(prices_cuda);

    for (unsigned int i = 0; i < days_count; ++i) {
        printf("%.2f ", total[i]);
    }
    printf("\n");

    free(total);
    for (unsigned int i = 0; i < items_count; ++i) {
        free(records[i]);
    }
    free(records);
    free(prices);

    return 0;
}
