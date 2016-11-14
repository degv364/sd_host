// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_n(	
output addrs_cpu,	// Para comunicarse con el CPU
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] out,	// Salida, de w bits
input  [WIDTH-1 : 0]  in,	// Entrada, de w bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
input addrs);			//Dirección de memoria  


parameter WIDTH = 8;

reg [WIDTH-1 : 0] out;
reg acknowledge;

assign addrs = addrs_cpu;

always @(*)begin
	if (wr_valid == 1)begin
		acknowledge <= 0;
		end

	else begin
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begin
		out <= 0;
	end

	else begin
	out <= in;
	end

endmodule


// El resto es igual para distintos parámetros

/*

// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_8(	
output addrs_cpu	// Para comunicarse con el CPU
output acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] out,	// Salida, de w bits
input [WIDTH-1 : 0]  in,	// Entrada, de w bits
input clk,	// clock
input reset,	// Devuelve a cero
input addrs,	// Dirección para que la compu accese
input wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
input addrs);			//Dirección de memoria  


parameter WIDTH = 8;

reg [WIDTH-1 : 0] out;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begin
	if (wr_valid == 1)begin
		acknowledge <= 0;
		end

	else begin
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begin
		out <= 0;
	end

	else begin
	out <= in;
	end

endmodule

// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_16(	
output addrs_cpu	// Para comunicarse con el CPU
output acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] out,	// Salida, de w bits
input [WIDTH-1 : 0]  in,	// Entrada, de w bits
input clk,	// clock
input reset,	// Devuelve a cero
input addrs,	// Dirección para que la compu accese
input wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
input addrs);			//Dirección de memoria  


parameter WIDTH = 16;

reg [WIDTH-1 : 0] out;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begin
	if (wr_valid == 1)begin
		acknowledge <= 0;
		end

	else begin
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begin
		out <= 0;
	end

	else begin
	out <= in;
	end

endmodule

// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_32(	
output addrs_cpu	// Para comunicarse con el CPU
output acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] out,	// Salida, de w bits
input [WIDTH-1 : 0]  in,	// Entrada, de w bits
input clk,	// clock
input reset,	// Devuelve a cero
input addrs,	// Dirección para que la compu accese
input wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
input addrs);			//Dirección de memoria  


parameter WIDTH = 32;

reg [WIDTH-1 : 0] out;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begin
	if (wr_valid == 1)begin
		acknowledge <= 0;
		end

	else begin
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begin
		out <= 0;
	end

	else begin
	out <= in;
	end

endmodule
*/