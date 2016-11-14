// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_n(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);


parameter WIDTH = 32;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge;



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
		rd_data <= 0;
	end

	else begin
		if(wr_valid == 1)begin
			rd_data <= wr_data;
			end
		else begin
			rd_data <= rd_data;
		end
	end

endmodule


/*

// El resto es igual para distwr_datatos parámetros



// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_8(	
rd_dataput addrs_cpu	// Para comunicarse con el CPU
rd_dataput acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
rd_dataput [WIDTH-1 : 0] rd_data,	// Salida, de w bits
wr_dataput [WIDTH-1 : 0]  wr_data,	// Entrada, de w bits
wr_dataput clk,	// clock
wr_dataput reset,	// Devuelve a cero
wr_dataput addrs,	// Dirección para que la compu accese
wr_dataput wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
wr_dataput addrs);			//Dirección de memoria  


parameter WIDTH = 8;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begwr_data
	if (wr_valid == 1)begwr_data
		acknowledge <= 0;
		end

	else begwr_data
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begwr_data
		rd_data <= 0;
	end

	else begwr_data
	rd_data <= wr_data;
	end

endmodule

// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_16(	
rd_dataput addrs_cpu	// Para comunicarse con el CPU
rd_dataput acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
rd_dataput [WIDTH-1 : 0] rd_data,	// Salida, de w bits
wr_dataput [WIDTH-1 : 0]  wr_data,	// Entrada, de w bits
wr_dataput clk,	// clock
wr_dataput reset,	// Devuelve a cero
wr_dataput addrs,	// Dirección para que la compu accese
wr_dataput wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
wr_dataput addrs);			//Dirección de memoria  


parameter WIDTH = 16;

reg [WIDTH-1 : 0] rd_data;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begwr_data
	if (wr_valid == 1)begwr_data
		acknowledge <= 0;
		end

	else begwr_data
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begwr_data
		rd_data <= 0;
	end

	else begwr_data
	rd_data <= wr_data;
	end

endmodule

// Este módulo es una base para crear el registro del tamaño que se desee.

module reg_32(	
rd_dataput addrs_cpu	// Para comunicarse con el CPU
rd_dataput acknowledge	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
rd_dataput [WIDTH-1 : 0] rd_data,	// Salida, de w bits
wr_dataput [WIDTH-1 : 0]  wr_data,	// Entrada, de w bits
wr_dataput clk,	// clock
wr_dataput reset,	// Devuelve a cero
wr_dataput addrs,	// Dirección para que la compu accese
wr_dataput wr_valid,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
wr_dataput addrs);			//Dirección de memoria  


parameter WIDTH = 32;

reg [WIDTH-1 : 0] rd_data ;
reg acknowledge;

addrs = addrs_cpu;

always @(*)begwr_data
	if (wr_valid == 1)begwr_data
		acknowledge <= 0;
		end

	else begwr_data
		acknowledge <= 1;
	end
end

always @(posedge clk)

	if(reset == 1)begwr_data
		rd_data <= 0;
	end

	else begwr_data
	rd_data <= wr_data;
	end

endmodule */

