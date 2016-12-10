////////////////////////////////////////////////////////
// Module: dma_signals 
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////
`include "defines.v"

//modulo para las senales de prueba para el dma

module dma_signal(output 	RESET,
		  output 	CLK,
		  output [15:0] adma_address_register_0,
		  output [15:0] adma_address_register_1,
		  output [15:0] adma_address_register_2,
		  output [15:0] adma_address_register_3,
		  output [15:0] command_register,
		  output [15:0] block_gap_control_register,
		  output [15:0] block_size_register,
		  output [15:0] block_count_register,
		  output [15:0] transfer_mode_register_in
		  );
   
   
   reg 		 RESET=1;
   reg [15:0] adma_address_register_0=0;
   reg [15:0] adma_address_register_1=0;
   reg [15:0] adma_address_register_2=0;
   reg [15:0] adma_address_register_3=0;
   reg [15:0] command_register=0;
   reg [15:0] block_gap_control_register=0;
   reg [15:0] block_size_register=0;
   reg [15:0] block_count_register=0;
   reg [15:0] transfer_mode_register_in=0;
   
   
   reg 		 CLK=1;
   always #1 CLK = !CLK;
      
   initial begin
      $dumpfile ("test_dma.vcd");
      $dumpvars (0, test_dma);
      //------STOP=0---------------
      # 0 transfer_mode_register_in[0]=1;
      # 0 block_gap_control_register[0]=0;
      //------command_reg_continue=0
      # 0 block_gap_control_register[1]=0;
      //------direction=1----------
      # 0 transfer_mode_register_in[4]=0;
      # 2 RESET =0;
      //------starting_address=0----
      # 0 adma_address_register_0=0;
      # 0 adma_address_register_1=0;
      # 0 adma_address_register_2=0;
      # 0 adma_address_register_3=0;
      
      
      //------command_reg_write=1--- this will trigger dma
      # 2 command_register[7:6]=2;
      

      //------direction=0----------
      # 30 transfer_mode_register_in[4]=1;

      //-----STOP=1----------------
      # 60 block_gap_control_register[0]=1;
      
      # 500 $finish;
   end

endmodule // signal_32

