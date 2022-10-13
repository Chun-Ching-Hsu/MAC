#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Data.h"

#define W_Size 8
#define O_Size 8
#define I_Size 15



void main(){

    srand((unsigned int)time(NULL));

    float W_Data [W_Size];
    float I_Data [I_Size];
    float O_Data [O_Size];

    Clear1DArray(W_Data, W_Size);
    Clear1DArray(I_Data, I_Size);
    Clear1DArray(O_Data, O_Size);

    RandomFloat(W_Data, W_Size, (float)0, (float)1000);
    RandomFloat(I_Data, I_Size, (float)0, (float)1000);

    printf("\nWeight Data:\n");
    Display1DArray(W_Data, W_Size);
    printf("\nInput Data:\n");
    Display1DArray(I_Data, I_Size);
    printf("\nOutput Data:\n");
    Display1DArray(O_Data, O_Size);

    FILE *w_fptr;
    FILE *i_fptr;
    FILE *o_fptr;
    FILE *ans_fptr;

    w_fptr = fopen("W_Data.txt","w");
    i_fptr = fopen("I_Data.txt","w");
    o_fptr = fopen("O_Data.txt","w");
    ans_fptr = fopen("Answer.txt","w");

    int* write_ptr;
    write_ptr = (int*)malloc(32 * sizeof(int));

    int i, j;

    //write to weight data file
    for(i = 0; i < W_Size; i++){
        write_ptr = FloatToIEEEBinary(W_Data[i]);
        for(j = 31; j >= 0; j--){
            fprintf(w_fptr, "%d", write_ptr[j]);
        }
        fprintf(w_fptr, "\n");
    }

    //write to input data file
    for(i = 0; i < I_Size; i++){
        write_ptr = FloatToIEEEBinary(I_Data[i]);
        for(j = 31; j >= 0; j--){
            fprintf(i_fptr, "%d", write_ptr[j]);
        }
        fprintf(i_fptr, "\n");
    }

    //write to output data file
    for(i = 0; i < O_Size; i++){
        write_ptr = FloatToIEEEBinary(O_Data[i]);
        for(j = 31; j >= 0; j--){
            fprintf(o_fptr, "%d", write_ptr[j]);
        }
        fprintf(o_fptr, "\n");
    }

    //compute answer
    for(i = 0; i < O_Size; i++){
        for(j = 0; j < W_Size; j++){
            O_Data[i] += W_Data[j] * I_Data[i+j];
        }
    }
    printf("\nAnswer:\n");
    Display1DArray(O_Data, O_Size);

    //write to answer file
    for(i = 0; i < O_Size; i++){
        write_ptr = FloatToIEEEBinary(O_Data[i]);
        for(j = 31; j >= 0; j--){
            fprintf(ans_fptr, "%d", write_ptr[j]);
        }
        fprintf(ans_fptr, "\n");
    }

    fclose(w_fptr);
    fclose(i_fptr);
    fclose(o_fptr);
    fclose(ans_fptr);

}
