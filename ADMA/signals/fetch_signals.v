
module fetch_signal(output CLK,
		    output start,
		    output [63:0] address);

   reg 			   CLK=1;
   reg 			   start;
   reg [63:0] 		   address;
   
   always #1 CLK=!CLK;

   initial begin
      $dumpfile ("test_fetch.vcd");
      $dumpvars (0, test_fetch);

      # 2 start = 1;
      # 0 address =64;

      # 30 $finish;
   end
endmodule // fetch_signal

   
