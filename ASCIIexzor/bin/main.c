#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "asciifunct.h"

#define txtRsl "/tmp/txtEncryptedASCII.txt"

int main(int argc, char *argv[]) {

    int opt;
    char *plaintext = NULL;
    char *xor_key = "MySecretKey";
    unsigned int key_length = strlen(xor_key);

    while ((opt = getopt(argc, argv, "s:x:")) != -1) {
    
        switch (opt) {
    
            case 's':
    
                plaintext = optarg;
                break;
    
            case 'x':
    
                xor_key = optarg;
                break;
            
            default:
    
                fprintf(stderr, "\nUsage: %s -s <text to encrypt> [ ( optional ) -x <xor key> ]\n", argv[0]);
                return 1;
    
        }
    
    }

    if (plaintext == NULL) {

        fprintf(stderr, "\nUsage: %s -s <text to encrypt> [ ( optional ) -x <xor key> ]\n", argv[0]);
        return 1;

    }

    printf("\nXOR key: %s\n", xor_key);
    printf("\nnon encrypted text: %s\n", plaintext);

    char *plaintext_ascii = ascii_encode((const unsigned char *)plaintext, strlen(plaintext));

    xor_encrypt((unsigned char *)plaintext_ascii, strlen(plaintext_ascii), xor_key, key_length);
    printf("\nencoded and encrypted text: %s\n", plaintext_ascii);

    if (access(txtRsl, F_OK) != -1) remove(txtRsl);

    FILE *fichierFinal = fopen(txtRsl, "w");
    if (fichierFinal == NULL) {

        fprintf(stderr, "Error: Impossible to open the txt file %s\n",txtRsl);
        return 1;

    }

    else {

        fputs(plaintext_ascii,fichierFinal);
        fclose(fichierFinal);
        printf("\nThe text has been encoded in ASCII and encrypted with the XOR algorithm in the txt file %s !",txtRsl);

    }

    free(plaintext_ascii);

    return 0;

}
