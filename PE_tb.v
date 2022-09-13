`timescale 1ps/1ps
module PE_tb
    #(  parameter DataWidth = 32,
        parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)();
		  	
        reg [DataWidth-1:0] W_DataIn, I_DataIn, O_DataIn;
        reg W_DataInValid, W_DataOutRdy;
        reg I_DataInValid, I_DataOutRdy;
        reg O_DataInValid, O_DataOutRdy; //O_DataOutRdy is used to peek the next PE
        
        reg clk;
        reg rst;

        wire  [DataWidth-1:0] W_DataOut,I_DataOut;
        wire  [DataWidth-1:0] O_DataOut;
        wire  W_DataInRdy,W_DataOutValid;
        wire  I_DataInRdy,I_DataOutValid;
        wire  O_DataInRdy,O_DataOutValid;

        PE #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
            .MUL_Pipeline_Stages(MUL_Pipeline_Stages), .ADD_Pipeline_Stages(ADD_Pipeline_Stages), .Pipeline_Stages(Pipeline_Stages))
        dut(.clk(clk), .rst(rst),
            .W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
            .W_DataOut(W_DataOut), .W_DataOutValid(W_DataOutValid), .W_DataOutRdy(W_DataOutRdy),
            .I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
            .I_DataOut(I_DataOut), .I_DataOutValid(I_DataOutValid), .I_DataOutRdy(I_DataOutRdy),
            .O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
            .O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut));

    initial begin
        clk = 1;
        rst = 1;
        
        W_DataInValid = 0;
        I_DataInValid = 0;
        O_DataInValid = 0;
        W_DataIn = 0;
        I_DataIn = 0;
        O_DataIn = 0;
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;
        #1
        rst = 0;
        
        #2

        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h4080_0000; //4
        O_DataIn = 32'h4220_0000; //40
        W_DataOutRdy = 1;
        I_DataOutRdy = 1;
        O_DataOutRdy = 1;
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h42c80000; //100
        I_DataIn = 32'h43480000; //200
        O_DataIn = 32'h447a0000; //1000
        W_DataOutRdy = 1;
        I_DataOutRdy = 1;
        O_DataOutRdy = 1;
        #2
        W_DataInValid = 0;
        I_DataInValid = 0;
        O_DataInValid = 0;
        W_DataIn = 32'h0000_0000; //0
        I_DataIn = 32'h0000_0000; //0
        O_DataIn = 32'h0000_0000; //0
        W_DataOutRdy = 1;
        I_DataOutRdy = 1;
        O_DataOutRdy = 1;               
        #12
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h4080_0000; //4
        O_DataIn = 32'h4220_0000; //40
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;
        #12
        W_DataInValid = 0;
        I_DataInValid = 0;
        O_DataInValid = 0;
        W_DataIn = 32'h4170_0000;
        I_DataIn = 32'h4080_0000;
        O_DataIn = 32'h4220_0000;
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;

    end

    always #1 clk = ~clk;
    
endmodule
