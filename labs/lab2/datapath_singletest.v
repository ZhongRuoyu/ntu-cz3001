`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:21:34 02/08/2022
// Design Name:   datapath_mux
// Module Name:   F:/CZ3001_Lab2/CZ3001_Lab2/datapath_singletest.v
// Project Name:  CZ3001_Lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: datapath_mux
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module datapath_singletest;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0]inst;

	// Outputs
	wire [63:0]aluout;

	// Instantiate the Unit Under Test (UUT)
	datapath_mux uut (
		.clk(clk), 
		.rst(rst), 
		.inst(inst), 
		.aluout(aluout)
	);

	always #15 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		inst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 rst = 1;
		#50 rst = 0;
		#50;  // Wait 50 ns for global reset to finish

		#100 inst = 32'h00040023;  // ADD X3, X1, X4 (already written above-shown in hexformat)
		#100 inst = 32'h00220024;  // SUB X4, X1, X2 (already written above-shown in hexformat)
		#100 inst = 32'h00440027;  // AND X7, X1, X4
		#100 inst = 32'h006200E8;  // XOR X8, X7, X2


	end
      
endmodule

