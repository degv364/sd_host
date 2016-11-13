////////////////////////////////////////////////////////
// Module: data_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "defines.v"

`timescale 1ns/10ps


//TODO: Single/multiple block selection
//TODO: Check for FIFOs full/empty cases

module dat_phys(input sd_clk,
		 input 			      rst_L,
		 input [`FIFO_WIDTH-1:0]      tx_buf_din,
		 input [3:0] 		      DAT_din,
		 input [`BLOCK_SZ_WIDTH-1:0]  block_sz,
		 input [`BLOCK_CNT_WIDTH-1:0] block_cnt,
		 input 			      write_flag,
		 input 			      read_flag,
		 output 		      tx_buf_rd_enb,
		 output 		      rx_buf_wr_enb,
		 output [`FIFO_WIDTH-1:0]     rx_buf_dout,
		 output [3:0] 		      DAT_dout,
		 output 		      data_phys_busy,
		 output 		      tf_finished,
		 output 		      sdc_busy_L
		);
   //Regs
   reg 			  tx_buf_rd_enb;
   reg 			  rx_buf_wr_enb;
   reg [`FIFO_WIDTH-1:0]  rx_buf_dout;
   reg [3:0] 		  DAT_dout;
   
   reg [(`FIFO_WIDTH/4)-1:0] sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0]  curr_block_sz; 
   reg [`FIFO_WIDTH-1:0]      curr_tx_buf_din;
   reg 			      new_block; 

			      
   parameter SIZE = 4;
   reg [SIZE-1:0] 	 state;
   reg [SIZE-1:0] 	 next_state;

   //FSM States
   parameter IDLE  = 4'b0001;
   parameter WRITE  = 4'b0010;
   parameter READ = 4'b0100;

   
   //Update state 
   always @ (posedge sd_clk or !rst_L) begin
      if(!rst_L) begin
	 state 		<= IDLE;	
	 tx_buf_rd_enb 	<= 0;
	 rx_buf_wr_enb 	<= 0;
	 rx_buf_dout 	<= 0;	
	 DAT_dout 	<= 0;
	 curr_block_cnt <= 0;
	 curr_block_sz 	<= 0;
	 sel_offset 	<= 0;
	 new_block 	<= 0;
      end	
      else
	 state <= next_state;
   end

   assign sdc_busy_L = DAT_din[0];

   
   //Combinational logic (next state, outputs)
   always @(*) begin
      //Default output values
      tx_buf_rd_enb <= 0;
      rx_buf_wr_enb <= 0;
      rx_buf_dout   <= 0;	
      DAT_dout 	    <= 0;
      tf_finished   <= 0;
      
      case (state)
	 IDLE: begin
	    curr_block_cnt <= block_cnt;
	    curr_block_sz  <= block_sz;

	    if(!sdc_busy_L) begin //If card is busy keep IDLE state
	       next_state <= IDLE;
	    end
	    else begin
	       if(write_flag && !read_flag) begin
		  next_state    <= WRITE;
		  new_block     <= 1;
		  tx_buf_rd_enb <= 1; //Request data from Tx FIFO
		  sel_offset    <= 0;
	       end
	       else begin
		  if(read_flag && !write_flag) begin
		     next_state    <= READ;
		     rx_buf_wr_enb <= 1;
		  end
		  else begin
		     next_state <= IDLE;
    		  end
	       end
	    end
	 end
         
	 WRITE: begin
	    if(curr_block_cnt > 0) begin
	       
	       if(new_block && !sdc_busy_L) begin
		  new_block <= 1;
		  next_state <= WRITE; //If sd card is busy retry the write operation
	       end
	       else begin
		  new_block <= 0;
		  next_state <= WRITE;
		  
		  if(sel_offset == 0) begin //Get new data from Tx FIFO
		     curr_tx_buf_din <= tx_buf_din;
		  end
		  else begin
		     curr_tx_buf_din <= curr_tx_buf_din;
		  end

		  if(sel_offset < `FIFO_WIDTH/4) begin
		     DAT_dout  <= curr_tx_buf_din[(`FIFO_WIDTH-1-(sel_offset<<2))-:4];
		     
		     if(sel_offset < `FIFO_WIDTH/4-1) begin
			sel_offset <= sel_offset+1;
			curr_block_sz <= curr_block_sz-4;
		     end
		     else begin  //sel_offset == (`FIFO_WIDTH/4)-1)
			sel_offset    <= 0;
			tx_buf_rd_enb <= 1; //Prepare to request data from Tx FIFO
		     end
		  end
		  else begin //Default unexpected case
		     DAT_dout   <= DAT_dout;
		     sel_offset <= 0;     
		  end

		  if(curr_block_sz == 4) begin //Finished to send current block
		     new_block <= (curr_block_cnt-1 > 0) ? 1 : 0; //Need to tranfer more blocks
		     curr_block_cnt <= curr_block_cnt-1;
		  end
		  else begin
		     curr_block_cnt <= curr_block_cnt;
		  end
	       end
	    end 
	    else begin
	       next_state <= IDLE; //Return to IDLE if all the blocks were transfered
	       tf_finished <= 1;
	    end
	 end
	 
	 default:
      endcase

   end
   
endmodule
