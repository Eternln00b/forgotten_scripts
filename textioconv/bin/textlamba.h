#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

char* octalconv(const char *input);
char* ascii_encode(const unsigned char *input);
void xor_encrypt(unsigned char *data, const char *key);