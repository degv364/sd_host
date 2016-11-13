////////////////////////////////////////////////////////
// Module: dat_tb (Testbench)
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////
`include "../defines.v"
`include "dat_tester.v"
`include "dat_control.v"
`include "dat_phys.v"
`include "buffer_wrapper.v"

module dat_tb;


   wire HOST_clk;
   wire SD_clk;
   wire RST_L;   
  
   wire [`BLOCK_SZ_WIDTH-1:0] block_size;
   wire [`BLOCK_CNT_WIDTH-1:0] block_count;

   wire dat_tx_init;
   wire dat_rx_init;
   
   wire tx_fifo_full;
   wire tx_fifo_empty;
   wire rx_fifo_full;
   wire rx_fifo_empty;
   
   wire tf_finished;
   wire dat_write_flag;
   wire dat_read_flag;

   wire rx_fifo_read_en;
   wire tx_fifo_write_en;
  
   wire tx_fifo_read_en;
   wire rx_fifo_write_en;
   wire dat_phys_busy;
   wire sd_card_busy;
   
   wire [`FIFO_WIDTH-1:0] tx_fifo_dout;
   wire [`FIFO_WIDTH-1:0] rx_fifo_din;
   wire [`FIFO_WIDTH-1:0] tx_fifo_din;
   wire [`FIFO_WIDTH-1:0] rx_fifo_dout;
   
   wire [3:0] 		  DAT_dout;
   wire [3:0] 		  DAT_din;
   
   DAT_tester dat_tester0 (.host_clk(HOST_clk),
			   .sd_clk(SD_clk),
			   .rst_L(RST_L),
			   .tx_data_init(dat_tx_init),
			   .rx_data_init(dat_rx_init),
			   .DAT_din(DAT_din),
			   .block_sz(block_size),
			   .block_cnt(block_count),
			   .rx_buf_rd_host(rx_fifo_read_en),
			   .tx_buf_wr_host(tx_fifo_write_en),
			   .tx_buf_din_out(tx_fifo_din)
			   );  

   DAT_control dat_control0 (.host_clk(HOST_clk),
			     .rst_L(RST_L),
			     .tx_data_init(dat_tx_init),
			     .rx_data_init(dat_rx_init),
			     .tx_buf_empty(tx_fifo_empty),
			     .rx_buf_full(rx_fifo_full),
			     .tf_finished(tf_finished),
			     .dat_phys_busy(dat_phys_busy),
			     .dat_wr_flag(dat_write_flag),
			     .dat_rd_flag(dat_read_flag)
			     );

   DAT_phys dat_phys0 (.sd_clk(SD_clk),
		       .rst_L(RST_L),
		       .tx_buf_dout_in(tx_fifo_dout),
		       .DAT_din(DAT_din),
		       .block_sz(block_size),
		       .block_cnt(block_count),
		       .write_flag(dat_write_flag),
		       .read_flag(dat_read_flag),
		       .tx_buf_rd_enb(tx_fifo_read_en),
		       .rx_buf_wr_enb(rx_fifo_write_en),
		       .rx_buf_din_out(rx_fifo_din),
		       .DAT_dout(DAT_dout),
		       .dat_phys_busy(dat_phys_busy),
		       .tf_finished(tf_finished),
		       .sdc_busy_L(sd_card_busy)
		       );

   buffer_wrapper rx_tx_fifo0 (.host_clk(HOST_clk),
			       .sd_clk(SD_clk),
			       .rst_L(RST_L),
			       .rx_buf_rd_host(rx_fifo_read_en),
			       .tx_buf_wr_host(tx_fifo_write_en),
			       .rx_buf_wr_dat(rx_fifo_write_en),
			       .tx_buf_rd_dat(tx_fifo_read_en),
			       .rx_buf_din(rx_fifo_din), //DAT
			       .rx_buf_dout(rx_fifo_dout), //DMA
			       .tx_buf_din(tx_fifo_din), //DMA
			       .tx_buf_dout(tx_fifo_dout), //DAT
			       .tx_buf_empty(tx_fifo_empty),
			       .tx_buf_full(tx_fifo_full),
			       .rx_buf_empty(rx_fifo_empty),
			       .rx_buf_full(rx_fifo_full)
			       );
   
   initial begin
      $dumpfile("dat_test.vcd");
      $dumpvars(0,dat_tb);
      #(500) $finish;
   end

   initial begin 
      $monitor("t=%t", $time); 
   end

   
endmodule
