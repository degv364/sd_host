//modulo para las senales de prueba para el dma

module dma_signal(output 	RESET,
		  output 	STOP,
		  output 	CLK,
		  output 	command_reg_write,
		  output 	command_reg_continue,
		  output 	direction,
		  output [63:0] starting_address);
   
   
   reg 		 RESET=1;
   reg 		 STOP=0;
   reg 		 command_reg_write=0;
   reg 		 command_reg_continue=0;
   reg 		 direction=1;
   reg [63:0] 	 starting_address;
   
   
   reg 		 CLK=1;
   always #1 CLK = !CLK;
      
   initial begin
      $dumpfile ("test_dma.vcd");
      $dumpvars (0, test_dma);
      # 2 RESET =0;
      # 0 starting_address=0;
      
      # 2 command_reg_write=1; //this will trigger dma
      # 40 direction=0;
      # 60 STOP=1;
      
      # 5 $finish;
   end

endmodule // signal_32

