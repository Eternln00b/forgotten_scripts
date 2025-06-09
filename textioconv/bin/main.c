#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "textlamba.h"

int main(int argc, char *argv[]) {

    int opt;
    char *plaintext = NULL;
    char *xor_key = "MySecretKey";
    
    while ((opt = getopt(argc, argv, "s:x:")) != -1) {
    
        switch (opt) {
    
            case 's':
    
                plaintext = optarg;
                break;
    
            case 'x':
    
                xor_key = optarg;
                break;
            
            default:
    
                fprintf(stderr, "\nUsage: %s -s <text to encrypt> [opt][-x <xor key>]\n", argv[0]);
                return 1;
    
        }
    
    }

    if (plaintext == NULL) {

        fprintf(stderr, "\nUsage: %s -s <text to encrypt> [opt][-x <xor key>]\n", argv[0]);
        return 1;

    }

    char *plaintext_ascii = ascii_encode((const unsigned char *)plaintext);
    xor_encrypt((unsigned char *)plaintext_ascii, xor_key);
    char *plaintext_octal = octalconv(plaintext_ascii);

    size_t outf = strlen(plaintext_octal);
    plaintext_octal[outf-1] = '\0';

    printf("%s", plaintext_octal);

    return 0;
}

