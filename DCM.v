`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:52:17 02/07/2012 
// Design Name: 
// Module Name:    clkNM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DCM #(parameter M=1, D=1, DV=2)(
    input wire in,
	 output wire out,
	 output wire dv_out,
	 output wire fx_out,
	 output wire fx_180_out
);

wire _c0;
wire _c1;

BUFG BUFG_inst (
   .O(_c1),     // Clock buffer output
   .I(_c0)      // Clock buffer input
);

DCM_SP #(
   .CLKDV_DIVIDE(DV), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                       //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
   .CLKFX_DIVIDE(D),   // Can be any integer from 1 to 32
   .CLKFX_MULTIPLY(M), // Can be any integer from 2 to 32
   .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
   .CLKIN_PERIOD(10.0),  // Specify period of input clock ns
   .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
   .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
   .DESKEW_ADJUST("SOURCE_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                         //   an integer from 0 to 15
   .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
   .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
   .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
   .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
) DCM_SP_inst (
   .CLK0(_c0),     // 0 degree DCM CLK output
   .CLK180(), // 180 degree DCM CLK output
   .CLK270(), // 270 degree DCM CLK output
   .CLK2X(),   // 2X DCM CLK output
   .CLK2X180(), // 2X, 180 degree DCM CLK out
   .CLK90(),   // 90 degree DCM CLK output
   .CLKDV(dv_out),   // Divided DCM CLK out (CLKDV_DIVIDE)
   .CLKFX(fx_out),   // DCM CLK synthesis out (M/D)
   .CLKFX180(fx_180_out), // 180 degree CLK synthesis out
   .LOCKED(), // DCM LOCK status output
   .PSDONE(), // Dynamic phase adjust done output
   .STATUS(), // 8-bit DCM status bits output
   .CLKFB(_c1),   // DCM clock feedback
   .CLKIN(in),   // Clock input (from IBUFG, BUFG or DCM)
   .PSCLK(),   // Dynamic phase adjust clock input
   .PSEN(1'b0),     // Dynamic phase adjust enable input
   .PSINCDEC(), // Dynamic phase adjust increment/decrement
   .RST(1'b0)        // DCM asynchronous reset input
);

assign out = _c1;

endmodule
