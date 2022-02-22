`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_4stage(clk, rst, PCOUT, INST, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE, aluop_ID_EXE,  waddr_out_ID_EXE,aluout,waddr_out_EXE_WB,aluout_EXE_WB);

input clk;				
											
input	rst;

 
output [`DSIZE-1:0]PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_ID_EXE;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_ID_EXE;
output [`ISIZE-1:0]INST;
output [2:0]aluop_ID_EXE;
output [`ASIZE-1:0] waddr_out_ID_EXE;	
output [`DSIZE-1:0] aluout;				
output [`ASIZE-1:0] waddr_out_EXE_WB;	
output [`DSIZE-1:0] aluout_EXE_WB;								
 	 
//Program counter
wire [`DSIZE-1:0]PCIN;



PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


assign PCIN = PCOUT + 1'b1; //increments PC to PC +1


//instruction memory
imemory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(64'b0), .fileid(1'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation


wire wen;
wire [2:0] aluop;

control C0 (.inst_cntrl(INST[31:21]),.wen_cntrl(wen), .aluop_cntrl(aluop));


//initialization of regfiles is done as hardcoding here
regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen), .raddr1(INST[9:5]), .raddr2(INST[20:16]), .waddr(waddr_out_EXE_WB), .wdata(aluout_EXE_WB), .rdata1(rdata1), .rdata2(rdata2));//note that waddr and wdata needs to come from last pipeline register (EXE/WB stage)



ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),.opcode_in(aluop), .waddr_in(INST[4:0]), .waddr_out(waddr_out_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE),.opcode_out(aluop_ID_EXE));


alu ALU0 ( .a(rdata1_ID_EXE), .b(rdata2_ID_EXE), .op(aluop_ID_EXE), .out(aluout));//ALU takes its input from pipeline register and the output of mux.

//second pipeline register between EXE and WB stage
EXE_WB_stage PIPE2(.clk(clk),.rst(rst),.alu_in(aluout),.waddr_in(waddr_out_ID_EXE),.alu_out(aluout_EXE_WB),.waddr_out(waddr_out_EXE_WB));

endmodule


