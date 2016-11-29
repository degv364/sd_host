`include "CMD_TLB.v"

module gm_CMD_TLB (
	output reset, 
	output CLK_host,
	output new_cmd,
	output [31:0] cmd_arg,
	output [5:0] cmd_index, 
	output [15:0]timeout_value,
	output cmd_from_sd,
	output CLK_SD_card,

	input cmd_busy,
	input cmd_complete,
	input timeout_error,
	input [31:0]response_arg,
	input [5:0]response_index,
	input cmd_to_sd

);

	reg reset=0;
	reg CLK_host=0;
	reg new_cmd=0;
	reg [31:0] cmd_arg=32'b0110_0110_0110_0110_0110_0110_0110_0110;
	reg [5:0] cmd_index=6'b100_001;
	reg [15:0]timeout_value=16'b0000_0000_1100_1000;
	reg cmd_from_sd=0;
	reg CLK_SD_card=0;

	initial begin
		$dumpfile("simulations/test_cmd_tlb.vcd");
		$dumpvars();
		
		#2 new_cmd =1;
				
		
		
		#300 $finish;
	
	end
	
	always #2 CLK_SD_card = !CLK_SD_card;
	always #1 CLK_host = !CLK_host;



endmodule


module tb_cmd_tlb();
	wire reset;
	wire CLK_host;
	wire new_cmd;
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire [15:0]timeout_value;
	wire cmd_from_sd;
	wire CLK_SD_card;

	wire cmd_busy;
	wire cmd_complete;
	wire timeout_error;
	wire [31:0]response_arg;
	wire [5:0]response_index;
	wire cmd_to_sd;
	
	CMD_tlb CMD_tlb_1 (.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .timeout_value(timeout_value), .cmd_from_sd(cmd_from_sd), .CLK_SD_card(CLK_SD_card), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .timeout_error(timeout_error), .response_arg(response_arg), .response_index(response_index), .cmd_to_sd(cmd_to_sd) );
	
	gm_CMD_TLB gm_CMD_TLB_1 (.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .timeout_value(timeout_value), .cmd_from_sd(cmd_from_sd), .CLK_SD_card(CLK_SD_card), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .timeout_error(timeout_error), .response_arg(response_arg), .response_index(response_index), .cmd_to_sd(cmd_to_sd) );


endmodule


