`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:00:55 03/06/2012
// Design Name:   dds
// Module Name:   /data/nprojects/n.sdr/dds_tf.v
// Project Name:  n.sdr
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dds
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dds_tf;

	// Inputs
	reg clk;
	reg [7:0] port_id;
	reg [7:0] out_port;
	reg write_strobe;

	// Outputs
	wire FSYNC;
	wire SCLK;
	wire SDATA;

	// Instantiate the Unit Under Test (UUT)
	dds uut (
		.clk(clk), 
		.FSYNC(FSYNC), 
		.SCLK(SCLK), 
		.SDATA(SDATA), 
		.port_id(port_id), 
		.out_port(out_port), 
		.write_strobe(write_strobe)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		port_id = 0;
		out_port = 0;
		write_strobe = 0;

		// Wait 100 ns for global reset to finish
		#1;
        
		// Add stimulus here

	end
	
always 
begin
  #1 clk = !clk;
end	
      
endmodule

