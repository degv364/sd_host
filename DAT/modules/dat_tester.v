////////////////////////////////////////////////////////
// Module: dat_tester (Stimulus)
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../defines.v"

`timescale 1ns/10ps

module DAT_tester(
		  input 			    tx_buf_full,
		  input 			    rx_buf_empty,
		  output reg 			    host_clk,
		  output reg 			    sd_clk,
		  output reg 			    rst_L,
		  output reg 			    tx_data_init,
		  output reg 			    rx_data_init,
		  output reg [3:0] 		    DAT_din,
		  output reg [`BLOCK_SZ_WIDTH-1:0]  block_sz,
		  output reg [`BLOCK_CNT_WIDTH-1:0] block_cnt,
		  output reg 			    rx_buf_rd_host,
		  output reg 			    tx_buf_wr_host,
		  output reg [`FIFO_WIDTH-1:0] 	    tx_buf_din_out
		  );

   reg sdc_busy_L  = 1'b0;
   
   always @(*) DAT_din[0] <= ~sdc_busy_L;

   integer i;
   
   initial begin
      host_clk 	      = 1'b1;
      sd_clk 	      = 1'b1;
      rst_L 	      = 1'b1;
      tx_data_init    = 1'b0;
      rx_data_init    = 1'b0;
      rx_buf_rd_host  = 1'b0;
      tx_buf_wr_host  = 1'b0;
      block_cnt       = 10;
      block_sz 	      = 64;
      DAT_din[3:1]    = 3'b000;
      tx_buf_din_out  = 0;
      
      #2 rst_L 	      = 1'b0;
      #2 rst_L 	      = 1'b1;

      #2 for (i=0; i<=15; i=i+1) begin //Fill 16 32-bit blocks into Tx Buffer
	 #2 tx_buf_din_out  = `FIFO_WIDTH'h1234ABCD+i;
	 tx_buf_wr_host = 1; 
      end
      #2 tx_buf_wr_host  = 0;
      
      #2 tx_data_init 	 = 1;
      rx_data_init 	 = 0;
      
      
   end

   always #(1) host_clk  = !host_clk;
   always #(4) sd_clk = !sd_clk;

   

endmodule
