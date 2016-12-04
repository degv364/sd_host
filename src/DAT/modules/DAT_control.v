////////////////////////////////////////////////////////
// Module: DAT_control
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`timescale 1ns/10ps

//FIXME?: Timeout check

module DAT_control (
		    input  host_clk, 
		    input  rst_L,
		    input  tf_direction_reg,
		    input  resp_recv,
		    input  tx_buf_empty,
		    input  rx_buf_full,
		    input  tf_finished,
		    input  dat_phys_busy,
		    output wr_tf_active_reg,
		    output rd_tf_active_reg,
		    output cmd_inhibit_dat_reg,
		    output [2:0] PSR_wr_enb,
		    output tf_complete_reg,
		    output NISR_wr_enb,
		    output dat_wr_flag,
		    output dat_rd_flag
		    );
   //Regs
   //Outputs
   reg 			   dat_wr_flag;
   reg 			   dat_rd_flag;
   reg 			   wr_tf_active_reg;
   reg 			   rd_tf_active_reg;
   reg 			   cmd_inhibit_dat_reg;
   reg [2:0] 		   PSR_wr_enb;
   reg 			   tf_complete_reg;
   reg 			   NISR_wr_enb;
   
   
   parameter SIZE = 5;
   reg [SIZE-1:0] 	   state;
   reg [SIZE-1:0] 	   nxt_state;
   
   //FSM States
   parameter IDLE = 5'b00001;
   parameter WRITE_START = 5'b00010;
   parameter READ_START = 5'b00100;
   parameter READ_TRANSFER  = 5'b01000;
   parameter WRITE_TRANSFER  = 5'b10000;


   assign wr_valid  = !tx_buf_empty && !dat_phys_busy;
   assign rd_valid = !rx_buf_full && !dat_phys_busy;
   
   
   //Update state 
   always @ (posedge host_clk or !rst_L) begin
      if(!rst_L) begin
	 state 		     <= IDLE;
	 dat_wr_flag 	     <= 0;	
	 dat_rd_flag 	     <= 0;
	 wr_tf_active_reg    <= 0;
	 rd_tf_active_reg    <= 0;
	 tf_complete_reg     <= 0;
	 cmd_inhibit_dat_reg <= 0;
	 PSR_wr_enb 	     <= 0;
	 NISR_wr_enb 	     <= 0;
      end	
      else
	 state <= nxt_state;
   end

   //Next state, outputs logic
   always @(*) begin
      //Default output values
      dat_wr_flag 	   = 0;
      dat_rd_flag 	   = 0;
      wr_tf_active_reg 	   = 0;
      rd_tf_active_reg 	   = 0;
      cmd_inhibit_dat_reg  = 0;
      tf_complete_reg 	   = 0;
      PSR_wr_enb 	   = 0;
      NISR_wr_enb 	   = 0;
      
      case (state)
	 IDLE: begin
	    if(resp_recv) begin
	       if(tf_direction_reg == 1) begin //Read
		  nxt_state = READ_START;
	       end
	       else begin //Write
		  nxt_state = WRITE_START;
	       end
	    end
	    else begin
	       nxt_state = IDLE;
	    end
	 end 
   
	 WRITE_START: begin
	    if(wr_valid) begin
	       nxt_state 	    = WRITE_TRANSFER;
	       dat_wr_flag 	    = 1;
	       wr_tf_active_reg     = 1;
	       PSR_wr_enb[1] 	    = 1;
	       cmd_inhibit_dat_reg  = 1;
	       PSR_wr_enb[0] 	    = 1;
	    end
	    else
	       nxt_state = WRITE_START;
	 end	

	 READ_START: begin
	    if(rd_valid) begin
	       nxt_state 	    = READ_TRANSFER;
	       dat_rd_flag 	    = 1;
	       rd_tf_active_reg     = 1;
	       PSR_wr_enb[2] 	    = 1;
	       cmd_inhibit_dat_reg  = 1;
	       PSR_wr_enb[0] 	    = 1;
	    end
	    else
	       nxt_state = READ_START;
	 end

	 READ_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_rd_flag  = !rx_buf_full;
	       nxt_state    = READ_TRANSFER;
	    end
	    else begin
	       rd_tf_active_reg     = 0;
	       PSR_wr_enb[2] 	    = 1;
	       cmd_inhibit_dat_reg  = 0;
	       PSR_wr_enb[0] 	    = 1;
	       tf_complete_reg 	    = 1;
	       NISR_wr_enb 	    = 1;
	       nxt_state 	    = IDLE;
	    end
	 end

	 WRITE_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_wr_flag = !tx_buf_empty;
	       nxt_state = WRITE_TRANSFER;
	    end	
	    else begin
	       wr_tf_active_reg     = 0;
	       PSR_wr_enb[1] 	    = 1;
	       cmd_inhibit_dat_reg  = 0;
	       PSR_wr_enb[0] 	    = 1;
	       tf_complete_reg 	    = 1;
	       NISR_wr_enb 	    = 1;
	       nxt_state 	    = IDLE;
	    end
	 end
 
	 default: begin
	    nxt_state = IDLE;
	 end
      endcase
   end  
endmodule
