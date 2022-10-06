`timescale 1ps/1ps
module PE_tb
    #(  parameter DataWidth = 32,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)();

        parameter BufferWidth = 4;
        parameter BufferSize = 16;
		  	
        reg [DataWidth-1:0] W_DataIn, I_DataIn, O_DataIn;
        reg W_DataInValid, W_DataOutRdy;
        reg I_DataInValid, I_DataOutRdy;
        reg O_DataInValid, O_DataOutRdy; //O_DataOutRdy is used to peek the next PE
        
        reg clk;
        reg aclr;

        wire  [DataWidth-1:0] W_DataOut,I_DataOut;
        wire  [DataWidth-1:0] O_DataOut;
        wire  W_DataInRdy,W_DataOutValid;
        wire  I_DataInRdy,I_DataOutValid;
        wire  O_DataInRdy,O_DataOutValid;
        
        PE #(.DataWidth(DataWidth), .MUL_Pipeline_Stages(MUL_Pipeline_Stages), 
        .ADD_Pipeline_Stages(ADD_Pipeline_Stages), .Pipeline_Stages(Pipeline_Stages))
        dut(.clk(clk), .aclr(aclr),
            .W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
            .W_DataOut(W_DataOut), .W_DataOutValid(W_DataOutValid), .W_DataOutRdy(W_DataOutRdy),
            .I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
            .I_DataOut(I_DataOut), .I_DataOutValid(I_DataOutValid), .I_DataOutRdy(I_DataOutRdy),
            .O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
            .O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut));

    initial begin
        clk = 1;
        aclr = 1;
        
        W_DataInValid = 0;
        I_DataInValid = 0;
        O_DataInValid = 0;
        W_DataIn = 0;
        I_DataIn = 0;
        O_DataIn = 0;
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;

        //Block 0
        #1
        aclr = 0;
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h40a0_0000; //5
        I_DataIn = 32'h3f80_0000; //1
        O_DataIn = 32'h4120_0000; //10
        W_DataOutRdy = 1;
        I_DataOutRdy = 1;
        O_DataOutRdy = 1;
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4120_0000; //10
        I_DataIn = 32'h4000_0000; //2
        O_DataIn = 32'h41a0_0000; //20
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h4040_0000; //3
        O_DataIn = 32'h41f0_0000; //30              
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h41a0_0000; //20
        I_DataIn = 32'h4080_0000; //4
        O_DataIn = 32'h4220_0000; //40
        //End of Block0

        //Block 1
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h40a0_0000; //5
        I_DataIn = 32'h40a0_0000; //5
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4120_0000; //10
        I_DataIn = 32'h40c0_0000; //6
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h40e0_0000; //7
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h41a0_0000; //20
        I_DataIn = 32'h4100_0000; //8
        O_DataIn = 32'h0000_0000; //0
        //End of Block1
        
        //Block 2
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h40a0_0000; //5
        I_DataIn = 32'h4110_0000; //9
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4120_0000; //10
        I_DataIn = 32'h4120_0000; //10
        O_DataIn = 32'h0000_0000; //0

        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h4130_0000; //11
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h41a0_0000; //20
        I_DataIn = 32'h4140_0000; //12
        O_DataIn = 32'h0000_0000; //0
        //End of Block2
        
        //Block 3
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h40a0_0000; //5
        I_DataIn = 32'h4150_0000; //13
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4120_0000; //10
        I_DataIn = 32'h4160_0000; //14
        O_DataIn = 32'h0000_0000; //0

        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h4170_0000; //15
        I_DataIn = 32'h4170_0000; //15
        O_DataIn = 32'h0000_0000; //0
        #2
        W_DataInValid = 1;
        I_DataInValid = 1;
        O_DataInValid = 1;
        W_DataIn = 32'h41a0_0000; //20
        I_DataIn = 32'h4180_0000; //16
        O_DataIn = 32'h0000_0000; //0
        //End of Block3

    end

    always #1 clk = ~clk;
    
endmodule
