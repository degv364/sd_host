////////////////////////////////////////////////////////
// Module: DAT_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../../defines.v"

`timescale 1ns/10ps

module DAT_phys (
		 input 			      sd_clk,
		 input 			      rst_L,
		 input [`FIFO_WIDTH-1:0]      tx_buf_dout_in,
		 input [3:0] 		      DAT_din,
		 input [`BLOCK_SZ_WIDTH-1:0]  block_sz,
		 input [`BLOCK_CNT_WIDTH-1:0] block_cnt,
		 input 			      write_flag,
		 input 			      read_flag,
		 input 			      multiple,
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
   parameter IDLE  = 7'b0000001;
   parameter NEW_WRITE  = 7'b0000010;
   parameter SERIAL_WRITE  = 7'b0000100;
   parameter END_BLK_WRITE  = 7'b0001000;
   parameter NEW_READ  = 7'b0010000;
   parameter SERIAL_READ  = 7'b0100000;
   parameter END_BLK_READ  = 7'b1000000;
   
   //Other
   parameter SIZE  = 7;
   
   /////// Regs declaration
   //Asynchronic output regs
   reg 					      tx_buf_rd_enb;
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
   reg [`FIFO_WIDTH-1:0] 		      rx_buf_din_out;
   reg 					      rx_buf_wr_enb;
   reg 					      new_block;
   reg 					      write_flag_reg;
   reg 					      read_flag_reg;
   reg 					      multiple_reg;
   reg [1:0] 				      end_blk_write_cnt;

   
   //Next state/combinational logic output regs
   reg [SIZE-1:0] 			      nxt_state;
   reg [(`FIFO_WIDTH/4)-1:0] 		      nxt_sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] 		      nxt_curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0] 		      nxt_curr_block_sz;
   reg [`FIFO_WIDTH-1:0] 		      nxt_curr_tx_buf_dout_in;
   reg [`FIFO_WIDTH-1:0] 		      nxt_rx_buf_din_out;
   reg 					      nxt_rx_buf_wr_enb;
   reg 					      nxt_new_block;
   reg [1:0] 				      nxt_end_blk_write_cnt;

   //Stateless combinational logic
   assign sdc_busy_L  = !DAT_din[0] & !DAT_dout_oe;
   assign dat_phys_busy  = (state != IDLE);   
   
   //Update state logic
   always @ (posedge sd_clk) begin
      if(!rst_L) begin
	 
	 //Output reset values
	 DAT_dout 	     <= 0;
	 DAT_dout_oe 	     <= 0;
	 
	 //State regs reset values
	 state 		     <= IDLE;
	 curr_block_cnt      <= 0;
	 curr_block_sz 	     <= 0;
	 sel_offset 	     <= 0;
	 curr_tx_buf_dout_in <= 0;
	 rx_buf_din_out      <= 0;
	 rx_buf_wr_enb 	     <= 0;
	 
	 new_block 	     <= 0;
	 end_blk_write_cnt   <= 0;

	 //Input regs
	 write_flag_reg      <= 0;
	 read_flag_reg 	     <= 0;
	 multiple_reg 	     <= 0;
      end
      else begin
	 //Next state logic related update
	 state 		     <= nxt_state;
	 sel_offset 	     <= nxt_sel_offset;
	 curr_block_cnt      <= nxt_curr_block_cnt;
	 curr_block_sz 	     <= nxt_curr_block_sz;
	 curr_tx_buf_dout_in <= nxt_curr_tx_buf_dout_in;
	 rx_buf_din_out      <= nxt_rx_buf_din_out;
	 rx_buf_wr_enb 	     <= nxt_rx_buf_wr_enb;
	 new_block 	     <= nxt_new_block;
	 end_blk_write_cnt   <= nxt_end_blk_write_cnt;
	 
	 //Inputs internal state regs update	 
	 write_flag_reg      <= write_flag;
	 read_flag_reg 	     <= read_flag;
	 multiple_reg 	     <= multiple;
	 
	 //Synchronic outputs update
	 DAT_dout 	     <= nxt_DAT_dout;
	 DAT_dout_oe 	     <= nxt_DAT_dout_oe;
      end
   end

   //Next state/outputs logic
   always @(*) begin
      //Default output values
      tx_buf_rd_enb 	       = 0;
      tf_finished 	       = 0;
      nxt_DAT_dout 	       = 0;
      nxt_DAT_dout_oe 	       = DAT_dout_oe;
      
      //Default internal state regs values
      nxt_state 	       = state;
      nxt_sel_offset 	       = sel_offset;
      nxt_curr_block_cnt       = 0;//curr_block_cnt;
      nxt_curr_block_sz        = 0;//curr_block_sz;
      nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
      nxt_rx_buf_din_out       = rx_buf_din_out;
      nxt_rx_buf_wr_enb        = 0;

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
		  nxt_state 		   = NEW_WRITE;
		  nxt_new_block 	   = 1;
		  nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
		  nxt_sel_offset 	   = 0;		  
		  nxt_curr_block_cnt 	   = multiple_reg ? block_cnt : 1;
		  nxt_curr_block_sz 	   = block_sz;
	       end
	       else begin
		  if(read_flag && !write_flag) begin
		     nxt_state 		 = NEW_READ;
		     nxt_new_block 	 = 1;
		     nxt_sel_offset 	 = 0;		  
		     nxt_curr_block_cnt  = multiple_reg ? block_cnt : 1;
		     nxt_curr_block_sz 	 = block_sz;
		  end
		  else begin
		     nxt_state 	= IDLE;
    		  end
	       end
	    end
	 end
