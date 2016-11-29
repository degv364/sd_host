////////////////////////////////////////////////////////
// Module: test_state_machine.v
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////


//testbench para DMA
`include "modules/state_machine.v"
`include "modules/ram.v"
`include "modules/simple_fifo.v"
`include "signals/dma_signals.v"


module test_dma;

   //wire [96:0] address_descriptor;
   wire RESET;
   wire STOP;
   wire CLK;

   wire [31:0] data_ram_to_dma;
   wire [31:0] data_dma_to_ram;
   wire [31:0] data_fifo_to_dma;
   wire [31:0] data_dma_to_fifo;
   
   wire        fifo_full;
   wire        fifo_empty;
   wire        command_reg_write;
   wire        command_reg_continue;
   wire        direction;
   wire        start_transfer_flag;
   wire [63:0] ram_address;
   wire        ram_write;
   wire        ram_read;
   wire        fifo_read;
   wire        fifo_write;
   wire [63:0] starting_address;
   
   
   

   state_machine dma(.starting_address(starting_address),
		     .RESET(RESET),
		     .STOP(STOP),
		     .CLK(CLK),
		     .data_from_ram(data_ram_to_dma),
		     .data_from_fifo(data_fifo_to_dma),
		     .fifo_full(fifo_full),
		     .fifo_empty(fifo_empty),
		     .command_reg_write(command_reg_write),
		     .command_reg_continue(command_reg_continue),
		     .direction(direction),
		     .data_to_ram(data_dma_to_ram),
		     .data_to_fifo(data_dma_to_fifo),
		     .start_transfer(start_transfer_flag),
		     .ram_address(ram_address),
		     .ram_write(ram_write),
		     .ram_read(ram_read),
		     .fifo_read(fifo_read),
		     .fifo_write(fifo_write));

   dma_signal dma_signal(.starting_address(starting_address),
			 .RESET(RESET),
			 .STOP(STOP),
			 .CLK(CLK),
			 .command_reg_write(command_reg_write),
			 .command_reg_continue(command_reg_continue),
			 .direction(direction));

   ram ram(.address(ram_address), 
	   .write(ram_write), 
	   .read(ram_read), 
	   .data_in(data_dma_to_ram), 
	   .data_out(data_ram_to_dma), 
	   .CLK(CLK));

   simple_fifo simple_fifo(.data_in(data_dma_to_fifo), 
			   .data_out(data_fifo_to_dma), 
			   .write(fifo_write), 
			   .read(fifo_read), 
			   .full(fifo_full), 
			   .empty(fifo_empty), 
			   .CLK(CLK));

endmodule // test_dma

   
