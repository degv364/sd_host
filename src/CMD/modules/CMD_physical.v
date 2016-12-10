
`ifndef CMD_PHYSICAL
`define CMD_PHYSICAL
module CMD_physical (
	input reset,
	input CLK_SD_card,
	input new_cmd,
	input [37:0] cmd_index_arg,
	input REQ_in,
	input ACK_in,
	input cmd_from_sd,
	
	output REQ_out,
	output ACK_out,
	output [47:0] cmd_response,
	output cmd_to_sd,
	output timeout_error,
	output physical_inactive,
	output cmd_to_sd_oe
	
);

	//States (one-hot)
	parameter ST_INACTIVE = 6'b000001;
	parameter ST_SETUP = 6'b000010;
	parameter ST_SENDING = 6'b000100;
	parameter ST_WAITING_RESPONSE = 6'b001000;
	parameter ST_RECEIVING_RESPONSE = 6'b010000;
	parameter ST_RETURN_RESPONSE = 6'b100000;

	//inputs
	wire reset, CLK_SD_card, new_cmd, REQ_in, ACK_in, cmd_from_sd;
	wire [37:0] cmd_index_arg;
	
	//outputs
	reg REQ_out, ACK_out, physical_inactive, timeout_error, cmd_to_sd_oe; 
	wire cmd_to_sd;
	reg [47:0] cmd_response;
	
	
	//other regs
	reg start_sending;
	reg start_listening;
	reg [5:0] current_st = ST_INACTIVE;
	reg start_counting;
	reg [47:0] cmd_to_send;
	
	//other wires
	wire send_finished;
	wire listening_finished;
	wire [47:0] parallel_to_send;
	wire [47:0] parallel_received;
	wire finished_64_cycles;
	wire [5:0] parallel_to_serial_counter;
	
	assign parallel_to_send = cmd_to_send;
	
	
	
	//other blocks
	parallel_to_serial parallel_to_serial_1 (.CLK(CLK_SD_card), .start_sending(start_sending), .parallel_in(parallel_to_send), .finished(send_finished), .serial_out(cmd_to_sd), .counter(parallel_to_serial_counter));
	
	serial_to_parallel serial_to_parallel_1 (.CLK(CLK_SD_card), .start_listening(start_listening), .serial_in(cmd_from_sd), .finished(listening_finished), .parallel_out(parallel_received));
	
	counter_64 counter_1 (.CLK(CLK_SD_card), .start_count(start_counting), .finished(finished_64_cycles) );
	
	
	//FF's and next state block
	always @ (posedge CLK_SD_card) begin
		if (reset) begin
				current_st <= ST_INACTIVE;
		end
		else begin
			current_st <= current_st;
		end
		case(current_st)
			ST_INACTIVE: begin
				if (new_cmd == 1) begin
					current_st <= ST_SETUP;
				end
				else begin
					current_st <= current_st;
				end
			
			end
		
		
			ST_SETUP: begin
				if (ACK_out == 1) begin
						current_st <= ST_SENDING;
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
			ST_SENDING: begin
				if (send_finished == 1) begin
						current_st <= ST_WAITING_RESPONSE;
				end
				else begin
						current_st <= current_st;
				end
							
			end
		
			ST_WAITING_RESPONSE: begin
				if (finished_64_cycles == 1) begin
						current_st <= ST_INACTIVE;
				end
				else if (cmd_from_sd == 0) begin
					current_st <= ST_RECEIVING_RESPONSE;
				
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
			ST_RECEIVING_RESPONSE: begin
				if (listening_finished == 1) begin
						current_st <= ST_RETURN_RESPONSE;
				end
				else begin
						current_st <= current_st;
				end
						
			end
		
			ST_RETURN_RESPONSE: begin
				if (ACK_in == 1) begin
						current_st <= ST_INACTIVE;
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
		
			default : current_st <= ST_INACTIVE;
		endcase
	
	end
	

	//Combinational logic
	
	always @(*) begin
	
		case(current_st)
				
			ST_INACTIVE: begin
				REQ_out = 0;
				ACK_out = 0;
				cmd_response = 0;
				start_sending = 0;
				start_listening = 0;
				cmd_to_send = 0;
				start_counting = 0;
				physical_inactive = 1;
				timeout_error = 0;
				
			end
			
			ST_SETUP: begin
				REQ_out = 0;
				cmd_response = 0;
				start_sending = 0;
				start_listening = 0;
				start_counting = 0;
				physical_inactive = 0;
				timeout_error = 0;
				
				
				
				if (REQ_in == 1) begin
					cmd_to_send [47:46] = 2'b01; 
					cmd_to_send [45:40] = cmd_index_arg [37:32];
					cmd_to_send [39:8] = cmd_index_arg [31:0];
					cmd_to_send [7:1] = 7'b0101_010;
					cmd_to_send [0:0] = 1'b1;
					
					ACK_out = 1'b1;
					
				
				end
				else begin
					cmd_to_send = 0;
					ACK_out = 1'b0;
					
				end
			
			end
			
			ST_SENDING: begin
				REQ_out = 0;
				ACK_out = 0;
				cmd_response = 0;
				start_sending = 1;
				start_listening = 0;
				cmd_to_send [47:46] = 2'b01; 
				cmd_to_send [45:40] = cmd_index_arg [37:32];
				cmd_to_send [39:8] = cmd_index_arg [31:0];
				cmd_to_send [7:1] = 7'b0101_010;
				cmd_to_send [0:0] = 1'b1;
				start_counting = 0;
				physical_inactive = 0;
				timeout_error = 0;
				
				
			
			end
			
			ST_WAITING_RESPONSE: begin
				REQ_out = 0;
				ACK_out = 0;
				cmd_response = 0;
				start_sending = 0;
				cmd_to_send = 0;
				physical_inactive = 0;
				timeout_error = 0;
				
				
				if (cmd_from_sd == 0) begin
					start_counting = 1'b0;
					start_listening = 1'b1;
				end
				else begin
					start_counting = 1'b1;
					start_listening = 0;
					if (finished_64_cycles == 1) begin
						timeout_error = 1;
					end
					else begin
						timeout_error = 0;
					end
					
				end
			
			end
			
			ST_RECEIVING_RESPONSE: begin
				REQ_out = 0;
				ACK_out = 0;
				cmd_response = parallel_received;
				start_sending = 0;
				start_listening = 1;
				cmd_to_send = 0;
				start_counting = 1'b0;
				physical_inactive = 0;
				timeout_error = 0;
				
				
								
				
			end
			
			ST_RETURN_RESPONSE: begin
				REQ_out = 1'b1;
				ACK_out = 0;
				cmd_response = parallel_received;
				start_sending = 0;
				start_listening = 0;
				cmd_to_send = 0;
				start_counting = 1;
				physical_inactive = 0;
				timeout_error = 0;
				
				
							
			
			end
			
			default: begin
				REQ_out = 0;
				ACK_out = 0;
				cmd_response = 0;
				start_sending = 0;
				start_listening = 0;
				cmd_to_send = 0;
				start_counting = 0;
				physical_inactive = 1;
				timeout_error = 0;
			
			end
			
			
		endcase
		
		
		
		
		
		
		
		
		if (parallel_to_serial_counter == 6'b000_000) begin
			cmd_to_sd_oe = 0;
		end
		else begin
			cmd_to_sd_oe = 1;
		end
	
	end
	
	


endmodule

`endif

//////                     Other modules                             ///////


`ifndef PARALLEL_TO_SERIAL
`define PARALLEL_TO_SERIAL
module parallel_to_serial (
	input CLK,
	input start_sending,
	input [parallel_width-1:0] parallel_in,
	
	output finished,
	output [serial_width-1:0] serial_out,
	output [counter_size-1:0] counter

);

	parameter parallel_width = 48;
	parameter serial_width = 1;
	parameter counter_size = 6; //bits needed to count from 0 to max value (parallel_width divide by serial_width)

	reg [counter_size-1:0] counter = 0;
	reg finished;
	reg [serial_width-1:0] serial_out;

	always @(posedge CLK )begin
		if(start_sending) begin
			
			if(counter<parallel_width) begin
				finished = 1'b0;
				serial_out = parallel_in[parallel_width-1-counter -: serial_width];
				counter = counter + serial_width;
			end
			else begin
				finished = 1'b1;
				serial_out = 0;
			end
			
		
		end
		else begin
			serial_out = 0;
			counter = 0;
			finished = 1'b0;
		end
	
	end


endmodule

`endif

// New module **************************************

`ifndef SERIAL_TO_PARALLEL
`define SERIAL_TO_PARALLEL

module serial_to_parallel(
	input CLK,
	input start_listening,
	input [serial_width-1:0] serial_in,
		
	
	output finished,
	output [parallel_width-1:0] parallel_out

	);



	parameter parallel_width = 48;
	parameter serial_width = 1;
	parameter counter_size = 6; //bits needed to count from 0 to max value (parallel_width divide by serial_width)

	reg [counter_size-1:0] counter = 0;
	reg finished = 0;
	reg [parallel_width-1:0] parallel_out=0;
	
	
	

	always @(negedge CLK) begin
		if(start_listening) begin
			if(counter < parallel_width)begin
				counter = counter + serial_width;
				parallel_out [parallel_width-counter -: serial_width] = serial_in;
				finished = 1'b0;
			end
			else begin
				finished = 1'b1;
			end	 
		end
		else begin
			parallel_out = 0;
			counter = 0;
			finished = 1'b0;
		end
		
		
		
	end
	
	
	
endmodule
`endif

// New module **************************************
`ifndef COUNTER_64
`define COUNTER_64
module counter_64(
	input CLK, 
	input start_count,
	output finished
	);
	
	reg finished = 0;
	reg  [5:0] counter = 6'b0000_00; 
	
	always @(posedge CLK) begin
		if (start_count == 1) begin
			if ( counter == 6'b1111_11) begin
				finished = 1'b1;
			end
			else begin
				finished = 1'b0;
				counter = counter + 1;
			end
		
		end
		else begin
			counter = 6'b0000_00;
			finished = 1'b0;
		end
		
	end
	

endmodule
`endif
