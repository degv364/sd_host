////////////////////////////////////////////////////////
// Module: DAT
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "DAT_control.v"
`include "DAT_phys.v"
`include "../../defines.v"

`timescale 1ns/10ps

module DAT(
	   input 			host_clk,
	   input 			sd_clk,
	   input 			rst_L,
	   input 			tx_data_init,
	   input 			rx_data_init,
	   input 			tx_buf_empty,
	   input 			rx_buf_full,
	   input [`FIFO_WIDTH-1:0] 	tx_buf_dout_in,
	   input [3:0] 			DAT_din,
	   input [`BLOCK_SZ_WIDTH-1:0] 	block_sz,
	   input [`BLOCK_CNT_WIDTH-1:0] block_cnt,
	   output 			tx_buf_rd_enb,
	   output 			rx_buf_wr_enb,
	   output [`FIFO_WIDTH-1:0] 	rx_buf_din_out,
	   output [3:0] 		DAT_dout,
	   output 			DAT_dout_oe,
	   output 			sdc_busy_L
	   );

   //Internal DAT flags
   wire 	 dat_phys_busy_flag;
   wire 	 dat_write_flag;
   wire 	 dat_read_flag;
   wire 	 multiple_blk_flag;
   wire 	 tf_finished_flag;
   

   DAT_control dat_control0 (.host_clk(host_clk),
			     .rst_L(rst_L),
			     .tx_data_init(tx_data_init),
			     .rx_data_init(rx_data_init),
			     .tx_buf_empty(tx_buf_empty),
			     .rx_buf_full(rx_buf_full),
			     .tf_finished(tf_finished_flag),
			     .dat_phys_busy(dat_phys_busy_flag),
			     .dat_wr_flag(dat_write_flag),
			     .dat_rd_flag(dat_read_flag),
			     .multiple(multiple_blk_flag)
			     );

   DAT_phys dat_phys0 (.sd_clk(sd_clk),
		       .rst_L(rst_L),
		       .tx_buf_dout_in(tx_buf_dout_in),
		       .DAT_din(DAT_din),
		       .block_sz(block_sz),
		       .block_cnt(block_cnt),
		       .write_flag(dat_write_flag),
		       .read_flag(dat_read_flag),
		       .multiple(multiple_blk_flag),
		       .tx_buf_rd_enb(tx_buf_rd_enb),
		       .rx_buf_wr_enb(rx_buf_wr_enb),
		       .rx_buf_din_out(rx_buf_din_out),
		       .DAT_dout(DAT_dout),
		       .DAT_dout_oe(DAT_dout_oe),
		       .dat_phys_busy(dat_phys_busy_flag),
		       .tf_finished(tf_finished_flag),
		       .sdc_busy_L(sdc_busy_L)
		       );
endmodule

