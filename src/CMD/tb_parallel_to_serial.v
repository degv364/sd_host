module gm_parallel_to_serial(

	output CLK,
	output start_sending,
	output [47:0] parallel_in,
	
	input finished,
	input serial_out

	
	);
	
	reg CLK = 0;
	reg start_sending = 0;
	reg [47:0] parallel_in = 48'hAAAB_AAAA_AAAF;
	
	
	initial begin
		$dumpfile("simulations/test_parallel_to_serial.vcd");
		$dumpvars();
		
		#2 start_sending =1;
		
		
		
		#105 $finish;
	
	end
	
	always @ (*) begin
		if (finished)
			start_sending = 0;
	end
	
	always #1 CLK = !CLK;

endmodule

module tb_parallel_to_serial;

	wire CLK;
	wire start_sending;
	wire [47:0] parallel_in;
	wire finished;
	wire serial_out;
	
	gm_parallel_to_serial test (CLK, start_sending, parallel_in, finished, serial_out);
	parallel_to_serial dut (CLK, start_sending, parallel_in, finished, serial_out);
	
	


endmodule
