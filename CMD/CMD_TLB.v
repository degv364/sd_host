`include "CMD_physical.v"
`include "CMD_master.v"


`ifndef CMD_TLB
`define CMD_TLB
module CMD_tlb (
	input reset, 
	input CLK_host,
	input new_cmd,
	input [31:0] cmd_arg,
	input [5:0] cmd_index, 
	input [15:0]timeout_value,
	input cmd_from_sd,
	input CLK_SD_card,

	output cmd_busy,
	output cmd_complete,
	output timeout_error,
	output [31:0]response_arg,
	output [5:0]response_index,
	output cmd_to_sd
		
);
	//inputs and outputs wires
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire [15:0]timeout_value;
	wire [31:0]response_arg;
	wire [5:0]response_index;
	wire reset, CLK_host, new_cmd, CLK_SD_card, cmd_busy, cmd_complete, cmd_index_error, timeout_error, cmd_from_sd, cmd_to_sd;
	
	//internal wires
	wire REQ_master, ACK_master,REQ_physical, ACK_physical, physical_inactive;
	wire [37:0] cmd_response, cmd_to_physical;
	
	//Modules
	CMD_master CMD_master_1(.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .ACK_in(ACK_physical), .REQ_in(REQ_physical), .physical_inactive(physical_inactive), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .timeout_value(timeout_value), .cmd_response(cmd_response), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .REQ_out(REQ_master), .ACK_out(ACK_out), .timeout_error(timeout_error), .response_arg(response_arg), .response_index(response_index), .cmd_to_physical(cmd_to_physical) );
	
	CMD_physical CMD_physical_1 (.reset(reset), .CLK_SD_card(CLK_SD_card), .new_cmd(new_cmd), .cmd_index_arg(cmd_to_physical), .REQ_in(REQ_master), .ACK_in(ACK_master), .timeout_error(timeout_error), .cmd_from_sd(cmd_from_sd), .REQ_out(REQ_physical), .ACK_out(ACK_physical), .cmd_response(cmd_response), .cmd_to_sd(cmd_to_sd), .physical_inactive(physical_inactive) );




endmodule
`endif
