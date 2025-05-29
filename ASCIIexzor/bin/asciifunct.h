#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* ascii_encode(const unsigned char *input, int length);
unsigned char* xor_encrypt(unsigned char *data, int data_len, char *key, int key_len);