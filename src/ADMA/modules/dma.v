////////////////////////////////////////////////////////
// Module: dma
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"
`include "ADMA/modules/state_machine.v"


//TODO: PASAR esto a separacion de logica combinacional y flipflops

//FIXME: register -> Block size
//FIXME: maybe register-> Block count register
//                        verify length=block size*block count

//FIXME: register -> error status


module dma(	   
	   input 	 RESET, //driver
	   input 	 CLK, //internal
	   input [15:0]  adma_address_register_0, //reg
	   input [15:0]  adma_address_register_1, //reg
	   input [15:0]  adma_address_register_2, //reg
	   input [15:0]  adma_address_register_3, //reg
	   input [15:0]  command_register, //reg
	   input [15:0]  block_gap_control_register,//reg
	   input [15:0]  block_size_register, //reg
	   input [15:0]  block_count_register, //reg
	   input [15:0]  transfer_mode_register_in,//reg
	   input [31:0]  data_from_ram, //ram
	   input [31:0]  data_from_fifo, //fifo
	   input 	 fifo_full, //fifo
 	   input 	 fifo_empty, //fifo
	   output [15:0] error_adma_register,//reg
	   output [31:0] data_to_ram, //ram
	   output [31:0] data_to_fifo, //fifo
	   output [63:0] ram_address, //ram
	   output 	 ram_write, //ram
	   output 	 ram_read, //ram
	   output 	 fifo_write, //fifo
	   output 	 fifo_read, //fifo
	   output 	 start_transfer, //internal
	   output 	 enable_write    //reg
	   );

   wire [63:0] 		 starting_address;
   wire 		 stop;
   
   wire 		 command_reg_write;
   wire 		 command_reg_continue;
   wire 		 direction;
   reg [15:0] 		 error_adma_register;
   reg 			 enable_write;
   

   assign starting_address[15:0]=adma_address_register_0;
   assign starting_address[31:16]=adma_address_register_1;
   assign starting_address[47:32]=adma_address_register_2;
   assign starting_address[63:48]=adma_address_register_3;
   
   assign command_reg_continue=block_gap_control_register[1];

   assign direction=~transfer_mode_register_in[4]; 
   assign command_reg_write=command_register[7] & ~command_register[6];
   assign stop=block_gap_control_register[0] | ~transfer_mode_register_in[0];
   
   
   //FIXME: LOGIC to generate errors
   //FIXME: logic to change state machine inputs according to block count and block size
   
   
   state_machine state_machine(.starting_address(starting_address),
			       .RESET(RESET),
			       .STOP(stop),
			       .CLK(CLK),
			       .data_from_ram(data_from_ram),
			       .data_from_fifo(data_from_fifo),
			       .fifo_full(fifo_full),
			       .fifo_empty(fifo_empty),
			       .command_reg_write(command_reg_write),
			       .command_reg_continue(command_reg_continue),
			       .direction(direction),
			       .data_to_ram(data_to_ram),
			       .data_to_fifo(data_to_fifo),
			       .ram_address(ram_address),
			       .ram_write(ram_write),
			       .ram_read(ram_read),
			       .fifo_write(fifo_write),
			       .fifo_read(fifo_read),
			       .start_transfer(start_transfer)
			       );
   


endmodule // dma


	 
     
