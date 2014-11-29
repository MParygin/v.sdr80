`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: makkosik
// 
// Create Date:    16:43:57 02/29/2012 
// Design Name: 
// Module Name:    usb_io 
// Project Name: 
// Description: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module usb_io(
    // Clock & Reset
    input wire IFCLK,
	 input wire RST,
	 // Download to FPGA
	 output wire DOWNBSY,
	 input wire DOWNWR,
	 output wire DOWNACK,
	 input wire [7:0] DOWNDATA,
	 // Upload from FPGA
	 output wire UPBSY,
	 input wire UPRD,
	 output wire UPACK,
	 output wire [7:0] UPDATA,
	 // DATA
	 input wire SCLK,
	 input wire STROBE,
	 input wire [31:0] SDATA0,
	 input wire [31:0] SDATA1,
	 output wire [31:0] ODATA
);

// addresses
reg [11:0] posr; // position of read 2 x 8 x 2048
reg [8:0] posw; // position of write 2 x 32 x 512
wire [2:0] pager = posr[11:9]; // page of read 0..3
wire [2:0] pagew = posw[8:6]; // page of write 0..3
//wire [1:0] pager = posr[10:9]; // page of read 0..3
//wire [1:0] pagew = posw[8:7]; // page of write 0..3

// Busy
assign DOWNBSY = 0;
assign UPBSY = pager == pagew; // Busy, wher pahe is equals
assign DOWNACK = 1;
assign UPACK = 1;


reg [31:0] fdata0;
reg [31:0] fdata1;
always @ (posedge SCLK)
begin
  if (STROBE == 1'b1)
  begin
    fdata0 <= SDATA0;
    fdata1 <= SDATA1;
    posw <= posw + 1;
  end
end

// corrected pos
wire [10:0] posr2 = (UPRD == 1'b1) ? posr[11:1] + 1  : posr[11:1]; // corrected UP

// mem
wire [7:0] updata0;
RAMB16_S9_S36 ram0 (
   .DIA(),      // Port A 8-bit Data Input
   .ADDRA(posr2),  // Port A 11-bit Address Input
   .DOA(updata0),      // Port A 8-bit Data Output
   .CLKA(IFCLK),    // Port A Clock
   .ENA(1'b1),      // Port A RAM Enable Input
   .SSRA(1'b0),    // Port A Synchronous Set/Reset Input
   .WEA(1'b0),      // Port A Write Enable Input

	.DIPB(4'b0000),
   .DIB(fdata0),      // Port B Data Input
   .ADDRB(posw),  // Port B Address Input unable
   .DOB(),      // Port B Data Output
   .CLKB(IFCLK),    // Port B Clock
   .ENB(1'b1),      // Port B RAM Enable Input
   .SSRB(1'b0),    // Port B Synchronous Set/Reset Input
   .WEB(1'b1)       // Port B Write Enable Input
);

wire [7:0] updata1;
RAMB16_S9_S36 ram1 (
   .DIA(),      // Port A 8-bit Data Input
   .ADDRA(posr2),  // Port A 11-bit Address Input
   .DOA(updata1),      // Port A 8-bit Data Output
   .CLKA(IFCLK),    // Port A Clock
   .ENA(1'b1),      // Port A RAM Enable Input
   .SSRA(1'b0),    // Port A Synchronous Set/Reset Input
   .WEA(1'b0),      // Port A Write Enable Input

	.DIPB(4'b0000),
   .DIB(fdata1),      // Port B Data Input
   .ADDRB(posw),  // Port B Address Input unable
   .DOB(),      // Port B Data Output
   .CLKB(IFCLK),    // Port B Clock
   .ENB(1'b1),      // Port B RAM Enable Input
   .SSRB(1'b0),    // Port B Synchronous Set/Reset Input
   .WEB(1'b1)       // Port B Write Enable Input
);

// read interleave data
assign UPDATA = (posr[0] == 1'b0) ? updata0 : updata1;  


// main loop
always @ (posedge IFCLK)
begin
  if (UPRD == 1'b1)
  begin
    posr <= posr + 1;
  end
end

// upload data
reg [7:0] odata0;
reg [7:0] odata1;
reg [7:0] odata2;
reg [7:0] odata3;
reg [1:0] opos;

always @ (posedge IFCLK)
begin
  if (DOWNWR == 1'b1)
  begin
    if (opos == 0)
	   odata0 <= DOWNDATA;
    if (opos == 1)
	   odata1 <= DOWNDATA;
    if (opos == 2)
	   odata2 <= DOWNDATA;
    if (opos == 3)
	   odata3 <= DOWNDATA;
    opos <= opos + 1;
  end
end

assign ODATA = {odata3, odata2, odata1, odata0};

initial
begin
  opos <= 0;
  posr <= 0;
  posw <= 0;
end

endmodule
