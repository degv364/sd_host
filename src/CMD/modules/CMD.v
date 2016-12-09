`include "modules/CMD_physical.v"
`include "modules/CMD_master.v"


`ifndef CMD
`define CMD
module CMD (
	input reset, 
	input CLK_host,
	input new_cmd,
	input [31:0] cmd_arg,
	input [5:0] cmd_index,
	input cmd_from_sd,
	input CLK_SD_card,

	output cmd_busy,
	output cmd_complete,
	output timeout_error,
	output [31:0] response_status,
	output cmd_to_sd,
	output cmd_to_sd_oe,
	output cmd_busy_en,
	output cmd_complete_en,
	output timeout_error_en,
	output [31:0] response_status_en
		
);
	//inputs and outputs wires
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire [31:0]response_status;
	wire reset, CLK_host, new_cmd, CLK_SD_card, cmd_busy, cmd_complete, cmd_index_error, timeout_error, cmd_from_sd, cmd_to_sd_oe;
	reg cmd_to_sd;
	wire cmd_busy_en;
	wire cmd_complete_en;
	wire timeout_error_en;
	wire [31:0] response_status_en;
	
	
	
	
	//internal wires
	wire REQ_master, ACK_master,REQ_physical, ACK_physical, physical_inactive, timeout_error_from_physical, cmd_to_sd_from_physical;
	wire [47:0] cmd_response; 
	wire [37:0] cmd_to_physical;
	wire new_cmd_to_physical;
	
	//Modules
	CMD_master CMD_master_1(.reset(reset), .CLK_host(CLK_host), .new_cmd(new_cmd), .ACK_in(ACK_physical), .REQ_in(REQ_physical), .physical_inactive(physical_inactive), .cmd_arg(cmd_arg), .cmd_index(cmd_index), .cmd_response(cmd_response), .timeout_error_from_physical(timeout_error_from_physical), .cmd_busy(cmd_busy), .cmd_complete(cmd_complete), .REQ_out(REQ_master), .ACK_out(ACK_master), .timeout_error(timeout_error), .response_status(response_status), .cmd_to_physical(cmd_to_physical), .cmd_busy_en(cmd_busy_en), .cmd_complete_en(cmd_complete_en), .timeout_error_en(timeout_error_en), .response_status_en(response_status_en), .new_cmd_to_physical(new_cmd_to_physical) );
	
	CMD_physical CMD_physical_1 (.reset(reset), .CLK_SD_card(CLK_SD_card), .new_cmd(new_cmd_to_physical), .cmd_index_arg(cmd_to_physical), .REQ_in(REQ_master), .ACK_in(ACK_master), .cmd_from_sd(cmd_from_sd), .REQ_out(REQ_physical), .ACK_out(ACK_physical), .cmd_response(cmd_response), .cmd_to_sd(cmd_to_sd_from_physical), .timeout_error(timeout_error_from_physical), .physical_inactive(physical_inactive), .cmd_to_sd_oe(cmd_to_sd_oe) );
	
	//Comb for cmd_to_sd_oe
	always @(*) begin
		if (cmd_to_sd_oe) begin
			cmd_to_sd = cmd_to_sd_from_physical;
		end
		else begin
			cmd_to_sd = 1'b1;
		end
	
	
	end




endmodule
`endif
