#include <stdio.h>
#include <stdlib.h>

#define BROKEN_BIT_INDEX 7

// TODO: freestyle starts here, implement Task 2
void task2(void *encrypted_data, int size) {
    unsigned char *s = (unsigned char *) encrypted_data;
    for ( int i = 0 ; i < size ; i++ ) {
        unsigned char aux = s[i];
        aux >>= 7;
        if ( aux != 0 ) {
            s[i] <<= 1;
            s[i] >>= 1;
            printf("%c", s[i]);
        }
    }
    printf("\n");

}
