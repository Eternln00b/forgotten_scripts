#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "asciifunct.h"

char* ascii_encode(const unsigned char *input){
    
    if (!input) return NULL;
    size_t len = strlen((const char *)input);
    char *output = malloc(len * 4 + 1);
    
    if (output == NULL) {
    
        fprintf(stderr, "Memory allocation error. \n");
        exit(1);
    
    }

    for (unsigned int i = 0; i < len; i++) {
    
        sprintf(output + i * 4, "%03d\x22", input[i]);
    
    }

    output[len * 4] = '\0';
    return output;

}

void xor_encrypt(unsigned char *data, const char *key){

    unsigned int data_len = strlen((const char *)data);    
    unsigned int key_len = strlen((const char *)key); 

    for (unsigned int i = 0; i < data_len; i++) {

        data[i] ^= key[i % key_len];

    }

}
