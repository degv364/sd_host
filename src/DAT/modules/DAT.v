////////////////////////////////////////////////////////
// Module: DAT
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "DAT_control.v"
`include "DAT_phys.v"
`include "../../defines.v"

`timescale 1ns/10ps
/* 
Módulo de integración de los sub bloques de DAT_Control y DAT_phys, para encapsular la interacción
 de ciertas señales internas de comunicación entre estos
*/
module DAT(
	   input 			host_clk,
	   input 			sd_clk,
	   input 			rst_L,
	   input 			resp_recv,
	   input 			tx_buf_empty,
	   input 			rx_buf_full,
	   input [`FIFO_WIDTH-1:0] 	tx_buf_dout_in,
	   input [3:0] 			DAT_din,
	   input [`BLOCK_SZ_WIDTH-1:0] 	block_sz_reg,
	   input [`BLOCK_CNT_WIDTH-1:0] block_cnt_reg,
	   input 			multiple_blk_reg,
	   input 			tf_direction_reg,
	   output 			wr_tf_active_reg,
	   output 			rd_tf_active_reg,
	   output 			cmd_inhibit_dat_reg,
	   output [2:0]			PSR_wr_enb,
	   output 			tf_complete_reg,
	   output 			NISR_wr_enb,
	   output 			tx_buf_rd_enb,
	   output 			rx_buf_wr_enb,
	   output [`FIFO_WIDTH-1:0] 	rx_buf_din_out,
	   output [3:0] 		DAT_dout,
	   output 			DAT_dout_oe,
	   output 			sdc_busy_L
	   );

   //Banderas internas entre DAT_control y DAT_phys
   wire 	 dat_phys_busy_flag;
   wire 	 dat_write_flag;
   wire 	 dat_read_flag;
   wire 	 tf_finished_flag;
   

   DAT_control dat_control0 (.host_clk(host_clk),
			     .rst_L(rst_L),
			     .tf_direction_reg(tf_direction_reg),
			     .resp_recv(resp_recv),
			     .tx_buf_empty(tx_buf_empty),
			     .rx_buf_full(rx_buf_full),
			     .tf_finished(tf_finished_flag),
			     .dat_phys_busy(dat_phys_busy_flag),
			     .wr_tf_active_reg(wr_tf_active_reg),
			     .rd_tf_active_reg(rd_tf_active_reg),
			     .cmd_inhibit_dat_reg(cmd_inhibit_dat_reg),
			     .PSR_wr_enb(PSR_wr_enb),
			     .tf_complete_reg(tf_complete_reg),
			     .NISR_wr_enb(NISR_wr_enb),
			     .dat_wr_flag(dat_write_flag),
			     .dat_rd_flag(dat_read_flag)
			     );

   DAT_phys dat_phys0 (.sd_clk(sd_clk),
		       .rst_L(rst_L),
		       .tx_buf_dout_in(tx_buf_dout_in),
		       .DAT_din(DAT_din),
		       .block_sz(block_sz_reg),
		       .block_cnt(block_cnt_reg),
		       .write_flag(dat_write_flag),
		       .read_flag(dat_read_flag),
		       .multiple(multiple_blk_reg),
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
