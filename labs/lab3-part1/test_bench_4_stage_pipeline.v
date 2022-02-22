`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: NTU
// Engineer:Dr. Smitha K G

// 
////////////////////////////////////////////////////////////////////////////////

module test_bench_4_stage_pipeline;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;


	// Outputs
	wire [63:0] PCOUT;
	wire [31:0] INST;
	wire [63:0] rdata1;
	wire [63:0] rdata2;
	wire [63:0] rdata1_ID_EXE;
	wire [63:0] rdata2_ID_EXE;
	wire [2:0] aluop_ID_EXE;
	wire [4:0] waddr_out_ID_EXE;
	wire [63:0] aluout;
	wire [4:0] waddr_out_EXE_WB;
	wire [63:0] aluout_EXE_WB;

	// Instantiate the Unit Under Test (UUT)
	pipelined_regfile_4stage uut (
		.clk(clk), 
		.rst(rst), 
		.PCOUT(PCOUT), 
		.INST(INST), 
		.rdata1(rdata1), 
		.rdata2(rdata2), 
		.rdata1_ID_EXE(rdata1_ID_EXE), 
		.rdata2_ID_EXE(rdata2_ID_EXE), 
		.aluop_ID_EXE(aluop_ID_EXE),
		.waddr_out_ID_EXE(waddr_out_ID_EXE), 
		.aluout(aluout),
		.waddr_out_EXE_WB(waddr_out_EXE_WB), 
		.aluout_EXE_WB(aluout_EXE_WB)
	);

always #30 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		


		// Wait 100 ns for global reset to finish
		#50;
        
		// Add stimulus here
#35 rst =1;
#35 rst=0;


	end
      
endmodule

