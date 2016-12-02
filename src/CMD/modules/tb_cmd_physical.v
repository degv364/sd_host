`include "modules/CMD_physical.v"
module gm_cmd_physical (
	output reset,
	output CLK_SD_card,
	output new_cmd,
	output [37:0] cmd_index_arg,
	output REQ_in,
	output ACK_in,
	output cmd_from_sd,
	
	input REQ_out,
	input ACK_out,
	input [47:0] cmd_response,
	input cmd_to_sd,
	input timeout_error,
	input physical_inactive,
	input cmd_to_sd_oe
	
);

	reg reset = 0;
	reg CLK_SD_card = 0;
	reg new_cmd = 0;
	reg [37:0] cmd_index_arg = 38'b001110_1010_1010_1010_1010_1010_1010_1010_1010;
	reg REQ_in = 0;
	reg ACK_in = 0;
	reg cmd_from_sd = 0;


	//Read response
	reg block_start_listening = 0;
	wire block_finished;
	wire [47:0] block_parallel_out;
	initial begin
		$dumpfile("simulations/test_cmd_physical.vcd");
		$dumpvars();
		
		#2 new_cmd =1;
		#2 REQ_in = 1;
		#3 block_start_listening = 1;
		
		#226 cmd_from_sd = 1;
		#2 cmd_from_sd = 0;
		#2 cmd_from_sd = 1;
		#2 cmd_from_sd = 0;
		#2 cmd_from_sd = 1;
		#2 cmd_from_sd = 0;
		
		#92 ACK_in = 1;
		new_cmd = 0;
		
		#300 $finish;
	
	end
	
	serial_to_parallel serial_to_parallel_1 (CLK_SD_card,block_start_listening,cmd_to_sd,block_finished, block_parallel_out);
	
	always #1 CLK_SD_card = !CLK_SD_card;




endmodule

module tb_cmd_physical;

	wire reset;
	wire CLK_SD_card;
	wire new_cmd;
	wire [37:0] cmd_index_arg;
	wire REQ_in;
	wire ACK_in;
	wire timeout_error;
	wire cmd_from_sd;
		
	wire REQ_out;
	wire ACK_out;
	wire [47:0] cmd_response;
	wire cmd_to_sd;
	wire physical_inactive;
	wire cmd_to_sd_oe;

	gm_cmd_physical gm_cmd_physical_1 (.reset(reset), .CLK_SD_card(CLK_SD_card), .new_cmd(new_cmd), .cmd_index_arg(cmd_index_arg), .REQ_in(REQ_in), .ACK_in(ACK_in), .timeout_error(timeout_error), .cmd_from_sd(cmd_from_sd), .REQ_out(REQ_out), .ACK_out(ACK_out), .cmd_response(cmd_response), .cmd_to_sd(cmd_to_sd), .physical_inactive(physical_inactive),.cmd_to_sd_oe(cmd_to_sd_oe));	
	
	CMD_physical CMD_physical_1 (.reset(reset), .CLK_SD_card(CLK_SD_card), .new_cmd(new_cmd), .cmd_index_arg(cmd_index_arg), .REQ_in(REQ_in), .ACK_in(ACK_in), .timeout_error(timeout_error), .cmd_from_sd(cmd_from_sd), .REQ_out(REQ_out), .ACK_out(ACK_out), .cmd_response(cmd_response), .cmd_to_sd(cmd_to_sd), .physical_inactive(physical_inactive), .cmd_to_sd_oe(cmd_to_sd_oe) );
	
endmodule
