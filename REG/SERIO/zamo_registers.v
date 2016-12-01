module Present_State_Register(
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
output busy,			//Alguien está escribiendo 

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);
parameter wIDTH = 32;
	reg_32	reg_PSR(.clk(clk),.reset(reset),.wr_data(wr_data),.wr_valid(wr_valid),.rd_data(rd_data));
endmodule

module Normal_Interrupt_Status_Register(
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
output busy,			//Alguien está escribiendo 

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);
parameter WIDTH = 8;
	reg_8 reg_NISR(.clk(clk),.reset(reset),.wr_data(wr_data),.wr_valid(wr_valid))
endmodule
