#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "asciifunct.h"

// Encode in ASCII
char* ascii_encode(const unsigned char *input, int length) {
    
    char *output = (char *)malloc(length * 4 + 1);
    
    if (output == NULL) {
    
        fprintf(stderr, "Memory allocation error. \n");
        exit(1);
    
    }

    for (int i = 0; i < length; i++) {
    
        sprintf(output + i * 4, "%03d ", input[i]);
    
    }
    output[length * 4] = '\0';

    return output;

}

// XOR encrypting
unsigned char* xor_encrypt(unsigned char *data, int data_len, char *key, int key_len){

    for (int i = 0; i < data_len; i++) {

        data[i] ^= key[i % key_len];

    }

    return data;

}
