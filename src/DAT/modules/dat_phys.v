////////////////////////////////////////////////////////
// Module: data_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../../defines.v"

`timescale 1ns/10ps


//TODO: Single/multiple block selection
//TODO: Check for FIFOs full/empty cases
//TODO: Read transaction
//TODO?: DAT Control flags synchronization (Maybe req/ack and double FF)

module DAT_phys (
		 input 			      sd_clk,
		 input 			      rst_L,
		 input [`FIFO_WIDTH-1:0]      tx_buf_dout_in,
		 input [3:0] 		      DAT_din,
		 input [`BLOCK_SZ_WIDTH-1:0]  block_sz,
		 input [`BLOCK_CNT_WIDTH-1:0] block_cnt,
		 input 			      write_flag,
		 input 			      read_flag,
		 output 		      tx_buf_rd_enb,
		 output 		      rx_buf_wr_enb,
		 output [`FIFO_WIDTH-1:0]     rx_buf_din_out,
		 output [3:0] 		      DAT_dout,
		 output 		      DAT_dout_oe,
		 output 		      dat_phys_busy,
		 output 		      tf_finished,
		 output 		      sdc_busy_L
		 );

   /////// Parameters
   //FSM States
   parameter IDLE  = 4'b0001;
   parameter WRITE  = 4'b0010;
   parameter END_BLK_WRITE = 4'b0100;
   parameter READ = 4'b1000;
   
   //Other
   parameter SIZE  = 4;
   
   /////// Regs declaration
   //Asynchronic output regs
   reg 					      tx_buf_rd_enb;
   reg 					      rx_buf_wr_enb;
   reg [`FIFO_WIDTH-1:0] 		      rx_buf_din_out;
   reg [3:0] 				      DAT_dout;
   reg 					      DAT_dout_oe;
   reg 					      tf_finished;
   
   //Synchronic output next regs
   reg [3:0] 				      nxt_DAT_dout;
   reg 					      nxt_DAT_dout_oe;
   
   //Internal state related regs
   reg [SIZE-1:0] 			      state;
   reg [(`FIFO_WIDTH/4)-1:0] 		      sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] 		      curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0] 		      curr_block_sz;
   reg [`FIFO_WIDTH-1:0] 		      curr_tx_buf_dout_in;
   reg 					      new_block;
   reg 					      DAT_din_reg; //TODO: Check when implementing READ
   reg 					      write_flag_reg;
   reg 					      read_flag_reg;
   reg [1:0] 				      end_blk_write_cnt; //Counter for CRC sequence length

   
   //Next state/combinational logic output regs
   reg [SIZE-1:0] 			      nxt_state;
   reg [(`FIFO_WIDTH/4)-1:0] 		      nxt_sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] 		      nxt_curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0] 		      nxt_curr_block_sz;
   reg [`FIFO_WIDTH-1:0] 		      nxt_curr_tx_buf_dout_in;
   reg 					      nxt_new_block;
   reg [1:0] 				      nxt_end_blk_write_cnt;

   
   assign sdc_busy_L = !DAT_din[0];
   assign dat_phys_busy = (state != IDLE);
   
   //Update state logic
   always @ (posedge sd_clk or !rst_L) begin
      if(!rst_L) begin
	 
	 //Output reset values
	 tx_buf_rd_enb 	     <= 0;
	 rx_buf_wr_enb 	     <= 0;
	 rx_buf_din_out      <= 0;
	 tf_finished 	     <= 0;
	 DAT_dout 	     <= 0;
	 DAT_dout_oe 	     <= 0;

	 //State regs reset values
	 state 		     <= IDLE;
	 curr_block_cnt      <= 0;
	 curr_block_sz 	     <= 0;
	 sel_offset 	     <= 0;
	 curr_tx_buf_dout_in <= 0;
	 new_block 	     <= 0;
	 end_blk_write_cnt   <= 0;
	 
	 DAT_din_reg 	     <= 0;
	 write_flag_reg      <= 0;
	 read_flag_reg 	     <= 0;

      end	
      else begin
	 //Next state logic related update
	 state 		     <= nxt_state;
	 sel_offset 	     <= nxt_sel_offset;
	 curr_block_cnt      <= nxt_curr_block_cnt;
	 curr_block_sz 	     <= nxt_curr_block_sz;
	 curr_tx_buf_dout_in <= nxt_curr_tx_buf_dout_in;
	 new_block 	     <= nxt_new_block;
	 end_blk_write_cnt   <= nxt_end_blk_write_cnt;
	 
	 //Inputs internal state regs update	 
	 DAT_din_reg 	     <= DAT_din;
	 write_flag_reg      <= write_flag;
	 read_flag_reg 	     <= read_flag;

	 //Synchronic outputs update
	 DAT_dout 	     <= nxt_DAT_dout;
	 DAT_dout_oe 	     <= nxt_DAT_dout_oe;
      end
   end

   //Next state/outputs logic
   always @(*) begin
      //Default output values
      tx_buf_rd_enb 	       = 0;
      rx_buf_wr_enb 	       = 0;
      rx_buf_din_out 	       = 0;
      tf_finished 	       = 0;
      nxt_DAT_dout 	       = DAT_dout;
      nxt_DAT_dout_oe 	       = DAT_dout_oe;
      
      //Default internal state regs values
      nxt_state 	       = state;
      nxt_sel_offset 	       = sel_offset;
      nxt_curr_block_cnt       = curr_block_cnt;
      nxt_curr_block_sz        = curr_block_sz;
      nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
      nxt_new_block 	       = new_block;
      nxt_end_blk_write_cnt    = end_blk_write_cnt;
      
      case (state)
	 IDLE: begin
	    nxt_DAT_dout_oe = 0; //DAT output is disabled by default
	    if(sdc_busy_L) begin //If card is busy keep IDLE state
	       nxt_state = IDLE;
	    end
	    else begin
	       if(write_flag && !read_flag) begin
		  nxt_state 		   = WRITE;
		  nxt_new_block 	   = 1;
		  tx_buf_rd_enb 	   = 1; //Request data from Tx FIFO
		  nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
		  nxt_sel_offset 	   = 0;		  
		  nxt_curr_block_cnt 	   = block_cnt;
		  nxt_curr_block_sz 	   = block_sz;
	       end
	       else begin
		  if(read_flag && !write_flag) begin
		     nxt_state 	    = READ;
		     rx_buf_wr_enb  = 1;
		  end
		  else begin
		     nxt_state 	= IDLE;
    		  end
	       end
	    end
	 end
         
	 WRITE: begin	       
	    if(new_block && sdc_busy_L) begin
	       nxt_state      = WRITE;
	       nxt_new_block  = 1; //If sd card is busy retry the write operation
	    end
	    else begin //sd card not busy
	       nxt_state  = WRITE;
	       
	       if(new_block) begin
		  nxt_new_block    = 0;
		  nxt_DAT_dout_oe  = 1; //Enable DAT output (WRITE transaction)
		  nxt_DAT_dout 	   = 4'b0000; //Start Sequence
	       end
	       else begin //Not a new block
		  if(sel_offset < `FIFO_WIDTH/4) begin
		     nxt_DAT_dout  = curr_tx_buf_dout_in[(`FIFO_WIDTH-1-(sel_offset<<2))-:4];
		     nxt_curr_block_sz = curr_block_sz-4;
		     nxt_curr_tx_buf_dout_in = curr_tx_buf_dout_in;
		     
		     if(sel_offset < `FIFO_WIDTH/4-1) begin
			nxt_sel_offset = sel_offset+1;
		     end
		     else begin  //sel_offset == (`FIFO_WIDTH/4)-1)
			//Need to request more data from Tx FIFO
			nxt_sel_offset 		 = 0; 
			nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
			//Enable Tx FIFO Read
			tx_buf_rd_enb 		 = (curr_block_cnt-1 > 0) ? 1 : 0;
		     end
		  end
		  else begin //Default unexpected case
		     nxt_sel_offset  = 0;
		  end

		  if(curr_block_sz == 4) begin //Finished to send current block
		     nxt_state = END_BLK_WRITE; //Go to END_BLK_WRITE if a block was transfered
		     nxt_end_blk_write_cnt = 3; //(CRC_seq_length = 2) + (END_seq_length = 1)
		     nxt_curr_block_cnt = curr_block_cnt-1;
		  end
		  else begin
		     nxt_curr_block_cnt = curr_block_cnt;
		  end
	       end
	    end
	 end
	 
	 END_BLK_WRITE: begin
	    if(end_blk_write_cnt >= 0) begin
	       if(end_blk_write_cnt > 1) begin
		  nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
		  nxt_state 		 = END_BLK_WRITE;
		  nxt_DAT_dout 		 = 4'h0; //CRC sequence
	       end
	       else begin
		  if(end_blk_write_cnt == 1) begin
		     nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
		     nxt_state 		    = END_BLK_WRITE;
		     nxt_DAT_dout 	    = 4'b1111; //END sequence (for every block)
		  end
		  else begin //end_blk_write_cnt == 0
		     nxt_DAT_dout_oe  = 0; //Disable DAT output
		     nxt_DAT_dout = 0; //DAT output is 0 by default
		     if(curr_block_cnt > 0) begin //Need to transfer more blocks
			nxt_state 	   = WRITE; //Go to WRITE to transfer more data
			nxt_new_block 	   = 1;
			nxt_curr_block_sz  = block_sz;
		     end
		     else begin //Transfer finished
			nxt_state 	 = IDLE;
			tf_finished 	 = 1;
		     end
		  end		  
	       end
	    end
	    else begin //Default unexpected case
	       nxt_state  = IDLE;
	    end
	 end
	 
	 READ: begin
	    nxt_state = IDLE; //Temporary for testing
	 end
	 default:
	    nxt_state = IDLE;
      endcase

   end
   
endmodule
