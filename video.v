`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: makkosik
// 
// Create Date:    11:39:20 03/03/2012 
// Design Name: 
// Module Name:    video 
// Project Name: 
// Description:    base(0) = data, base(1) = low addr, base(2) = high addr, base(3) = row
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module video #(parameter BASE = 0)(
    // IO
    input [7:0] port_id,
    input [7:0] out_port,
    input write_strobe,

    input clk,
    input wire [11:0] hdata,
    input wire [11:0] vdata,
	 output wire area, // area of text
	 output wire out // pixel of text
);



// addr
reg [9:0] address;



// dual port memory for symbols buffer
wire [7:0] code;
RAMB16_S9_S9 #(
   .WRITE_MODE_A("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .WRITE_MODE_B("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .SIM_COLLISION_CHECK("NONE")  // "NONE", "WARNING_ONLY", "GENERATE_X_ONLY", "ALL" 
) buffer0 (
   .DIPA(0),
   .DOA(),      // Port A 8-bit Data Output
   .DOB(code),      // Port B 8-bit Data Output
   .ADDRA({2'b0, address}),  // Port A 11-bit Address Input
   .ADDRB({2'b0, vdata[9:4], hdata[6:3]}),  // Port B 11-bit Address Input unable
   .CLKA(clk),    // Port A Clock
   .CLKB(clk),    // Port B Clock
   .DIA(out_port),      // Port A 8-bit Data Input
   .DIB(8'h00),      // Port B 8-bit Data Input
   .ENA(1'b1),      // Port A RAM Enable Input
   .ENB(1'b1),      // Port B RAM Enable Input
   .SSRA(1'b0),    // Port A Synchronous Set/Reset Input
   .SSRB(1'b0),    // Port B Synchronous Set/Reset Input
   .WEA(write_strobe),      // Port A Write Enable Input
   .WEB(1'b0)       // Port B Write Enable Input
);


// VGA font
wire pixel;
pc_vga_8x16 vga (
    .clk(clk),
	 .col(hdata[2:0]),
	 .row(vdata[3:0]),
	 .ascii(code),
	 .pixel(pixel)
);
wire uarea = hdata[9:7] == 3'b111;
reg barea;
always @ (posedge clk)
  barea <= uarea;

assign out = pixel && barea;
assign area = barea;

// up
always @ (posedge write_strobe)
begin
  if (port_id == BASE + 0)
  begin
	 address <= address + 1;
  end
  if (port_id == BASE + 1)
  begin
	 address[7:0] <= out_port;
  end
  if (port_id == BASE + 2)
  begin
	 address[9:8] <= out_port[1:0];
  end
  if (port_id == BASE + 3)
  begin
	 address <= {out_port[5:0], 4'b0000};
  end 
end

initial
begin
  address = 0;
end

endmodule
