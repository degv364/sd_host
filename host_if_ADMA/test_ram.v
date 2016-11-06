`include "ram.v"
`include "ram_signals.v"


module test;
   wire CLK, write;
   wire [31:0] data;
   wire [31:0] data_1;
   
   wire [63:0] address;
   
   ram ram(.address(address), .data_in(data), .write(write), .data_out(data_1));

   ram_signal ram_signal(.address(address), .write(write), .data_out(data), .CLK(CLK));
   
   
endmodule // test

		
   
