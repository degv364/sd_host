////////////////////////////////////////////////////////
// Module: buffer_wrapper
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../defines.v"
`include "generic_fifo_dc_gray.v"

`timescale 1ns/10ps

module buffer_wrapper(
		      input 		       host_clk,
		      input 		       sd_clk,
		      input 		       rst_L,
		      input 		       rx_buf_rd_host,
		      input 		       tx_buf_wr_host,
		      input 		       rx_buf_wr_dat,
		      input 		       tx_buf_rd_dat,
		      input [`FIFO_WIDTH-1:0]  rx_buf_din,
		      input [`FIFO_WIDTH-1:0]  tx_buf_din,
		      output [`FIFO_WIDTH-1:0] rx_buf_dout,
		      output [`FIFO_WIDTH-1:0] tx_buf_dout,
		      output 		       tx_buf_empty,
		      output 		       tx_buf_full,
		      output 		       rx_buf_empty,
		      output 		       rx_buf_full
		      );

   generic_fifo_dc_gray #(.aw(4),.dw(`FIFO_WIDTH)) 
   tx_buffer (	
		.rd_clk(sd_clk),
		.wr_clk(host_clk),
		.rst(rst_L),
		.clr(1'b0),
		.din(tx_buf_din), //DMA
		.dout(tx_buf_dout), //DAT
		.we(tx_buf_wr_host), //DMA
		.re(tx_buf_rd_dat), //DAT
		.full(tx_buf_full),
		.empty(tx_buf_empty),
		.rd_level(),
		.wr_level()
		);

   generic_fifo_dc_gray #(.aw(4),.dw(`FIFO_WIDTH)) 
   rx_buffer (	
		.rd_clk(host_clk),
		.wr_clk(sd_clk),
		.rst(rst_L),
		.clr(1'b0),
		.din(rx_buf_din), //DAT
		.dout(rx_buf_dout), //DMA
		.we(rx_buf_wr_dat), //DAT
		.re(rx_buf_rd_host), //DMA
		.full(rx_buf_full),
		.empty(rx_buf_empty),
		.rd_level(),
		.wr_level()
		);
endmodule
