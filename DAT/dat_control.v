////////////////////////////////////////////////////////
// Module: data_control
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`timescale 1ns/10ps

//TODO: Check if a DAT_control busy signal is necessary
//TODO: Timeout check
module dat_control(input host_clk, 
		   input  rst_L,
		   input  tx_data_init,
		   input  rx_data_init,
		   input  tx_buf_empty,
		   input  tx_buf_full,
		   input  rx_buf_full,
		   input  tf_finished,
		   output dat_wr_flag,
		   output dat_rd_flag,
		   );
   //Regs
   reg 			   wr_data_flag; //Cleared after WRITE_START
   reg 			   rd_data_flag; //Cleared after READ_START
   
   parameter SIZE = 4;
   reg [SIZE-1:0] 	   state;
   reg [SIZE-1:0] 	   next_state;
   
   //FSM States
   parameter IDLE = 4'b0001;
   parameter WRITE_START = 4'b0010;
   parameter READ_START = 4'b0100;
   parameter TRANSFER = 4'b1000;
   
   //Update state 
   always @ (posedge host_clk or !rst_L) begin
      if(!rst_L) begin
	 state 		<= IDLE;	
	 dat_wr_flag 	<= 0;	
	 dat_rd_flag 	<= 0;
      end	
      else
	 state <= next_state;
   end

   //Combinational logic (next state, outputs)
   always @(*) begin
      //Default output values
      dat_wr_flag <= 0;	
      dat_rd_flag <= 0;
      
      case (state)
	 IDLE: begin
	    if(tx_data_init && !rx_data_init) begin
	       next_state <= WRITE_START;
	    end
	    else	begin
	       if(rx_data_init && !tx_data_init) begin
		  next_state <= READ_START;
	       end
	       else
		  next_state <= IDLE;
	    end
	    	 end

	 WRITE_START: begin
	    if(!tx_buf_empty) begin
	       next_state <= TRANSFER;
	       dat_wr_flag <= 1;
	       //TODO: Set Write Transfer Active bit (Present State Register)
	    end
	    else
	       next_state <= WRITE_START;
	 end	

	 READ_START: begin
	    if(!rx_buf_full) begin
	       next_state <= TRANSFER;
	       dat_rd_flag <= 1;
	       //TODO: Set Read Transfer Active bit (Present State Register)
	    end
	    else
	       next_state <= READ_START;
	 end
	 
	 TRANSFER: begin
	    if(!tf_finished) begin
	       next_state <= TRANSFER;
	    end	
	    else //Transfer completed
	       //TODO: Set Transfer Complete bit (Normal Interrupt Register)
	       //TODO: Clear Write Transfer Active bit (Present State Register)
	       //TODO: Clear Read Transfer Active bit (Present State Register)
	       next_state <= IDLE;
	 end	
	 
	 default: begin
	    next_state <= IDLE;
	 end
      endcase // case (state)
   end  
endmodule
