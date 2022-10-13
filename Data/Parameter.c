#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/*
Parameter.txt:

W_Size
I_Size
O_Size
W_Off_Size
I_Off_Size
O_Off_Size
W_On_Size
I_On_Size
O_On_Size
W_PEGroupSize
I_PEGroupSize
O_PEGroupSize
W_Off_ReadTimes
I_Off_ReadTimes
O_Off_ReadTimes
W_On_ReadTimes
I_On_ReadTimes
O_On_ReadTimes

*/

/*
GenerateParameter.exe W_Size I_Size W_TileSize I_TileSize W_PEGroupSize O_PEGroupSize
*/
void main(int argc, char *argv[]){

    //Data Size
    int W_Size = 0, I_Size = 0, O_Size = 0;
    int W_TileSize = 0, I_TileSize = 0, O_TileSize = 0;
    int W_PEGroupSize = 0, I_PEGroupSize = 0, O_PEGroupSize = 0;

    //Adjust the size
    int W_On_Size = 0, I_On_Size = 0, O_On_Size = 0;
    int W_Off_Size = 0, I_Off_Size = 0, O_Off_Size = 0;

    int W_On_ReadTimes = 0, I_On_ReadTimes = 0, O_On_ReadTimes = 0;
    int W_Off_ReadTimes = 0, I_Off_ReadTimes = 0, O_Off_ReadTimes = 0;

    if(argc != 7){
        fprintf(stderr, "Incorrect Input of Parameters! There should be 6 inputs.\n");
    }
    else{
        printf("%s\n", argv[1]);
        W_Size = atoi(argv[1]);
        I_Size = atoi(argv[2]);
        O_Size = I_Size - W_Size + 1;

        W_TileSize = atoi(argv[3]);
        I_TileSize = atoi(argv[4]);
        O_TileSize = W_TileSize - I_TileSize + 1;

        W_PEGroupSize = atoi(argv[5]);
        O_PEGroupSize = atoi(argv[6]);
        I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1;

        if(W_TileSize % W_PEGroupSize == 0){
            W_On_Size = W_TileSize;
        }
        else{
            W_On_Size = (floor(W_TileSize / W_PEGroupSize) + 1) * W_PEGroupSize;
        }

        if(O_TileSize % O_PEGroupSize == 0){
            O_On_Size = O_TileSize;
        }
        else{
            O_On_Size = (floor(O_TileSize / O_PEGroupSize) + 1) * O_PEGroupSize;
        }
        
        I_On_Size = W_On_Size + O_On_Size - 1;
        
        if(W_Size % W_On_Size == 0){
            W_Off_Size = W_Size;
        }
        else{
            W_Off_Size = (floor((W_Size / W_On_Size)) + 1) * W_On_Size;
        }
        
        if(O_Size % O_On_Size == 0){
            O_Off_Size = O_Size;
        }
        else{
            O_Off_Size = (floor(O_Size / O_On_Size) + 1) * O_On_Size;
        }
        
        I_Off_Size = W_Off_Size + O_On_Size - 1;

        W_On_ReadTimes = (O_Off_Size / O_On_Size) * (O_On_Size / O_PEGroupSize) * (W_Off_Size / W_On_Size) * (W_On_Size / W_PEGroupSize) * W_PEGroupSize;
        I_On_ReadTimes = (O_Off_Size / O_On_Size) * (O_On_Size / O_PEGroupSize) * (W_Off_Size / W_On_Size) * (O_PEGroupSize + W_On_Size - 1);
        O_On_ReadTimes = (O_Off_Size / O_On_Size) * (O_On_Size / O_PEGroupSize) * O_PEGroupSize * (W_Off_Size / W_On_Size);
        
        W_Off_ReadTimes = (O_Off_Size / O_On_Size) * (W_Off_Size / W_On_Size) * W_On_Size;
        I_Off_ReadTimes = (O_Off_Size / O_On_Size) * (W_Off_Size / W_On_Size) * (O_PEGroupSize + W_On_Size - 1);
        O_Off_ReadTimes = (O_Off_Size / O_On_Size) * O_On_Size;

        FILE *Fptr;
        Fptr = fopen("Parameter.txt", "w");
        fprintf(Fptr, "%d\n", W_Size);
        fprintf(Fptr, "%d\n", I_Size);
        fprintf(Fptr, "%d\n", O_Size);
        fprintf(Fptr, "%d\n", W_Off_Size);
        fprintf(Fptr, "%d\n", I_Off_Size);
        fprintf(Fptr, "%d\n", O_Off_Size);
        fprintf(Fptr, "%d\n", W_On_Size);
        fprintf(Fptr, "%d\n", I_On_Size);
        fprintf(Fptr, "%d\n", O_On_Size);
        fprintf(Fptr, "%d\n", W_PEGroupSize);
        fprintf(Fptr, "%d\n", I_PEGroupSize);
        fprintf(Fptr, "%d\n", O_PEGroupSize);
        fprintf(Fptr, "%d\n", W_Off_ReadTimes);
        fprintf(Fptr, "%d\n", I_Off_ReadTimes);
        fprintf(Fptr, "%d\n", O_Off_ReadTimes);
        fprintf(Fptr, "%d\n", W_On_ReadTimes);
        fprintf(Fptr, "%d\n", I_On_ReadTimes);
        fprintf(Fptr, "%d\n", O_On_ReadTimes);

        FILE *Test_Fptr;
        Test_Fptr = fopen("Parameter.csv", "w");

        fprintf(Test_Fptr, "W_Size, %d\n", W_Size);
        fprintf(Test_Fptr, "I_Size, %d\n", I_Size);
        fprintf(Test_Fptr, "O_Size, %d\n", O_Size);
        fprintf(Test_Fptr, "W_Off_Size, %d\n", W_Off_Size);
        fprintf(Test_Fptr, "I_Off_Size, %d\n", I_Off_Size);
        fprintf(Test_Fptr, "O_Off_Size, %d\n", O_Off_Size);
        fprintf(Test_Fptr, "W_On_Size, %d\n", W_On_Size);
        fprintf(Test_Fptr, "I_On_Size, %d\n", I_On_Size);
        fprintf(Test_Fptr, "O_On_Size, %d\n", O_On_Size);
        fprintf(Test_Fptr, "W_PEGroupSize, %d\n", W_PEGroupSize);
        fprintf(Test_Fptr, "I_PEGroupSize, %d\n", I_PEGroupSize);
        fprintf(Test_Fptr, "O_PEGroupSize, %d\n", O_PEGroupSize);
        fprintf(Test_Fptr, "W_Off_ReadTimes, %d\n", W_Off_ReadTimes);
        fprintf(Test_Fptr, "I_Off_ReadTimes, %d\n", I_Off_ReadTimes);
        fprintf(Test_Fptr, "O_Off_ReadTimes, %d\n", O_Off_ReadTimes);
        fprintf(Test_Fptr, "W_On_ReadTimes, %d\n", W_On_ReadTimes);
        fprintf(Test_Fptr, "I_On_ReadTimes, %d\n", I_On_ReadTimes);
        fprintf(Test_Fptr, "O_On_ReadTimes, %d\n", O_On_ReadTimes);

        fclose(Fptr);
        fclose(Test_Fptr);
    }
}