module CMD_physical (
	input reset,
	input CLK_SD_card,
	input new_cmd,
	input [37:0] cmd_index_arg,
	input REQ_in,
	input ACK_in,
	input timeout_error,
	input cmd_from_sd,
	
	output REQ_out,
	output ACK_out,
	output [37:0] cmd_response,
	output cmd_to_sd
	
);

	//States (one-hot)
	parameter st_inactive = 6'b000001;
	parameter st_setup = 6'b000010;
	parameter st_sending = 6'b000100;
	parameter st_waiting_response = 6'b001000;
	parameter st_receiving_response = 6'b010000;
	parameter st_return_response = 6'b100000;

	//inputs
	wire reset, CLK_SD_card, new_cmd, REQ_in, ACK_in, timeout_error, cmd_from_sd;
	wire [37:0] cmd_index_arg;
	
	//outputs
	reg REQ_out, ACK_out; 
	wire cmd_to_sd;
	reg [37:0] cmd_response;
	
	
	//other regs
	reg send_to_serial;
	reg start_to_listen;
	reg [5:0] current_st = st_inactive;
	reg finished_64_cycles;
	
	//other wires
	wire send_finished;
	wire listening_finished;
	wire [47:0] parallel_to_send;
	wire [47:0] parallel_received;
	
	//other blocks
	parallel_to_serial parallel_to_serial_1 (.CLK(CLK_SD_card), .start_sending(send_to_serial), .parallel_in(parallel_to_send), .finished(send_finished), .serial_out(cmd_to_sd));
	
	serial_to_parallel serial_to_parallel_1 (.CLK(CLK_SD_card), .start_listening(start_to_listen), .serial_in(cmd_from_sd), .finished(listening_finished), .parallel_out(parallel_received));
	
	
	//FF's and next state block
	always @ (posedge CLK_SD_card) begin
		if (reset) begin
				current_st <= st_inactive;
		end
		else begin
			current_st <= current_st;
		end
		case(current_st)
			st_inactive: begin
				if (new_cmd == 1) begin
					current_st <= st_setup;
				end
				else begin
					current_st <= current_st;
				end
			
			end
		
		
			st_setup: begin
				if (ACK_out == 1) begin
						current_st <= st_sending;
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
			st_sending: begin
				if (send_finished == 1) begin
						current_st <= st_waiting_response;
				end
				else begin
						current_st <= current_st;
				end
							
			end
		
			st_waiting_response: begin
				if (finished_64_cycles == 1) begin
						current_st <= st_receiving_response;
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
			st_receiving_response: begin
				if (listening_finished == 1) begin
						current_st <= st_return_response;
				end
				else begin
						current_st <= current_st;
				end
						
			end
		
			st_return_response: begin
				if (ACK_in == 1) begin
						current_st <= st_inactive;
				end
				else begin
						current_st <= current_st;
				end
			
			end
		
		
			default : current_st <= st_inactive;
		endcase
	
	end
	

endmodule



//////                     Other modules                             ///////



module parallel_to_serial (
	input CLK,
	input start_sending,
	input [parallel_width-1:0] parallel_in,
	
	output finished,
	output [serial_width-1:0] serial_out

);

	parameter parallel_width = 48;
	parameter serial_width = 1;
	parameter counter_size = 6; //bits needed to count from 0 to max value (parallel_width divide by serial_width)

	reg [counter_size-1:0] counter = 0;
	reg finished;
	reg [serial_width-1:0] serial_out;

	always @(posedge CLK)begin
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
	reg [parallel_width-1:0] parallel_out;
	

	always @(posedge CLK) begin
		if(start_listening) begin
			if(counter < parallel_width)begin
				parallel_out [parallel_width-1-counter -: serial_width] = serial_in;
				counter = counter + serial_width;
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
