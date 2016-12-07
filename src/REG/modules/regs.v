// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_64(	
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input  [WIDTH-1 : 0] enb,	//Para saber donde puedo escribir

input clk,	// clock
input reset	// Devuelve a cero
);

parameter WIDTH = 64;

reg [WIDTH-1 : 0] rd_data;

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	
	else begin
		rd_data <= rd_data & ~enb| wr_data & enb;
	end

end

endmodule
// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_32(	
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input  [WIDTH-1 : 0] enb,	//Para saber donde puedo escribir

input clk,	// clock
input reset	// Devuelve a cero
);

parameter WIDTH = 32;

reg [WIDTH-1 : 0] rd_data;


always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	
	else begin
		rd_data <= rd_data & ~enb | wr_data & enb;
	end

end

endmodule
// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_16(	
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input  [WIDTH-1 : 0] enb,	//Para saber donde puedo escribir

input clk,	// clock
input reset	// Devuelve a cero
);

parameter WIDTH = 16;

reg [WIDTH-1 : 0] rd_data;


always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	
	else begin
		rd_data <= rd_data & ~enb | wr_data & enb;
	end

end

endmodule

// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_8(	
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input  [WIDTH-1 : 0] enb,	//Para saber donde puedo escribir

input clk,	// clock
input reset	// Devuelve a cero
);

parameter WIDTH = 8;

reg [WIDTH-1 : 0] rd_data;



always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	
	else begin
		rd_data <= rd_data & ~enb | wr_data & enb;
	end

end

endmodule
