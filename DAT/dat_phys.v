////////////////////////////////////////////////////////
// Module: data_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps

module dat_phys(input sd_clk,
		 input 			  rst_L,
		 input [`FIFO_WIDTH-1:0]  tx_buf_din,
		 input [3:0] 		  DAT_din,
		 input 			  block_sz,
		 input 			  block_cnt,
		 input 			  write_flag,
		 input 			  read_flag,
		 output 		  tx_buf_rd_enb,
		 output 		  rx_buf_wr_enb,
		 output [`FIFO_WIDTH-1:0] rx_buf_dout,
		 output [3:0] 		  DAT_dout,
		 output 		  data_phys_busy,
		 output 		  sdc_busy
		 );
   //Regs
   reg 			  tx_buf_rd_enb;
   reg 			  rx_buf_wr_enb;
   reg [`FIFO_WIDTH-1:0]  rx_buf_dout;
   reg [3:0] 		  DAT_dout;

   reg [(`FIFO_WIDTH/4)-1:0] sel_offset;

   
   parameter SIZE = 4;
   reg [SIZE-1:0] 	 state;
   reg [SIZE-1:0] 	 next_state;

   //FSM States
   parameter IDLE = 4'b0001;

   

   //Update state 
   always @ (posedge sd_clk or !rst_L) begin
      if(!rst_L) begin
	 state <= IDLE;	
	 tx_buf_rd_enb <= 0;
	 rx_buf_wr_enb <= 0;
	 rx_buf_dout <= 0;	
	 DAT_dout <= 0;
      end	
      else
	 state <= next_state;
   end

   //Combinational logic (next state, outputs)
   always @(*) begin
      //Default output values
      tx_buf_rd_enb <= 0;
      rx_buf_wr_enb <= 0;
      rx_buf_dout <= 0;	
      DAT_dout <= 0;

   end
   
endmodule
