module gm_cmd_master(

	output reset,
	output CLK_host,
	output new_cmd,
	output cmd_error,
	output ACK_in,
	output REQ_in,
	output [31:0] cmd_arg,
	output [5:0] cmd_index, 
	output [15:0]timeout_value,
	output [37:0] cmd_response,

	input cmd_busy,
	input cmd_complete,
	input cmd_index_error,
	input REQ_out,
	input ACK_out,
	input timeout_error,
	input [31:0]response_arg,
	input [5:0]response_index,
	input [37:0]cmd_out
	);
	
	reg reset=0;
	reg CLK_host=0;
	reg new_cmd=0;
	reg cmd_error=0;
	reg ACK_in=0;
	reg REQ_in=0;
	reg [31:0] cmd_arg=0;
	reg [5:0] cmd_index=0; 
	reg [15:0]timeout_value=0;
	reg [37:0] cmd_response=0;
	
	
	initial begin
		$dumpfile("test.vcd");
		$dumpvars();
		
		#2 new_cmd =1;
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
	wire [15:0]timeout_value;
	wire [37:0] cmd_response;

	wire cmd_busy, cmd_complete,cmd_index_error,REQ_out,ACK_out,timeout_error;
	wire [31:0]response_arg;
	wire [5:0]response_index;
	wire [37:0]cmd_out;
	
	gm_cmd_master generator(reset, CLK_host, new_cmd, cmd_error, ACK_in, REQ_in, cmd_arg, cmd_index, timeout_value, cmd_response, cmd_busy, cmd_complete, cmd_index_error, REQ_out, ACK_out, timeout_error, response_arg,  response_index,cmd_out);
	
	CMD_master test_master(reset, CLK_host, new_cmd, cmd_error, ACK_in, REQ_in, cmd_arg, cmd_index, timeout_value, cmd_response, cmd_busy, cmd_complete, cmd_index_error, REQ_out, ACK_out, timeout_error, response_arg,  response_index,cmd_out);


endmodule
