#include <stdio.h>
#include <stdlib.h>
#include "Address.h"

#define O_Size 8
#define W_Size 8
#define I_Size 15

#define O_TileSize 4
#define W_TileSize 8
#define I_TileSize 11

#define O_GroupSize 4
#define W_GroupSize 4
#define I_GroupSize 7


void main(){

    FILE *W_On_Chip_Addr_Fptr;
    FILE *I_On_Chip_Addr_Fptr;
    FILE *O_On_Chip_Addr_Fptr;

    FILE *W_Off_Chip_Addr_Fptr;
    FILE *I_Off_Chip_Addr_Fptr;
    FILE *O_Off_Chip_Addr_Fptr;

    W_On_Chip_Addr_Fptr = fopen("W_On_Address.txt","w");
    I_On_Chip_Addr_Fptr = fopen("I_On_Address.txt","w");
    O_On_Chip_Addr_Fptr = fopen("O_On_Address.txt","w");

    W_Off_Chip_Addr_Fptr = fopen("W_Off_Address.txt","w");
    I_Off_Chip_Addr_Fptr = fopen("I_Off_Address.txt","w");
    O_Off_Chip_Addr_Fptr = fopen("O_Off_Address.txt","w");
    
    int i, j, k, l;

    //Write Weight On-Chip Address File
    for(i = 0; i < (O_Size / O_TileSize); i++){
        for(j = 0; j < (O_TileSize / O_GroupSize); j++)
            for(k = 0; k < (W_Size / W_TileSize); k++){
                for(l = 0; l < W_TileSize; l++){
                    fprintf(W_On_Chip_Addr_Fptr, "%d\n", l);
                }
        }
    }
    
    //Write Input On-Chip Address File
    for(i = 0; i < (O_Size / O_TileSize); i++){
        for(j = 0; j < (O_TileSize / O_GroupSize); j++){
            for(k = 0; k < (W_Size / W_TileSize); k++){
                for(l = 0; l < (O_GroupSize + W_TileSize - 1); l++){
                    fprintf(I_On_Chip_Addr_Fptr, "%d\n", l);
                }
            }
        }
    }

    //Write Output On-Chip Address File
    for(i = 0; i < (O_Size / O_TileSize); i++){
        for(j = 0; j < (W_Size / W_TileSize); j++){
            for(k = 0; k < (O_TileSize / O_GroupSize); k++){
                for(l = 0; l < (O_GroupSize); l++){
                    fprintf(O_On_Chip_Addr_Fptr, "%d\n", k * O_GroupSize + l);
                }
            }   
        }
    }
    
    //Write Weight Off-Chip Address File
    for(i = 0; i < (O_Size / O_TileSize); i++){
        for(j = 0; j < W_Size; j++){
            fprintf(W_Off_Chip_Addr_Fptr, "%d\n", j);
        }
    }

    //Write Input Off-Chip Address File
    for(i = 0; i < (O_Size / O_TileSize); i++){
        for(j = 0; j < (W_Size / W_TileSize); j++){
            for(k = 0; k < (O_TileSize / O_GroupSize); k++){
                for(l = 0; l < (O_GroupSize + W_TileSize - 1); l++){
                    fprintf(I_Off_Chip_Addr_Fptr, "%d\n", i * O_TileSize + j * W_TileSize + k * O_GroupSize + l);
                }
            }
        }
    }

    //Write Output Off-Chip Address File
    for(i = 0; i < O_Size; i++){
        fprintf(O_Off_Chip_Addr_Fptr, "%d\n", i);
    }

    fclose(W_On_Chip_Addr_Fptr);
    fclose(O_On_Chip_Addr_Fptr);
    fclose(O_On_Chip_Addr_Fptr);
    fclose(W_Off_Chip_Addr_Fptr);
    fclose(I_Off_Chip_Addr_Fptr);
    fclose(O_Off_Chip_Addr_Fptr);

}
