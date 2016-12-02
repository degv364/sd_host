`include "defines.v"
`include "start_detect.v"
`include "start_detect_tester.v"


module start_detect_tb;
   wire [5:0] command_register;
   

   start_detect start_detect(.clk(clk),
			     .reset(reset),
			     .command_register(command_register),
			     .start_flag(start_flag)
			     );

   start_detect_tester start_detect_tester(.clk(clk),
		       .reset(reset),
		       .command_register(command_register)
		       );
   
   


endmodule // start_detect_tb

