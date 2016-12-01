// Author: Daniel Piedra
//Description: interface between sd host and CMD_physical. Works with SD host clock

`ifndef CMD_MASTER
`define CMD_MASTER

module CMD_master(

	input reset, 
	input CLK_host,
	input new_cmd,
	input ACK_in,
	input REQ_in,
	input physical_inactive,
	input [31:0] cmd_arg,
	input [5:0] cmd_index, 
	input [47:0] cmd_response,
	input timeout_error_from_physical,

	output cmd_busy,
	output cmd_complete,
	output REQ_out,
	output ACK_out,
	output timeout_error,
	output [31:0]response_status,
	output [37:0]cmd_to_physical
	);

	//States (one-hot)
	parameter ST_WAITING_CMD = 4'b0001;
	parameter ST_SETUP = 4'b0010;
	parameter ST_WAITING_RESPONSE = 4'b0100;
	parameter ST_FINISHING = 4'b1000;

	//inputs
	wire reset, CLK_host, new_cmd, ACK_in, REQ_in;
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire [47:0] cmd_response;
	
	
	//outputs
	reg cmd_busy, cmd_complete,cmd_index_error,REQ_out,ACK_out,timeout_error;
	reg [31:0]response_status;
	reg [37:0]cmd_to_physical;
	
	//other wires
	
	
	//other regs
	reg [3:0] current_st = ST_WAITING_CMD;
	reg start_counting;
	reg execute_complete;
	
	
	
	
	
	//FF's and next state block
	always @(posedge CLK_host) begin
			if (reset || physical_inactive) begin
				current_st <= ST_WAITING_CMD;
			end
			else begin
				current_st <= current_st;
			end
			case(current_st)
				
				ST_WAITING_CMD: begin
					if (new_cmd == 1) begin
						current_st <= ST_SETUP;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				ST_SETUP: begin			
					if(ACK_in == 1) begin
						current_st <= ST_WAITING_RESPONSE;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				ST_WAITING_RESPONSE: begin
					if( execute_complete == 1 ) begin
						current_st <= ST_FINISHING;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				ST_FINISHING: begin
					current_st <= ST_WAITING_CMD;
							
				end
				
				default: current_st <= ST_WAITING_CMD;
			endcase
	
	end


	//Combinational logic
	always @(*) begin
	
		cmd_busy = cmd_busy;
		cmd_complete = cmd_complete;
		cmd_index_error = cmd_index_error;
		REQ_out = REQ_out;
		ACK_out = ACK_out;
		timeout_error = timeout_error;
		response_status = response_status;
		cmd_to_physical = cmd_to_physical;
		start_counting = start_counting;
		execute_complete = execute_complete;
		
		case (current_st)
			ST_WAITING_CMD: begin
				cmd_busy = 0;
				cmd_complete = 0;
				cmd_index_error = 0;
				REQ_out = 0;
				ACK_out = 0;
				timeout_error = 0;
				response_status = 32'h0000_0000;
				cmd_to_physical = 38'h0000_0000;
				start_counting =0;
				execute_complete =0;
					
			end
		
			ST_SETUP: begin
				cmd_busy = 1;
				REQ_out = 1;
				cmd_to_physical[37:32] = cmd_index;
				cmd_to_physical[31:0] = cmd_arg;
			
							
			end
		
			ST_WAITING_RESPONSE: begin
				start_counting = 1;
				
				if (REQ_in == 1 ) begin
					ACK_out = 1;
					execute_complete =1;
				end
				else if (timeout_error_from_physical == 1) begin
					timeout_error = 1;
					execute_complete = 1;
				end
				else begin
					ACK_out = 0;
					execute_complete =0;
					timeout_error = 0;
				end
			
			end
			
			ST_FINISHING: begin
				response_status = cmd_response [39:8];
				ACK_out = 0;
				if (timeout_error == 1) begin
					timeout_error = 1;
					cmd_complete = 0;
				end
				else begin
					timeout_error = 0;
					cmd_complete = 1;
					
				end
				
			end
			
			
	
		endcase
		
		
		
	end

endmodule

`endif

//////                     Other modules                             ///////


