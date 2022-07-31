module MAC
        #(parameter DataInWidth = 8 ,
          parameter DataOutWidth = 16 )
        ( clk,NOPIn,NOPOut,W_Data,I_Data,O_Data,DataOut);
        input clk,O_NOPIn;
        input [DataInWidth-1:0] W_Data,I_Data,O_Data;
        
        output NOPOut;
        output [DataOutWidth-1:0] DataOut;



        assign DataOut = W_Data * I_Data + O_Data; 

endmodule