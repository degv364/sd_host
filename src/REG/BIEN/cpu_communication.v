module cpu_com(
output[WIDTH-1 : 0] rd_data_32,

output [WIDTH/2 -1: 0] rd_data_16,

output [WIDTH-4 -1: 0] rd_data_8,

output acknowledge,

input [WIDTH-1 : 0] wr_data_32,

input [WIDTH/2 -1: 0] wr_data_16,

input [WIDTH/2 -1: 0] wr_data_8,

input [4096:0] addrs,
input wr_data,

input req,
input wr_valid,

input clk
);
reg rd_


req = 0;

always @(*)
	if(req != 0) begin
		busy = 1;
	end
	else begin
		busy = 0;
	end

	if(busy == 0) begin
		acknowledge = 1;
	end

always @(posedge clk)
	if(req == 1)begin
		
		if(wr_valid == 1) begin
			case (addrs)
			16'h04				
				
			endcase
		end

		else begin
			case (addrs)

			endcase 
		end
	
	end
	

	else begin
	
	end
endmodule
