#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "Validate.h"

#define O_Size 8

void main(){

    FILE *ans_fptr;
    FILE *result_fptr;
    FILE *analysis_fptr;

    ans_fptr = fopen("Answer.txt","r");
    result_fptr = fopen("Result.txt", "r");
    analysis_fptr = fopen("Analysis.csv", "w");

    int i, j;
    char *ieee_answer;
    char *ieee_result;

    ieee_answer = (char*)malloc(32 * sizeof(char));
    ieee_result = (char*)malloc(32 * sizeof(char));

    float float_answer;
    float float_result;

    IEEEfloat var;

    fprintf(analysis_fptr, "Answer, Result, Error\n");

    for(i = 0; i < O_Size; i++){
        fscanf(ans_fptr, "%s", ieee_answer);
        fscanf(result_fptr, "%s", ieee_result);
        float_answer = TransformIEEEIntoInteger(ieee_answer);
        float_result = TransformIEEEIntoInteger(ieee_result);
        //the error must lower than 0.1%
        //assert(((float_result - float_answer)/float_answer) <= 0.001);
        fprintf(analysis_fptr, "%f, %f, %f\n", float_answer, float_result, ((float_result - float_answer)/float_answer));

    }


    fclose(ans_fptr);
    fclose(result_fptr);
    fclose(analysis_fptr);

}
