
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "typedef.h"
#include "enc.h"
#include <time.h>




static const char* pass = "pass";
static const char* fail = "fail";

#define AMR_MAGIC_NUMBER "#!AMR-WB\n"

static const char* name[] = { "Word8", "UWord8", "Word16", "Word32", "Float32",
"Float64" };


__device__ static const unsigned long size[][2] = {
	{ sizeof(Word8), 1 },
	{ sizeof(UWord8), 1 },
	{ sizeof(Word16), 2 },
	{ sizeof(Word32), 4 },
	{ sizeof(Float32), 4 },
	{ sizeof(Float64), 8 }
};

__global__ void amrenc(int *c) {
	int i, j;
	int dtx = 0;
	*c = dtx + 4;
	enc_interface_State enstate;
	Encoder_Interface_init(&enstate, dtx);
	//dec_interface_State destate;
//	Decoder_Interface_init(&destate);
	//srand(0);
		//int req_mode = 7;
	short speech[160];
	for (j = 0; j < 160; j++) {
		speech[j] = 48;//(short)rand();
	}
	//fwrite(speech, sizeof(short int), 160, pcm_orig);
	unsigned char serial_data[32];
	int byte_counter = Encoder_Interface_Encode(&enstate, (Mode)7, speech, serial_data, 0);
		printf("the result is %d,%s\n",*c, speech);
		//fwrite(serial_data, sizeof(char), byte_counter, amrnb);
		/*printf("test times: %d, bytes: %d\n", i, byte_counter);*/
		//int dec_mode = (serial_data[0] >> 3) & 0x000F;
		//int read_size = block_size[dec_mode];
		//Decoder_Interface_Decode(&destate, serial_data, speech, 0);
		//fwrite(speech, sizeof(short int), 160, pcm_back);
		/*printf("test times: %d, bytes: %d\n", i, read_size);*/

}
int main() {
	int i, j;
	clock_t start, finish;

	double  duration;
	for (i = 0; i < 6; i++) {
		const char* result = (size[i][0] == size[i][1] ? pass : fail);
		printf("%s size: %lu, %s\n", name[i], size[i][0], result);
		if (result == fail) {
			exit(1);
		}

	//FILE* pcm_orig = fopen("cclnb.orig", "wb");
	//FILE* amrnb = fopen("cclnb.amrnb", "wb");
	//FILE* pcm_back = fopen("cclnb.back", "wb");
	//if (NULL == pcm_orig) exit(1);
	//if (NULL == amrnb) exit(1);
	//if (NULL == pcm_back) exit(1);
	//fwrite(AMR_MAGIC_NUMBER, sizeof(char), strlen(AMR_MAGIC_NUMBER), amrnb);
	}
	enc_interface_State *host_enstate;
	int *device_c;
	int c; 
	cudaMalloc(&device_c, sizeof(int));
	amrenc <<<100, 500 >>>(device_c);
	start = clock();
	cudaMemcpy(&c, device_c, sizeof(int), cudaMemcpyDeviceToHost);
	finish = clock();
	duration = (double)(finish - start) / CLOCKS_PER_SEC;
	printf("%f seconds,%d\n", duration,c);
	system("pause");
	//fclose(pcm_orig);
	//fclose(amrnb);
	//fclose(pcm_back);
	return 0;
}
