`timescale 100ns/100ns
module MAC_tb 
    #(  parameter DataInWidth = 8,
        parameter DataOutWidth = 16)
        ();
    reg clk, reset, NOPIn;
    reg [DataInWidth-1:0] W_Data, I_Data, O_Data;
        
    wire NOPOut;
    wire [DataInWidth-1:0] DataOut;

    MAC_Pipeline #(.DataInWidth(8), .DataOutWidth(16)) udt( 
            .clk(clk), .reset(reset), .NOPIn(NOPIn), .NOPOut(NOPOut), 
            .W_Data(W_Data), .I_Data(I_Data), .O_Data(O_Data), .DataOut(DataOut));

    initial begin
        clk = 1;
        reset = 1;
        NOPIn = 1;
        W_Data = 0;
        I_Data = 0;
        O_Data = 0;
        #2
        reset = 0;
        NOPIn = 0;
        W_Data = 10;
        I_Data = 20;
        O_Data = 30;
        #2
        W_Data = 5;
        I_Data = 20;
        O_Data = 30;
        #2
        W_Data = 5;
        I_Data = 10;
        O_Data = 10;
        #2
        NOPIn = 1;
        W_Data = 5;
        I_Data = 10;
        O_Data = 10;
        #2
        NOPIn = 0;
        W_Data = 10;
        I_Data = 2;
        O_Data = 9;                

    end
    
    always #1 clk = ~clk;
    
    always #2 begin
        $monitor("%0d ns, NOPIn: %b, W_Data: %d, I_Data: %d, O_Data: %d, DataOut: %d, NOPOut: %b", 
        $stime, NOPIn, W_Data, I_Data, O_Data, DataOut, NOPOut);
    end

endmodule
