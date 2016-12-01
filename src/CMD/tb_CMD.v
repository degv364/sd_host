`include "CMD.v"

module gm_CMD (
	output reset, 
	output CLK_host,
	output new_cmd,
	output [31:0] cmd_arg,
	output [5:0] cmd_index, 
	output cmd_from_sd,
	output CLK_SD_card,

	input cmd_busy,
	input cmd_complete,
	input timeout_error,
	input [31:0]response_status,
	input cmd_to_sd,
	input cmd_to_sd_oe

);

	reg reset=0;
	reg CLK_host=0;
	reg new_cmd=0;
	reg [31:0] cmd_arg=32'b0110_0110_0110_0110_0110_0110_0110_0110;
	reg [5:0] cmd_index=6'b100_001;
	reg cmd_from_sd=1;
	reg CLK_SD_card=0;
	
	
	//Parallel_to_serial needed regs and wires
	reg start_sending = 0;
	reg [47:0] cmd_response = 48'h3AFA_CACA_DEF3;
	wire finished_parallel_to_serial;
	wire serial_out;

	//Parallel to serial block for response
	parallel_to_serial parallel_to_serial_1 (.CLK(CLK_SD_card), .start_sending(start_sending), .parallel_in(cmd_response), .finished(finished_parallel_to_serial), .serial_out(serial_out) );



	//Parallel to serial block for response
	reg start_listening = 0;
	wire finished_serial_to_parallel;	
	wire [47:0] parallel_out;
	
	//Serial to parallel
	serial_to_parallel serial_to_parallel (.CLK(CLK_SD_card), .start_listening(start_listening), .serial_in(cmd_to_sd), .finished(finished_serial_to_parallel), .parallel_out(parallel_out));
		


	initial begin
		$dumpfile("simulations/test_cmd_tlb.vcd");
		$dumpvars();
		
		#2 new_cmd =1;
				
		
		#228 start_sending = 1;
		
		
		#500 $finish;
	
	end
	
	always #2 CLK_SD_card = !CLK_SD_card;
	always #1 CLK_host = !CLK_host;

	always @(*) begin
		if (start_sending == 1) begin
			cmd_from_sd = serial_out;
		end
		else begin
			cmd_from_sd = 1;
		end
		
		if (finished_serial_to_parallel) begin
			start_listening = 0;
		end
		else begin
			start_listening = start_listening;
		end
	
		if (cmd_to_sd_oe) begin
			start_listening = 1'b1;
		end
		else begin
			start_listening = 1'b0;
		end
	
	end


endmodule


module tb_cmd_tlb();
	wire reset;
	wire CLK_host;
	wire new_cmd;
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire cmd_from_sd;
	wire CLK_SD_card;

	wire cmd_busy;
	wire cmd_complete;
	wire timeout_error;
	wire [31:0]response_status;
	wire cmd_to_sd;
	wire cmd_to_sd_oe;
	
	CMD CMD_1 (.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .cmd_from_sd(cmd_from_sd), .CLK_SD_card(CLK_SD_card), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .timeout_error(timeout_error), .response_status(response_status), .cmd_to_sd(cmd_to_sd), .cmd_to_sd_oe(cmd_to_sd_oe) );
	
	gm_CMD gm_CMD_1 (.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .cmd_from_sd(cmd_from_sd), .CLK_SD_card(CLK_SD_card), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .timeout_error(timeout_error), .response_status(response_status), .cmd_to_sd(cmd_to_sd), .cmd_to_sd_oe(cmd_to_sd_oe) );


endmodule


