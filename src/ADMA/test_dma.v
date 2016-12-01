////////////////////////////////////////////////////////
// Module: test_dma
// Author: Daniel Garcia Vaglio
// Project: SD Host Controller
////////////////////////////////////////////////////////


//testbench para DMA
`include "modules/dma.v"
`include "modules/ram.v"
`include "modules/simple_fifo.v"
`include "signals/dma_signals.v"


module test_dma;

   wire RESET;
   wire CLK;

   wire [31:0] data_ram_to_dma;
   wire [31:0] data_dma_to_ram;
   wire [31:0] data_fifo_to_dma;
   wire [31:0] data_dma_to_fifo;
   
   wire        fifo_full;
   wire        fifo_empty;
   wire        start_transfer_flag;
   wire [63:0] ram_address;
   wire        ram_write;
   wire        ram_read;
   wire        fifo_read;
   wire        fifo_write;


   wire [15:0] adma_address_register_0;
   wire [15:0] adma_address_register_1;
   wire [15:0] adma_address_register_2;
   wire [15:0] adma_address_register_3;
   wire [15:0] command_register;
   wire [15:0] block_gap_control_register;
   wire [15:0] block_size_register;
   wire [15:0] block_count_register;
   wire [15:0] transfer_mode_register_in;

   wire        enable_write;
   wire [15:0] error_adma_register;

   wire        not_reset;
   assign not_reset=~RESET;
   
   wire 	       dat_full;
   wire 	       dat_empty;
   reg 	       dat_read=0;
   reg 	       dat_write=0;
   
   wire [31:0] dat_data_in;
   reg [31:0] dat_data_out=0;
   
   

   dma dma(
	   .RESET(RESET),
	   .CLK(CLK),
	   .adma_address_register_0(adma_address_register_0),
	   .adma_address_register_1(adma_address_register_1),
	   .adma_address_register_2(adma_address_register_2),
	   .adma_address_register_3(adma_address_register_3),
	   .command_register(command_register),
	   .block_gap_control_register(block_gap_control_register),
	   .block_size_register(block_size_register),
	   .block_count_register(block_count_register),
	   .transfer_mode_register_in(transfer_mode_register_in),
	   .data_from_ram(data_ram_to_dma),
	   .data_from_fifo(data_fifo_to_dma),
	   .fifo_full(fifo_full),
	   .fifo_empty(fifo_empty),
	   .error_adma_register(error_adma_register),
	   .data_to_ram(data_dma_to_ram),
	   .data_to_fifo(data_dma_to_fifo),
	   .start_transfer(start_transfer_flag),
	   .ram_address(ram_address),
	   .ram_write(ram_write),
	   .ram_read(ram_read),
	   .fifo_read(fifo_read),
	   .fifo_write(fifo_write),
	   .enable_write(enable_write)
	   );

   buffer_wrapper buffer_wrapper(.host_clk(CLK),
				 .sd_clk(CLK),
				 .rst_L(not_reset),
				 .rx_buf_rd_host(fifo_read),//dma
				 .tx_buf_wr_host(fifo_write),//dma
				 .rx_buf_wr_dat(dat_write),//dat
				 .tx_buf_rd_dat(dat_read),//dat
				 .rx_buf_din(dat_data_out),//dat
				 .tx_buf_din(data_dma_to_fifo),//dma
				 .rx_buf_dout(data_fifo_to_dma),//dma
				 .tx_buf_dout(data_dat_in),//dat
				 .tx_buf_empty(dat_empty),//dat
				 .tx_buf_full(fifo_full),//dma
				 .rx_buf_empty(fifo_empty),//dma
				 .rx_buf_full(dat_full)//dat
				 );

   dma_signal dma_signal(.RESET(RESET),
			 .CLK(CLK),
			 .adma_address_register_0(adma_address_register_0),
			 .adma_address_register_1(adma_address_register_1),
			 .adma_address_register_2(adma_address_register_2),
			 .adma_address_register_3(adma_address_register_3),
			 .command_register(command_register),
			 .block_gap_control_register(block_gap_control_register),
			 .block_size_register(block_size_register),
			 .block_count_register(block_count_register),
			 .transfer_mode_register_in(transfer_mode_register_in)
			 );

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

   
