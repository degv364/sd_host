////////////////////////////////////////////////////////
// Module: dat_tester (Stimulus)
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../defines.v"

`timescale 1ns/10ps

module DAT_tester(
		  output 			host_clk,
		  output 			sd_clk,
		  output 			rst_L,
		  output 			tx_data_init,
		  output 			rx_data_init,
		  output [3:0]			DAT_din,
		  output [`BLOCK_SZ_WIDTH-1:0] 	block_sz,
		  output [`BLOCK_CNT_WIDTH-1:0] block_cnt,
		  output 			rx_buf_rd_host,
		  output 			tx_buf_wr_host,
		  output [`FIFO_WIDTH-1:0] 	tx_buf_din_out
		  );

   reg host_clk = 1'b1;
   reg sd_clk = 1'b1;
   reg rst_L = 1'b0;

   reg sdc_busy_L = 1'b0;
   
   assign DAT_din[0] = !sdc_busy_L;
   
   initial begin
      #(2) rst_L = 1'b1;
   end

   always #(1) host_clk  = !host_clk;
   always #(4) sd_clk = !sd_clk;
   

endmodule
