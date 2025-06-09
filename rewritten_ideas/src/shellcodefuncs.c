#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>
#include "shellcodefuncs.h"

unsigned char* ascii_decode(const char *input){

    if (!input) return NULL;
    size_t dlen = strlen((const char *)input);
    unsigned char *output = malloc(dlen * 4 + 1);

    if (output == NULL) {
    
        fprintf(stderr, "Fuck.\n");
        exit(1);
    
    }

    for (size_t i = 0; i < dlen; i++) {
    
        sscanf(input + i * 4, "%3hhu\x20", &output[i]);
    
    }

    output[dlen] = '\0';
    return output;

}

void xor_decrypt(unsigned char *data, const char *key){

    if (!data || !key) return; 
    unsigned int data_len = strlen((const char *)data);    
    unsigned int key_len = strlen(key); 

    for (unsigned int i = 0; i < data_len; i++) {

        data[i] ^= key[i % key_len];

    }

}