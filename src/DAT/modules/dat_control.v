////////////////////////////////////////////////////////
// Module: data_control
// Author: Esteban Zamora A
// Project: SD Host Controller
////////////////////////////////////////////////////////

`timescale 1ns/10ps

//TODO?: Timeout check

module DAT_control (
		    input  host_clk, 
		    input  rst_L,
		    input  tx_data_init,
		    input  rx_data_init,
		    input  tx_buf_empty,
		    input  rx_buf_full,
		    input  tf_finished,
		    input  dat_phys_busy,
		    output dat_wr_flag,
		    output dat_rd_flag
		    );
   //Regs
   //Outputs
   reg 			   dat_wr_flag;
   reg 			   dat_rd_flag;
   
   parameter SIZE = 5;
   reg [SIZE-1:0] 	   state;
   reg [SIZE-1:0] 	   nxt_state;
   
   //FSM States
   parameter IDLE = 5'b00001;
   parameter WRITE_START = 5'b00010;
   parameter READ_START = 5'b00100;
   parameter READ_TRANSFER  = 5'b01000;
   parameter WRITE_TRANSFER  = 5'b10000;
   
   //Update state 
   always @ (posedge host_clk or !rst_L) begin
      if(!rst_L) begin
	 state 		<= IDLE;
	 dat_wr_flag 	<= 0;	
	 dat_rd_flag 	<= 0;
      end	
      else
	 state <= nxt_state;
   end

   //Next state, outputs logic
   always @(*) begin
      //always @(posedge host_clk or state) begin
      //Default output values
      dat_wr_flag = 0;
      dat_rd_flag = 0;
      
      case (state)
	 IDLE: begin
	    if(tx_data_init && !rx_data_init) begin
	       nxt_state = WRITE_START;
	    end
	    else begin
	       if(rx_data_init && !tx_data_init) begin
		  nxt_state = READ_START;
	       end
	       else
		  nxt_state = IDLE;
	    end
	 end 
   
	 WRITE_START: begin
	    if(!tx_buf_empty && !dat_phys_busy) begin
	       nxt_state = WRITE_TRANSFER;
	       dat_wr_flag = 1;
	       //TODO: Set Write Transfer Active bit (Present State Register)
	    end
	    else
	       nxt_state = WRITE_START;
	 end	

	 READ_START: begin
	    if(!rx_buf_full && !dat_phys_busy) begin
	       nxt_state = READ_TRANSFER;
	       dat_rd_flag = 1;
	       //TODO: Set Read Transfer Active bit (Present State Register)
	    end
	    else
	       nxt_state = READ_START;
	 end

	 READ_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_rd_flag = !rx_buf_full;
	       nxt_state = READ_TRANSFER;
	    end	
	    else begin
	       //TODO: Set Transfer Complete bit (Normal Interrupt Register)
	       //TODO: Clear Read Transfer Active bit (Present State Register)
	       nxt_state = IDLE;
	    end
	    
	 end

	 WRITE_TRANSFER: begin
	    if(!tf_finished) begin
	       dat_wr_flag = !tx_buf_empty;
	       nxt_state = WRITE_TRANSFER;
	    end	
	    else begin
	       //TODO: Set Transfer Complete bit (Normal Interrupt Register)
	       //TODO: Clear Write Transfer Active bit (Present State Register)
	       nxt_state = IDLE;
	    end
	    
	 end
 
	 default: begin
	    nxt_state = IDLE;
	 end
      endcase // case (state)
   end  
endmodule
