module cpu_reg_communication(
output[31:0] rd_data,
output acknowledge, 
//output [WIDTH/2 -1: 0] rd_data_16,

//output [WIDTH-4 -1: 0] rd_data_8,

//output acknowledge,
input [31:0] wr_data,

//


//
output [31:0] out_004h,
output [31:0] out_006h,
output [31:0] out_008h,
output [31:0] out_00Ah,
output [31:0] out_00Eh,
output [31:0] out_010h,
output [31:0] out_012h,
output [31:0] out_02Ah,
output [31:0] out_032A,
//
input [31:0] in_004h,
input [31:0] in_006h,
input [31:0] in_008h,
input [31:0] in_00Ah,
input [31:0] in_00Eh,
input [31:0] in_010h,
input [31:0] in_012h,
input [31:0] in_024h,
input [31:0] in_02Ah,
input [31:0] in_030h,
input [31:0] in_032h,
input [31:0] in_054h,

//

input [12:0] addrs,
input req,
input wr_valid,
input clk
);

reg busy = 0;
reg acknowledge = 0;

reg [31:0] rd_data;

reg [31:0] out_004h;
reg [31:0] out_006h;
reg [31:0] out_008h;
reg [31:0] out_00Ah;
reg [31:0] out_00Eh;
reg [31:0] out_010h;
reg [31:0] out_012h;
reg [31:0] out_02Ah;
reg [31:0] out_032A;

always @(*)begin
	if(req == 1) begin
		busy <= 1;
	end
	else begin
		busy <= 0;
	end

	if(busy == 0) begin
		acknowledge <= 1;
	end

	else begin
		acknowledge <= 1;
	end
end
always @(posedge clk)
if(req == 1)begin
		
	if(wr_valid == 1) begin
			case (addrs)
				12'h004 : out_004h <= wr_data;
				12'h006 : out_006h <= wr_data;
				12'h008 : out_008h <= wr_data;
				12'h00A : out_00Ah <= wr_data;
				12'h00E : out_00Eh <= wr_data;
				12'h010 : out_010h <= wr_data;
				12'h012 : out_012h <= wr_data;
				12'h02A : out_02Ah <= wr_data; 
				12'h032 : out_032A <= wr_data;
				default : acknowledge = 0;//nada 
			endcase
		end

		else begin
			case (addrs)
				12'h004 : rd_data <= in_004h;
				12'h006 : rd_data <= in_006h;
				12'h008 : rd_data <= in_008h;
				12'h00A : rd_data <= in_00Ah;
				12'h00E : rd_data <= in_00Eh;
				12'h010 : rd_data <= in_010h;
				12'h012 : rd_data <= in_012h;
				12'h024 : rd_data <= in_024h;
				12'h02A : rd_data <= in_02Ah;
				12'h030 : rd_data <= in_030h;
				12'h032 : rd_data <= in_032h;
				12'h054 : rd_data <= in_054h;

				default : acknowledge = 0; //nada
			endcase			
		end
end	
endmodule
