#define O_GroupSize 4
#define W_GroupSize 4
#define I_GroupSize 7
#define Block_Count 4


float MAC(float W_Data, float I_Data, float O_Data){
    float O_Result = W_Data * I_Data + O_Data;
    return O_Result;
};

float ACC(float Data1, float Data2){
    float Result = Data1 + Data2;
    return Result;
};

void main(){
    float WeightData = 15;
    float InputData = 4;
    float OutputData = 5;

    float PE_Result [O_GroupSize][W_GroupSize];
    float W_Data [O_GroupSize][W_GroupSize];
    float I_Data [O_GroupSize][W_GroupSize];
    float O_Data [O_GroupSize][W_GroupSize];

    //control signals
    
    //Read/Write PE Address
    int O_In_PEAddr = 0;
    int O_Out_PEAddr = 0;
    int I_PEAddr = 0;
    int W_PEAddr = 0;
    //outside
    _Bool W_DataInValid;
    _Bool I_DataInValid;
    _Bool O_DataInValid;
    _Bool W_DataInRdy;
    _Bool I_DataInRdy;
    _Bool O_DataInRdy;
    _Bool W_DataOutValid;
    _Bool I_DataOutValid;
    _Bool O_DataOutValid;
    _Bool W_DataOutRdy;
    _Bool I_DataOutRdy;
    _Bool O_DataOutRdy; 

    //across PEs
    _Bool W_InValid [O_GroupSize][W_GroupSize];
    _Bool I_InValid [O_GroupSize][W_GroupSize];
    _Bool O_InValid [O_GroupSize][W_GroupSize];
    _Bool W_InRdy [O_GroupSize][W_GroupSize];
    _Bool I_InRdy [O_GroupSize][W_GroupSize];
    _Bool O_InRdy [O_GroupSize][W_GroupSize];
    _Bool W_OutValid [O_GroupSize][W_GroupSize];
    _Bool I_OutValid [O_GroupSize][W_GroupSize];
    _Bool O_OutValid [O_GroupSize][W_GroupSize];
    _Bool W_OutRdy [O_GroupSize][W_GroupSize];
    _Bool I_OutRdy [O_GroupSize][W_GroupSize];
    _Bool O_OutRdy [O_GroupSize][W_GroupSize];

    _Bool W_Rec_Handshaking;
    _Bool I_Rec_Handshaking;
    _Bool O_Rec_Handshaking;
    _Bool O_Send_Handshaking;
    _Bool W_DataInRdy = W_InRdy[0][W_PEAddr];

    W_Rec_Handshaking = W_DataInValid & W_DataInRdy;
    if(W_Rec_Handshaking){
        W_Data[0][W_PEAddr] = WeightData; 
    }

    //Block Count
    int O_In_Block_Count;
    int O_Out_Block_Count;
    int I_Block_Count;

    _Bool O_IN_BLOCK_COUNT_EQUALS_TO_ZERO;
    _Bool O_IN_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT;

    _Bool O_OUT_BLOCK_COUNT_EQUALS_TO_ZERO;
    _Bool O_OUT_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT;

    _Bool I_BLOCK_COUNT_EQUALS_TO_ZERO;
    _Bool I_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT;

    O_IN_BLOCK_COUNT_EQUALS_TO_ZERO = (O_In_Block_Count == 0);
    O_IN_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT = (O_In_Block_Count == Block_Count);

    O_OUT_BLOCK_COUNT_EQUALS_TO_ZERO = (O_Out_Block_Count == 0);
    O_OUT_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT = (O_Out_Block_Count == Block_Count);

    if(O_Send_Handshaking && O_OUT_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT){
        O_Out_Block_Count = 0;
    }
    else if(O_Send_Handshaking){
        O_Out_Block_Count = 0;
    }

    I_BLOCK_COUNT_EQUALS_TO_ZERO = (I_Block_Count == 0);
    I_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT = (I_Block_Count == Block_Count);
    
    if(I_Rec_Handshaking && I_BLOCK_COUNT_EQAULS_TO_BLOCK_COUNT){
        I_Block_Count = 0;
    }
    else if(I_Rec_Handshaking){
        I_Block_Count++;
    }
    

    
    //Connect the data(edge)
    W_Data[0][0] = WeightData;
    W_Data[0][1] = WeightData;
    W_Data[0][2] = WeightData;
    W_Data[0][3] = WeightData;

    I_Data[0][0] = InputData;
    I_Data[1][0] = InputData;
    I_Data[2][0] = InputData;
    I_Data[3][0] = InputData;
    I_Data[3][1] = InputData;
    I_Data[3][2] = InputData;
    I_Data[3][3] = InputData;

    O_Data[0][0] = OutputData;
    O_Data[1][0] = OutputData;
    O_Data[2][0] = OutputData;
    O_Data[3][0] = OutputData;

    //connect the data
    W_Data[1][0] = W_Data[0][0];
    W_Data[1][1] = W_Data[0][1];
    W_Data[1][2] = W_Data[0][2];
    W_Data[1][3] = W_Data[0][3];
    W_Data[2][0] = W_Data[1][0];
    W_Data[2][1] = W_Data[1][1];
    W_Data[2][2] = W_Data[1][2];
    W_Data[2][3] = W_Data[1][3];
    W_Data[3][0] = W_Data[2][0];
    W_Data[3][1] = W_Data[2][1];
    W_Data[3][2] = W_Data[2][2];
    W_Data[3][3] = W_Data[2][3];

    I_Data[0][1] = I_Data[1][0];

    I_Data[1][1] = I_Data[2][0];
    I_Data[0][2] = I_Data[1][1];

    I_Data[2][1] = I_Data[3][0];
    I_Data[1][2] = I_Data[2][1];
    I_Data[0][3] = I_Data[1][2];

    I_Data[2][2] = I_Data[3][1];
    I_Data[1][3] = I_Data[2][2];
    I_Data[0][0] = I_Data[1][3]; //Reuse

    I_Data[2][3] = I_Data[3][2];
    I_Data[1][0] = I_Data[2][3]; //Reuse
    
    I_Data[2][0] = I_Data[3][3]; //Reuse

    O_Data[0][1] = O_Data[0][0];
    O_Data[0][2] = O_Data[0][1];
    O_Data[0][3] = O_Data[0][2];
    O_Data[1][1] = O_Data[1][0];
    O_Data[1][2] = O_Data[1][1];
    O_Data[1][3] = O_Data[1][2];
    O_Data[2][1] = O_Data[2][0];
    O_Data[2][2] = O_Data[2][1];
    O_Data[2][3] = O_Data[2][2];
    O_Data[3][1] = O_Data[3][0];
    O_Data[3][2] = O_Data[3][1];
    O_Data[3][3] = O_Data[3][2];

    
    if(I_Rec_Handshaking){
        switch (I_PEAddr){
        case 0:
            I_InValid[0][0] = I_DataInValid;
            I_InValid[1][0] = I_DataInValid;
            I_InValid[2][0] = I_DataInValid;
            I_InValid[3][0] = I_DataInValid;
            I_InValid[3][1] = I_DataInValid;
            I_InValid[3][2] = I_DataInValid;
            I_InValid[3][3] = I_DataInValid;
            break;
        case 1:
        default:
            break;
        }
    }
    
    for(int o_index = 0; o_index < O_GroupSize; o_index++){
        for(int w_index = 0; w_index < W_GroupSize; w_index++){
            PE_Result[o_index][w_index] = MAC(W_Data[o_index][w_index], I_Data[o_index][w_index], O_Data[o_index][w_index]);
        }         
    }
}