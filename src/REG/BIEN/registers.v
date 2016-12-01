// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_wr(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 32;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;
reg [31:0] mask = 32'h0000_0000;

always @(*)begin
	if(wr_valid == 1)begin
		acknowledge = 0;
		mask = 32'hXXXX_XXXX;
	end
	else begin
		acknowledge = 1;
		mask = 32'hFFFF_FFFF;
	end
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(acknowledge == 0)begin
			rd_data <=  32'hXXXX_XXXX;
			end
	
		else begin
			rd_data  <= mask & wr_data;
		end
	end
end

endmodule

module reg_004h(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output	[WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
input	[11 : 0] transfer_block,	// Entrada, de WIDTH bits
input	[14 :12] Host_SDMA,
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 16;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;
reg [WIDTH-1 :0] mask = 12'h000;

wire [WIDTH-2 : 0] wr_data;

assign wr_data [11:0] = transfer_block ;
assign wr_data [14:12] = Host_SDMA ;
//assign rd_data [15] = 1'b0;


always @(*)begin
	if(wr_valid == 1)begin
		acknowledge = 0;
		mask = 16'b0XXX_XXXX_XXXX_XXXX;
	end
	else begin
		acknowledge = 1;
		mask = 16'hEFFF;
	end
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(acknowledge == 0)begin
			rd_data <=  16'hXXXX;
			rd_data[15]<=1'b0;
			end
	
		else begin
			rd_data  <= mask & wr_data;
		end
	end
end

endmodule

module reg_006h(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 16;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;
reg [31:0] mask = 32'h0000_0000;

always @(*)begin
	if(wr_valid == 1)begin
		acknowledge = 0;
		mask = 32'hXXXX_XXXX;
	end
	else begin
		acknowledge = 1;
		mask = 32'hFFFF_FFFF;
	end
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(acknowledge == 0)begin
			rd_data <=  32'hXXXX_XXXX;
			end
	
		else begin
			rd_data  <= mask & wr_data;
		end
	end
end

endmodule

module reg_008h(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 32;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;
reg [WIDTH-1:0] mask = 32'h0000_0000;

always @(*)begin
	if(wr_valid == 1)begin
		acknowledge = 0;
		mask = 32'hXXXX_XXXX;
	end
	else begin
		acknowledge = 1;
		mask = 32'hFFFF_FFFF;
	end
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(acknowledge == 0)begin
			rd_data <=  32'hXXXX_XXXX;
			end
	
		else begin
			rd_data  <= mask & wr_data;
		end
	end
end

endmodule

