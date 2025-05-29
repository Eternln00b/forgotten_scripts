#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned char* ascii_decode(const char *input, int length);
unsigned char* xor_decrypt(unsigned char *data, int data_len, char *key, int key_len); 
