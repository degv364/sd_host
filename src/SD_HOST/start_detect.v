///////////////////////
//FIXME:header
//////////////////////

`include "../defines.v"

module start_detect(input clk,
		    input 	      reset,
		    input [5:0] command_register,
		    output 	      start_flag);
   wire [5:0] 			      curr;
   wire 				      start_flag;
   
   reg [11:0] 			      last;
   wire [5:0] 			      ch;
   assign curr=command_register;
   
   assign ch[0]=((curr[0] & ~last[1])|(~curr[0] & last[1]))? 1 : 0;
   assign ch[1]=((curr[1] & ~last[3])|(~curr[1] & last[3]))? 1 : 0;
   assign ch[2]=((curr[2] & ~last[5])|(~curr[2] & last[5]))? 1 : 0;
   assign ch[3]=((curr[3] & ~last[7])|(~curr[3] & last[7]))? 1 : 0;
   assign ch[4]=((curr[4] & ~last[9])|(~curr[4] & last[9]))? 1 : 0;
   assign ch[5]=((curr[5] & ~last[11])|(~curr[5] & last[11]))? 1 : 0;
   
   assign start_flag=(ch[0]|ch[1]|ch[2]|ch[3]|ch[4]|ch[5])&~reset;
   
   always @(posedge clk) begin
      if (reset==1) begin
	 last<=0;
	 
      end
      else begin
	 last[1:0]={last[0], curr[0]};
	 last[3:2]={last[2], curr[1]};
	 last[5:4]={last[4], curr[2]};
	 last[7:6]={last[6], curr[3]};
	 last[9:8]={last[8], curr[4]};
	 last[11:10]={last[10], curr[5]};
      end
   end


endmodule // start_detect

