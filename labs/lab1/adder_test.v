`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:54:47 02/04/2022
// Design Name:   adder
// Module Name:   C:/Users/c200201/Desktop/CZ3001_Lab1/CZ3001_Lab1/adder_test.v
// Project Name:  CZ3001_Lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_test;

	// Inputs
	reg [63:0] a;
	reg [63:0] b;

	// Outputs
	wire [63:0] out;

	// Instantiate the Unit Under Test (UUT)
	adder uut (
		.a(a), 
		.b(b), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#200 a = 64'h01; // after 200ns make a=1;
		#200 b = 64'h02; // after 200ns make b=2;
	end
      
endmodule

