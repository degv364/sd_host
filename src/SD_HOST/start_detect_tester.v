`include "defines.v"


module start_detect_tester(output clk,
			   output reset,
			   output [5:0] command_register);

   reg 					clk=1;
   reg 					reset;
   reg [5:0] 				command_register;

   always #1 clk=~clk;

   initial begin
      $dumpfile ("start_detect_tb.vcd");
      $dumpvars (0, start_detect_tb);
      # 0 command_register=0;
      
      # 2 reset=1;
      # 2 reset=0;

      # 4 command_register=4;
      # 3 command_register=7;
      # 5 command_register=1;

      # 2 reset=1;
      # 2 command_register=2;
      # 4 $finish;
   end // initial begin
   
      

endmodule // start_detect_tester