//------------------------------ WRITE Transaction ----------------------------
	 NEW_WRITE: begin
	    nxt_curr_block_cnt 	= curr_block_cnt; //FIXME: Check
	    nxt_curr_block_sz 	= curr_block_sz;  //FIXME: Check
	     
	    if(new_block && sdc_busy_L) begin
	       nxt_state      = NEW_WRITE;
	       nxt_new_block  = 1; //If sd card is busy retry the write operation
	    end
	    else begin  //sd card not busy
	       //----------Start or Normal Sequence----------
	       if(write_flag) begin //Tx FIFO not empty		  
		  nxt_state 		   = SERIAL_WRITE;
		  //Need to request data from Tx 		     
		  nxt_curr_tx_buf_dout_in  = tx_buf_dout_in;
		  //Enable Tx FIFO Read 
		  tx_buf_rd_enb 	   = (curr_block_cnt-1 > 0) ? 1 : 0;
		  nxt_curr_block_sz 	   = curr_block_sz-4;
		  
		  if(new_block) begin //new block (Start Sequence)
		     nxt_new_block 	= 0;
		     nxt_DAT_dout_oe 	= 1;        //Enable DAT output (WRITE transaction)
		     nxt_DAT_dout 	= 4'b0000;  //Start Sequence
		  end
		  else begin //not a new block (Normal Sequence)
		     nxt_sel_offset  = sel_offset+1;
		     //First 4 bit data group
		     nxt_DAT_dout    = nxt_curr_tx_buf_dout_in[(`FIFO_WIDTH-1)-:4]; 
		  end
	       end
	       else begin //Tx FIFO is empty, keep trying until it is not
		  nxt_state 		   = NEW_WRITE;
		  nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
		  nxt_DAT_dout_oe 	   = 0;   //Disable DAT output
	       end
	    end
	 end

	 SERIAL_WRITE: begin
	    nxt_DAT_dout 	     = curr_tx_buf_dout_in[(`FIFO_WIDTH-1-(sel_offset<<2))-:4];
	    nxt_sel_offset 	     = (sel_offset < `FIFO_WIDTH/4-1) ? sel_offset+1 : 0;
	    nxt_curr_block_sz 	     = (curr_block_sz > 0) ? curr_block_sz-4 : 0;
	    nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
	    
	    if(curr_block_sz == 0) begin //Finished to send current block
	       nxt_state 	      = END_BLK_WRITE; //Go to End Sequence
	       nxt_end_blk_write_cnt  = 3; //(CRC_seq_length = 2) + (END_seq_length = 1)
	       nxt_curr_block_cnt     = curr_block_cnt-1;
	    end
	    else begin
	       nxt_curr_block_cnt     = curr_block_cnt; //FIXME: Check
	       if(sel_offset < `FIFO_WIDTH/4-1) begin
		  nxt_state = SERIAL_WRITE;
	       end
	       else begin		  
		  if (sel_offset == `FIFO_WIDTH/4-1) begin
		     nxt_state = NEW_WRITE; //Go to new Normal Sequence
		  end
		  else begin //Default unexpected state
		     nxt_state = IDLE;
		  end
	       end	
	    end
	 end

	 END_BLK_WRITE: begin
	    nxt_curr_block_cnt 	= curr_block_cnt; //FIXME: Check
	    nxt_curr_block_sz 	= curr_block_sz;  //FIXME: Check

	    //----------CRC and End Sequence---------------
	    if(end_blk_write_cnt > 1) begin
	       nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
	       nxt_state 	      = END_BLK_WRITE;
	       nxt_DAT_dout 	      = 4'h0; //CRC sequence
	    end
	    else begin
	       if(end_blk_write_cnt == 1) begin
		  nxt_end_blk_write_cnt  = end_blk_write_cnt-1;
		  nxt_state 		 = END_BLK_WRITE;
		  nxt_DAT_dout 		 = 4'b1111; //END sequence
	       end
	       else begin //end_blk_write_cnt == 0
		  nxt_DAT_dout_oe  = 0; //Disable DAT output
		  nxt_DAT_dout 	   = 0; //DAT output is 0 by default
		  if(curr_block_cnt > 0) begin //Need to transfer more blocks
		     //Go to NEW_WRITE to transfer a new block
		     nxt_state 		= NEW_WRITE; //Go to Start Sequence 
		     nxt_new_block 	= 1;
		     nxt_curr_block_sz 	= block_sz;
		  end
		  else begin //Transfer finished
		     nxt_state 	  = IDLE;
		     tf_finished  = 1;
		  end
	       end		  
	    end
	 end
//------------------------------ READ Transaction -----------------------------
	 NEW_READ: begin
	    if(new_block && DAT_din!=4'b0000) begin //Start Sequence not received yet
	       nxt_state      = NEW_READ;
	       nxt_new_block  = 1; //Retry new block Read operation
	    end
	    else begin
	       //----------Start or Normal Sequence----------
	       nxt_state  = SERIAL_READ;
	       if(read_flag) begin
		  nxt_curr_block_sz  = curr_block_sz-4;
		  if(new_block) begin  //new block (Start Sequence)
		     nxt_new_block 	      = 0;
		     nxt_rx_buf_din_out  = 0;
		  end
		  else begin  //not a new block (Normal Sequence)
		     nxt_sel_offset 	      = sel_offset+1;
		     //First 4 bit data group
		     nxt_rx_buf_din_out  = DAT_din << (`FIFO_WIDTH-4);
		  end
	       end
	       else begin //Rx FIFO full
		  nxt_state 		   = NEW_READ;
		  //nxt_curr_rx_buf_din_out  = curr_rx_buf_din_out;
		  nxt_rx_buf_din_out  = rx_buf_din_out;
	       end
	    end
	 end

	 SERIAL_READ: begin
	    nxt_rx_buf_din_out 	= rx_buf_din_out | (DAT_din << (`FIFO_WIDTH-4-(sel_offset << 2)));
	    nxt_sel_offset 	= (sel_offset < `FIFO_WIDTH/4-1) ? sel_offset+1 : 0;
	    nxt_curr_block_sz 	= (curr_block_sz > 0) ? curr_block_sz-4 : 0;
	    if(curr_block_sz == 0) begin //Finished to receive current block
	       nxt_state 	       = END_BLK_READ;
	       nxt_curr_block_cnt      = curr_block_cnt-1;
	       nxt_rx_buf_wr_enb  = 1;
	    end
	    else begin
	       if(sel_offset < `FIFO_WIDTH/4-1) begin
		  nxt_state  = SERIAL_READ;
	       end
	       else begin		  
		  if (sel_offset == `FIFO_WIDTH/4-1) begin
		     nxt_state 		     = NEW_READ;
		     nxt_rx_buf_wr_enb  = 1;
		  end
		  else begin //Default unexpected state
		     nxt_state = IDLE;
		  end
	       end	
	    end
	 end

	 END_BLK_READ: begin
	    //----------CRC and End Sequence---------------
	    if(DAT_din!=4'b1111) begin //End sequence not received yet
	       nxt_state  = END_BLK_READ;
	       //Simulate reading CRC sequence
	    end
	    else begin
	       if(curr_block_cnt > 0) begin //Need to read more blocks
		  //Go to NEW_READ to read a new block
		  nxt_state 	     = NEW_READ; //Go to Start Sequence 
		  nxt_new_block      = 1;
		  nxt_curr_block_sz  = block_sz;
	       end
	       else begin //Transfer finished
		  nxt_state    = IDLE;
		  tf_finished  = 1;
	       end
	    end
	 end
	 
	 default:
	    nxt_state = IDLE;
      endcase

   end
   
endmodule
