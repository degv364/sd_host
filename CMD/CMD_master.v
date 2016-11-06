// Author: Daniel Piedra
//Description: interface between sd host and CMD_physical. Works with SD host clock



module CMD_master(

	input reset, 
	input CLK_host,
	input new_cmd,
	input cmd_error,
	input ACK_in,
	input REQ_in,
	input [31:0] cmd_arg,
	input [5:0] cmd_index, 
	input [15:0]timeout_value,
	input [37:0] cmd_response,

	output cmd_busy,
	output cmd_complete,
	output cmd_index_error,
	output REQ_out,
	output ACK_out,
	output timeout_error,
	output [31:0]response_arg,
	output [5:0]response_index,
	output [37:0]cmd_out
	);

	//States (one-hot)
	parameter st_waiting_for_cmd = 4'b0001;
	parameter st_setup = 4'b0010;
	parameter st_waiting_for_response = 4'b0100;
	parameter st_finishing = 4'b1000;

	//inputs
	wire reset, CLK_host, new_cmd,cmd_error, ACK_in, REQ_in;
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire [15:0]timeout_value;
	wire [37:0] cmd_response;
	
	
	//outputs
	reg cmd_busy, cmd_complete,cmd_index_error,REQ_out,ACK_out,timeout_error;
	reg [31:0]response_arg;
	reg [5:0]response_index;
	reg [37:0]cmd_out;
	
	//other wires
	wire [2:0] next_st;
	
	//other regs
	reg [3:0] current_st = st_waiting_for_cmd;
	reg counter_flag;
	reg execute_complete;
	
	//other blocks
	timeout_counter time_counter_1(CLK_host,timeout_value, counter_flag, timeout_error_counter);
	
	
	//FF's and next state block
	always @(posedge CLK_host) begin
			current_st <= current_st;
			if (reset) begin
				current_st <= st_waiting_for_cmd;
			end
			case(current_st)
				
				st_waiting_for_cmd: begin
					if (new_cmd == 1) begin
						current_st <= st_setup;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				st_setup: begin			
					if(ACK_in == 1) begin
						current_st <= st_waiting_for_response;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				st_waiting_for_response: begin
					if((timeout_error_counter == 1) || (cmd_error == 1) || (execute_complete == 1) ) begin
						current_st <= st_finishing;
					end
					else begin
						current_st <= current_st;
					end
				end
				
				st_finishing: begin
					current_st <= st_waiting_for_cmd;
							
				end
				
				default: current_st <= st_waiting_for_cmd;
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
		response_arg = response_arg;
		response_index = response_index;
		cmd_out = cmd_out;
		counter_flag = counter_flag;
		execute_complete = execute_complete;
		
		case (current_st)
			st_waiting_for_cmd: begin
				cmd_busy = 0;
				cmd_complete = 0;
				cmd_index_error = 0;
				REQ_out = 0;
				ACK_out = 0;
				timeout_error = 0;
				response_arg = 32'h0000_0000;
				response_index = 6'b000000;
				cmd_out = 38'h0000_0000;
				counter_flag =0;
				execute_complete =0;
					
			end
		
			st_setup: begin
				cmd_busy = 1;
				REQ_out = 1;
				cmd_out[37:32] = cmd_index;
				cmd_out[31:0] = cmd_arg;
			
							
			end
		
			st_waiting_for_response: begin
				counter_flag = 1;
				if (timeout_error_counter == 1) begin
					timeout_error = 1;
				
				end
				if (cmd_error == 1) begin
					cmd_index_error = 1;
				
				end
				if (REQ_in == 1) begin
					ACK_out = 1;
					cmd_complete = 1;
					execute_complete =1;
				end
			
			end
			
			st_finishing: begin
				counter_flag = 0;
				response_index = cmd_response [37:32];
				response_arg = cmd_response [31:0];
				ACK_out = 0;
			end
			
			
	
		endcase
	end

endmodule



//////                     Other modules                             ///////

module timeout_counter(clk,max_timeout_value, start_count, timeout_error);
	input clk, start_count;
	input [15:0] max_timeout_value;
	output timeout_error;
	
	reg [15:0] time_counter = 16'b0000_0000_0000_0000;
	reg timeout_error = 0;
	
	always @(posedge clk) begin
		if(start_count) begin
			time_counter <= time_counter + 1;
			if(time_counter == max_timeout_value)begin
				timeout_error = 1;
			end
			else begin
				timeout_error = 0;
			end
		end
		else begin
			time_counter = 16'b0000_0000_0000_0000;
		end
		
	end
	

endmodule


