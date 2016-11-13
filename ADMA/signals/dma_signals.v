//modulo para las senales de prueba para el dma

module dma_signal(output [96:0] address_descriptor,
		  output 	RESET,
		  output 	STOP,
		  output 	CLK,
		  output 	command_reg_write,
		  output 	command_reg_continue,
		  output 	direction,
		  output [63:0] starting_address);
   
   reg [96:0]	 address_descriptor=0; 
   reg 		 RESET=0;
   reg 		 STOP=0;
   reg 		 command_reg_write=1;
   reg 		 command_reg_continue=1;
   reg 		 direction=1;
   
   reg 		 CLK=1;
   always #1 CLK = !CLK;
      
   initial begin
      $dumpfile ("test_dma.vcd");
      $dumpvars (0, test_dma);
      //conteo de 1 en 1

      # 5 $finish;
   end

   

endmodule // signal_32

