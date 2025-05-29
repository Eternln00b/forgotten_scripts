#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>
#include "shellcodefuncs.h"

unsigned char* ascii_decode(const char *input, int length) {

    int decoded_length = length / 4;

    unsigned char *output = (unsigned char *)malloc(decoded_length + 1);
    if (output == NULL) {
        fprintf(stderr, "Fuck.\n");
        exit(1);
    }

    for (int i = 0; i < decoded_length; i++) {
        sscanf(input + i * 4, "%3hhu ", &output[i]);
    }

    output[decoded_length] = '\0';
    return output;

}

unsigned char* xor_decrypt(unsigned char *data, int data_len, char *key, int key_len) {

    for (int i = 0; i < data_len; i++) {

        data[i] ^= key[i % key_len];

    }

    return data;

}