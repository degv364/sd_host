module selector(
output [WIDTH-1 : 0] rd_data,	// Salida, de  WIDTH bits	
input acknowledge,	// acknowledge (1- Dato Confiable, 0 - Dato no confiable )
input busy,
input  [WIDTH-1 : 0] wr_data,	// Entrada, de WIDTH bits
input req,	// clock
input wr_valid,	// Devuelve a cero
input register,	// Bandera de Escritura (1 - Estoy escribiendo, 0 - Está libre )
);

parameter WIDTH = 8;

reg busy = 0;
reg [WIDTH-1 : 0] rd_data;
reg acknowledge = 0;

reg [WIDTH-1 :0] mask = 16'h00;
always @(*)begin
	if(req & wr_valid)begin
		acknowledge = 0;
		busy = 1;
		mask = 8'hXX;
	end
	if(req & ~wr_valid) begin
		busy = 0;
		acknowledge = 1;
		mask = 8'hFF;
	end
end

always @(posedge clk)begin

	if (reset == 1)begin
		rd_data <= 0;		
	end	

	else begin
		if(acknowledge == 0)begin
			rd_data <=  8'hXX;
			end
	
		else begin
			rd_data  <= mask & wr_data;
		end
	end
end

endmodule
