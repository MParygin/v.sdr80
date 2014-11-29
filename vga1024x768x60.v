`timescale 1ns / 100ps
// 
// VGA 1024 x 768 x 60Hz
// Частота входа 65MHz
//
module vga1024x768x60
(
	input wire clk,
	output wire hsync,
	output wire vsync,
	output wire [11:0] hdata,
	output wire [11:0] vdata,
	output wire blank
);
	 
	// Instantiate
	vga #(12, 1024, 1032, 1176, 1344, 768, 771, 777, 806, 0, 0) vga (
		.clk(clk), 
		.hdata(hdata),
		.vdata(vdata),
		.hsync(hsync),
		.vsync(vsync),
		.blank(blank)
	);

endmodule

