
module fetch_signal(output CLK,
		    output start,
		    output [63:0] address);

   reg 			   CLK=1;
   reg 			   start=0;
   reg [63:0] 		   address;
   
   always #1 CLK=!CLK;

   initial begin
      $dumpfile ("test_fetch.vcd");
      $dumpvars (0, test_fetch);
      # 0 start = 0;
      
      # 2 start = 1;
      # 1 start = 0;
      
      # 0 address =64;

      # 30 $finish;
   end
endmodule // fetch_signal

   
