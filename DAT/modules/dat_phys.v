////////////////////////////////////////////////////////
// Module: data_phys
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`include "../defines.v"

`timescale 1ns/10ps


//TODO: Single/multiple block selection
//TODO: Check for FIFOs full/empty cases
//TODO: Start/End Sequence
//TODO: Read transaction
//TODO: DAT Control flags synchronization
//TODO: Sel_offset counter should be updated in sequential logic


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
		 output 		      dat_phys_busy,
		 output 		      tf_finished,
		 output 		      sdc_busy_L
		 );

   /////// Parameters
   //FSM States
   parameter IDLE  = 3'b001;
   parameter WRITE  = 3'b010;
   parameter READ = 3'b100;
   
   //Other
   parameter SIZE  = 3;
   
   /////// Regs declaration
   //Asynchronic output regs
   reg 		          tx_buf_rd_enb;
   reg 			  rx_buf_wr_enb;
   reg [`FIFO_WIDTH-1:0]  rx_buf_din_out;
   reg [3:0] 		  DAT_dout;
   reg 			  tf_finished;
   
   //Synchronic output next regs
   reg [3:0] 		  nxt_DAT_dout;
   
   //Internal state related regs
   reg [SIZE-1:0] 	  state;
   reg [(`FIFO_WIDTH/4)-1:0] sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0]  curr_block_sz;
   reg [`FIFO_WIDTH-1:0]      curr_tx_buf_dout_in;
   reg 			      new_block;
   reg 			      DAT_din_reg; //TODO: Check when implementing READ
   reg 			      write_flag_reg;
   reg 			      read_flag_reg;
   
   //Next state/combinational logic output regs
   reg [SIZE-1:0] 	      nxt_state;
   reg [(`FIFO_WIDTH/4)-1:0]  nxt_sel_offset;
   reg [`BLOCK_CNT_WIDTH-1:0] nxt_curr_block_cnt;
   reg [`BLOCK_SZ_WIDTH-1:0]  nxt_curr_block_sz;
   reg [`FIFO_WIDTH-1:0]      nxt_curr_tx_buf_dout_in;
   reg 			      nxt_new_block;

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

	 //State regs reset values
	 state 		     <= IDLE;
	 curr_block_cnt      <= 0;
	 curr_block_sz 	     <= 0;
	 sel_offset 	     <= 0;
	 curr_tx_buf_dout_in <= 0;
	 new_block 	     <= 0;

	 DAT_din_reg 	     <= 0;
	 write_flag_reg      <= 0;
	 read_flag_reg 	     <= 0;

      end	
      else begin
	 //Next state logic relate update
	 state 		     <= nxt_state;
	 sel_offset 	     <= nxt_sel_offset;
	 curr_block_cnt      <= nxt_curr_block_cnt;
	 curr_block_sz 	     <= nxt_curr_block_sz;
	 curr_tx_buf_dout_in <= nxt_curr_tx_buf_dout_in;
	 new_block 	     <= nxt_new_block;

	 //Inputs internal state regs update	 
	 DAT_din_reg 	     <= DAT_din;
	 write_flag_reg      <= write_flag;
	 read_flag_reg 	     <= read_flag;

	 //Synchronic outputs update
	 DAT_dout <= nxt_DAT_dout;
      end
   end

   //Next state/outputs logic
   always @(*) begin
      //Default output values
      tx_buf_rd_enb 	       = 0;
      rx_buf_wr_enb 	       = 0;
      rx_buf_din_out 	       = 0;
      tf_finished 	       = 0;
      nxt_DAT_dout 	       = 0; //Check correct default values
      
      //Default internal state regs values
      nxt_state 	       = state;
      nxt_sel_offset 	       = sel_offset;
      nxt_curr_block_cnt       = curr_block_cnt;
      nxt_curr_block_sz        = curr_block_sz;
      nxt_curr_tx_buf_dout_in  = curr_tx_buf_dout_in;
      nxt_new_block 	       = new_block;
      
      case (state)
	 IDLE: begin
	    
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
	    if(curr_block_cnt > 0) begin

	       nxt_state = WRITE;
	       
	       if(new_block && sdc_busy_L) begin
		  nxt_new_block = 1; //If sd card is busy retry the write operation
	       end
	       else begin
		  nxt_new_block = 0;

		  /*
		  if(sel_offset == 0) begin //Get new data from Tx FIFO
		   nxt_curr_tx_buf_dout_in = tx_buf_dout_in;
		  end
		  else begin
		   nxt_curr_tx_buf_dout_in = curr_tx_buf_dout_in;
		  end
		   */
		   
		  if(sel_offset < `FIFO_WIDTH/4) begin
		     nxt_DAT_dout  = curr_tx_buf_dout_in[(`FIFO_WIDTH-1-(sel_offset<<2))-:4];
		     nxt_curr_block_sz = curr_block_sz-4;
		     nxt_curr_tx_buf_dout_in = curr_tx_buf_dout_in;
		     
		     if(sel_offset < `FIFO_WIDTH/4-1) begin
			nxt_sel_offset = sel_offset+1;
		     end
		     else begin  //sel_offset == (`FIFO_WIDTH/4)-1)
			//Need to tranfer more blocks
			nxt_sel_offset 	= 0; 
			nxt_curr_tx_buf_dout_in = tx_buf_dout_in;
			//Prepare to request data from Tx FIFO
			tx_buf_rd_enb 	= (curr_block_cnt-1 > 0) ? 1 : 0;
		     end
		  end
		  else begin //Default unexpected case
		     nxt_sel_offset = 0;
		  end

		  if(curr_block_sz == 4) begin //Finished to send current block //TEST
		     nxt_new_block = (curr_block_cnt-1 > 0) ? 1 : 0; //Need to tranfer more blocks
		     nxt_curr_block_sz = block_sz;
		     nxt_curr_block_cnt = curr_block_cnt-1;
		  end
		  else begin
		     nxt_curr_block_cnt = curr_block_cnt;
		  end
	       end
	    end 
	    else begin
	       nxt_state = IDLE; //Return to IDLE if all the blocks were transfered
	       tf_finished = 1;
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
