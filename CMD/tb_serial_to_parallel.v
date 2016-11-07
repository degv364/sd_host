module gm_serial_to_parallel(

	output CLK,
	output start_listening_nxt_cycle,
	output serial_in,
		
	
	input finished,
	input [47:0] parallel_out

	
	);
	
	reg CLK = 0;
	reg start_listening_nxt_cycle = 0;
	reg serial_in = 0;
	
	
	initial begin
		$dumpfile("simulations/test_serial_to_parallel.vcd");
		$dumpvars();
		
		#3 start_listening_nxt_cycle =1;
		
		#4 serial_in = 1;
		#88 serial_in =0;
		#12 $finish;
	
	end
	
	
	
	always #1 CLK = !CLK;

endmodule

module tb_serial_to_parallel;

	wire CLK;
	wire start_listening_nxt_cycle;
	wire [47:0] parallel_out;
	wire finished;
	wire serial_in;
	
	gm_serial_to_parallel test (CLK, start_listening_nxt_cycle, serial_in, finished, parallel_out);
	serial_to_parallel dut (CLK, start_listening_nxt_cycle, serial_in, finished, parallel_out);
	
	


endmodule
