////////////////////////////////////////////////////////
// Module: test_ram.v
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////

`define SD_HOST_COMPLETE

`include "ADMA/modules/ram.v"
`include "ADMA/signals/ram_signals.v"
`include "defines.v"

module test_ram;
   wire CLK, write, read;
   wire [31:0] data;
   wire [31:0] data_1;
   
   wire [63:0] address;
   
   ram ram(.address(address), 
	   .data_in(data), 
	   .write(write), 
	   .data_out(data_1), 
	   .read(read), 
	   .CLK(CLK));

   ram_signal ram_signal(.address(address), 
			 .write(write), 
			 .read(read), 
			 .data_out(data), 
			 .CLK(CLK));
   
   
endmodule // test

		
   
