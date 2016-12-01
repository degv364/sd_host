`include "modules/CMD_master.v"
module gm_cmd_master(

	output reset,
	output CLK_host,
	output new_cmd,
	output ACK_in,
	output REQ_in,
	output physical_waiting_cmd,
	output [31:0] cmd_arg,
	output [5:0] cmd_index, 
	output [47:0] cmd_response,
	output timeout_error_from_physical,

	input cmd_busy,
	input cmd_complete,
	input REQ_out,
	input ACK_out,
	input timeout_error,
	input [31:0]response_status,
	input [37:0]cmd_to_physical
	);
	
	reg reset=0;
	reg CLK_host=0;
	reg new_cmd=0;
	reg cmd_error=0;
	reg ACK_in=0;
	reg REQ_in=0;
	reg physical_waiting_cmd = 0;
	reg [31:0] cmd_arg=0;
	reg [5:0] cmd_index=0; 
	reg [15:0]timeout_value=0;
	reg [47:0] cmd_response=0;
	
	
	initial begin
		$dumpfile("simulations/test_cmd_master.vcd");
		$dumpvars();
		
		#2 new_cmd =1;
		//physical_waiting_cmd = 1;
		cmd_index = 6'b111_111;
		cmd_arg = 32'hAAAA_AAAA;
		timeout_value = 15;
		#8 cmd_response =38'b111001_0111_0110_0101_0100_0011_0010_0001_0000;
		#1 ACK_in = 1;
		#4 REQ_in =1;
		
		
		#5 $finish;
	
	end
	
	always #1 CLK_host = !CLK_host;

endmodule

module tb_cmd_master;

	wire reset, CLK_host, new_cmd,cmd_error, ACK_in, REQ_in;
	wire [31:0] cmd_arg;
	wire [5:0] cmd_index; 
	wire timeout_error_from_physical;
	wire [47:0] cmd_response;

	wire cmd_busy, cmd_complete,cmd_index_error,REQ_out,ACK_out,timeout_error;
	wire [31:0]response_status;
	wire [37:0]cmd_to_physical;
	
	gm_cmd_master generator(reset, CLK_host, new_cmd, ACK_in, REQ_in, physical_waiting_cmd, cmd_arg, cmd_index, cmd_response, timeout_error_from_physical, cmd_busy, cmd_complete, REQ_out, ACK_out, timeout_error, response_status,cmd_to_physical);
	
	CMD_master test_master(reset, CLK_host, new_cmd, ACK_in, REQ_in, physical_waiting_cmd, cmd_arg, cmd_index, cmd_response, timeout_error_from_physical, cmd_busy, cmd_complete, REQ_out, ACK_out, timeout_error, response_status,cmd_to_physical);


endmodule
