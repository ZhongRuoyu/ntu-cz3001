`include "define.v"

module EXE_WB_stage (
	
	input  clk,  rst, 
	input [`DSIZE-1:0] alu_in,
	input [`ASIZE-1:0]waddr_in, 

	
	output reg [`DSIZE-1:0] alu_out,
	output reg[`ASIZE-1:0]waddr_out
	
);




//EXE_WWB register to save the values.



always @ (posedge clk) begin
	if(rst)
	begin
		waddr_out <= 0;
		alu_out <= 0;
		
	end
   else
	begin
		waddr_out <= waddr_in;
		alu_out <= alu_in;
		
	end
 
end
endmodule


