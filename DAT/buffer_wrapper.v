////////////////////////////////////////////////////////
// Module: buffer_wrapper
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps


module buffer_wrapper(input host_clk,
		      input  sd_clk,
		      input  rst_L,
		      input  rx_rd_host,
		      input  tx_wr_host,
		      input  rx_wr_dat,
		      input  tx_rd_dat,
		      input  rx_buf_din,
		      input  tx_buf_din,
		      output rx_buf_dout,
		      output tx_buf_dout,
		      output tx_buf_empty,
		      output tx_buf_full,
		      output rx_buf_empty,
		      output rx_buf_full,
		      );

   generic_fifo_dc_gray #(.aw(4),.dw(32)) 
   tx_buffer (	
		.rd_clk(sd_clk),
		.wr_clk(host_clk),
		.rst(!rst_L),
		.clr(0)
		.din(tx_buf_din), //DMA
		.dout(tx_buf_dout), //DAT
		.we(tx_wr_host), //DMA
		.re(tx_rd_dat), //DAT
		.full(tx_buf_full),
		.empty(tx_buf_empty),
		.rd_level(),
		.wr_level()
		);

   generic_fifo_dc_gray #(.aw(4),.dw(32)) 
   tx_buffer (	
		.rd_clk(sd_clk),
		.wr_clk(host_clk),
		.rst(!rst_L),
		.clr(0)
		.din(rx_buf_din), //DAT
		.dout(rx_buf_dout), //DMA
		.we(rx_wr_dat), //DAT
		.re(rx_rd_host), //DMA
		.full(rx_buf_full),
		.empty(rx_buf_empty),
		.rd_level(),
		.wr_level()
		);

endmodule
