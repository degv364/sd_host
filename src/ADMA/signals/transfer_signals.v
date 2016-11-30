////////////////////////////////////////////////////////
// Module: transfer_signals
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////


//Module for transfer signals

module transfer_signal(output start,
		       output 	     direction,
		       output 	     CLK,
		       output [15:0] length,
		       output [63:0] address_init);

   reg	     start=0;
   reg	     direction=1;//ram to fifo
   reg [15:0] length;
   reg [63:0] address_init;
   reg 	      CLK=1;
   

   initial begin
      $dumpfile ("test_transfer.vcd");
      $dumpvars (0, test_transfer);
      # 0 length = 6;
      # 0 address_init=0;
      
      # 2 start = 1;
      # 1 start = 0;
      # 15 address_init=12;
      
      # 0 direction=0;
      # 0 length=5;
      # 8 start=1;
      # 1 start=0;
      
      
      
      # 28 $finish;
   end // initial begin

   always #1 CLK=!CLK;
   

endmodule // transfer_signal       
