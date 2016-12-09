module cpu_reg_communication(
 output [31:0] rd_data,
 output        acknowledge, 
//output [WIDTH/2 -1: 0] rd_data_16,

//output [WIDTH-4 -1: 0] rd_data_8,

//output acknowledge,
 input [31:0]  wr_data,

//


//

output [31:0] out_004h,
output [31:0] out_006h,
output [31:0] out_008h,
output [31:0] out_00Ah,
output [31:0] out_00Ch, 
output [31:0] out_00Eh,
output [31:0] out_010h,
output [31:0] out_012h,
output [31:0] out_024h, // La compu no escribe en este registro
output [31:0] out_02Ah,
output [31:0] out_030h, // La compu no escribe en este registro
output [31:0] out_032h,
output [31:0] out_054h,

output [11:0] enb,

//
 input [31:0]  in_004h,
 input [31:0]  in_006h,
 input [31:0]  in_008h,
 input [31:0]  in_00Ah,
 input [31:0]  in_00Ch, 
 input [31:0]  in_00Eh,
 input [31:0]  in_010h,
 input [31:0]  in_012h,
 input [31:0]  in_024h,
 input [31:0]  in_02Ah,
 input [31:0]  in_030h,
 input [31:0]  in_032h,
 input [31:0]  in_054h,

//

input [11:0] addrs,
input req,
input wr_valid

);

reg busy = 0;
reg acknowledge = 0;

   reg [31:0] rd_data;

reg [31:0] out_004h = 0;
reg [31:0] out_006h = 0;
reg [31:0] out_008h = 0;
reg [31:0] out_00Ah = 0;
reg [31:0] out_00Ch = 0;
reg [31:0] out_00Eh = 0;
reg [31:0] out_010h = 0;
reg [31:0] out_012h = 0;
reg [31:0] out_024h = 0;
reg [31:0] out_02Ah = 0;
reg [31:0] out_030h = 0;
reg [31:0] out_032h = 0;
reg [31:0] out_054h = 0;

reg [11:0] enb;

always @(*)begin
enb = 16'b0000_0000_0000_0000;

out_004h=31'h0000_0000;
out_006h=31'h0000_0000;
out_008h=31'h0000_0000;
out_00Ah=31'h0000_0000;
out_00Eh=31'h0000_0000;
out_010h=31'h0000_0000;
out_012h=31'h0000_0000;
out_024h=31'h0000_0000; // La compu no escribe en este registro
out_02Ah=31'h0000_0000;
out_030h=31'h0000_0000; // La compu no escribe en este registro
out_032h=31'h0000_0000;
out_054h=31'h0000_0000;

	if(req == 1) begin
		busy = 1;
		if(wr_valid == 1) begin


			case (addrs)

				12'h004 : begin
					 out_004h = wr_data;
					 enb = 16'b0000_0000_0000_0001;	
				end
				12'h006 : begin
					out_006h = wr_data;
					enb = 16'b0000_0000_0000_0010;	
				end
				12'h008 : begin
					out_008h = wr_data;
					enb = 16'b0000_0000_0000_0100;	
				end
				12'h00A : begin
					out_00Ah = wr_data;
					enb = 16'b0000_0000_0000_1000;	
				end

			   	12'h00C : begin
					out_00Ch = wr_data;
					enb = 16'b0000_0000_0001_0000;	
				end
				12'h00E : begin
					out_00Eh = wr_data;
					enb = 16'b0000_0000_0010_0000;	
				end
				12'h010 : begin 
					 out_010h = wr_data;
					 enb = 16'b0000_0000_0100_0000;	
				end
				12'h012 : begin
					 out_012h = wr_data;
					 enb = 16'b0000_0000_1000_0000;	
				end

				12'h024 : begin
					// La compu no escribe en este registro
					 enb = 16'b0000_0001_0000_0000;	
				end

				12'h02A : begin
					 out_02Ah = wr_data; 
					 enb = 16'b0000_0010_0000_0000;	
				end

				12'h030 : begin
					// La compu no escribe en este registro
					 enb = 16'b0000_0100_0000_0000;	
				end

				12'h032 : begin
					 out_032h = wr_data;
					 enb = 16'b0000_1000_0000_0000;	
				end

				12'h054 : begin
					 out_054h = wr_data;
					 enb = 16'b0001_0000_0000_0000;
				end
	
				default : begin
					 acknowledge = 0;//nada 
					 enb = 16'b0000_0000_0000_0000;
				end
				

			endcase
		end
	end
		else begin
			busy = 0;
			case (addrs)

				12'h004 : rd_data = in_004h;
				12'h006 : rd_data = in_006h;
				12'h008 : rd_data = in_008h;
				12'h00A : rd_data = in_00Ah;
			   	12'h00C : rd_data = in_00Ch;
				12'h00E : rd_data = in_00Eh;
				12'h010 : rd_data = in_010h;
				12'h012 : rd_data = in_012h;
				12'h024 : rd_data = in_024h;
				12'h02A : rd_data = in_02Ah;
				12'h030 : rd_data = in_030h;
				12'h032 : rd_data = in_032h;
				12'h054 : rd_data = in_054h;
				default : begin 
						rd_data = 32'h0000; //nada
					  	acknowledge = 0;
						enb = 16'b0000_0000_0000_0000;
					  end

				endcase			

			end
						

	if(busy == 0) begin
		acknowledge <= 1;
	end

	else begin
		acknowledge <= 1;
	end
end
endmodule
