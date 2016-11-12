//Module for transfer signals

module transfer_signal(output start,
		       output 	     direction,
		       output 	     CLK,
		       output [15:0] length,
		       output [63:0] address_init);

   reg	     start;
   reg	     direction;
   reg [15:0] length;
   reg [63:0] address_init;

   initial begin
      $dumpfile ("test_transfer.vcd");
      $dumpvars (0, test_transfer);
      # 10 address_init=0;
      # 10 $finish;
   end

endmodule // transfer_signal

       
