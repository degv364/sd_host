// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_32(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
output busy,			//Alguien está escribiendo 

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 32;

reg busy = 0;
reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;
//reg [WIDTH-1 :0] mask = 32'h0000_0000;



always @(*)begin
	if(wr_valid == 1)begin
		busy = 1;
	end

	else begin
		busy = 0;
	end
	
	if(rd_data == wr_data)begin
		acknowledge = 1;
	end
	else begin
		acknowledge = 0;
	end
	
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(wr_valid == 1)begin
			rd_data  <= wr_data;
		end	
		else begin
			// Nada
		end
	end
end
endmodule

// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_16(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
output busy,			//Alguien está escribiendo 

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 16;

reg busy = 0;
reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;



always @(*)begin
	if(wr_valid == 1)begin
		busy = 1;
	end

	else begin
		busy = 0;
	end
	
	if(rd_data == wr_data)begin
		acknowledge = 1;
	end
	else begin
		acknowledge = 0;
	end
	
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(wr_valid == 1)begin
			rd_data  <= wr_data;
		end	
		else begin
			// Nada
		end
	
	end
end
endmodule

// Este módulo es una base para crear el registro del tamaño que se desee. De modo que existen reg_8, reg_16 y reg_32

module reg_8(	
output acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits
output busy,			//Alguien está escribiendo 

input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input clk,	// clock
input reset,	// Devuelve a cero
input wr_valid	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 32;

reg busy = 0;
reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;



always @(*)begin
	if(wr_valid == 1)begin
		busy = 1;
	end

	else begin
		busy = 0;
	end
	
	if(rd_data == wr_data)begin
		acknowledge = 1;
	end
	else begin
		acknowledge = 0;
	end
	
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(wr_valid == 1)begin
			rd_data  <= wr_data;
		end	
		else begin
			// Nada
		end
	
	end
end
endmodule

