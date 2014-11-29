`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Buffer for ADC data
// 
//////////////////////////////////////////////////////////////////////////////////
module m_buffer #(
	parameter 
	WIDTH = 0, // Max count of horizontal value
	BUS = 11 // Internal width of counters (== bits(WIDTH+1))
)(
	input wire CLK_ADC,
	input wire CLK,
   input wire [7:0] D,  
   input wire [7:0] D2,  
	
	input wire [BUS-1:0] HDATA, // HOR counter
	input wire [BUS-1:0] VDATA, // VER counter
	input wire NEXT_FRAME,
	
	output wire TESTPOS,
	output wire TESTNEG,
	output wire TESTMODE,
	output wire TESTFRAME, 
	output wire TESTSKIP,

	// 1 period wait outs
	output reg OUT_VALUE,
	output reg OUT_VALUE2
	
);

wire pos = 1'b1;

// Address of write [0..2047] 11 bit
reg [BUS-1:0] addr; 

// frames
reg oldframe;
reg frame;
reg frame2;
assign TESTFRAME = frame;

// Differential counter
//wire [23:0] diffcounter;
//synchro_counter #(.WIDTH(24)) sc (
//    .clk(CLK_ADC),
//	 .monitor(frame),
//	 .out(diffcounter)
//);

// Current Mode 
wire mode = 1'b1;//diffcounter[23:0] >= WIDTH; // clocks > width
assign TESTMODE = mode;

reg [2:0] frameskipper;
reg frameskip;
always @ (posedge CLK)
begin
  if (oldframe == 1 & NEXT_FRAME == 0)
  begin
    // Falling edge of NEXT_FRAME
    frame <= !frame;
    if (frameskip == 1'b1)
    begin
      frameskipper <= frameskipper + 1;
    end else begin
      frameskipper <= 0;
    end
  end
  oldframe <= NEXT_FRAME;
end

assign TESTSKIP = frameskipper != 0;

// Address write counter to 512 only!
always @ (posedge CLK_ADC)
begin
  if (frame2 != frame) 
  begin
    frame2 <= frame;
	 // if mode == reset
	 if (mode == 1'b1) addr <= 0;
  end else begin
    if (addr == 0) 
	 begin
	   // wait positive impulse
		if (pos == 1'b1)
		begin
		  // yes signal
		  addr <= addr + 1;
		  frameskip <= 0;
		end else begin
		  // not signal
        if (frameskip == 0)
		  begin
		    frameskip <= 1;
		  end else begin
			 if (frameskipper[2:0] == 4)
			 begin
            addr <= addr + 1;
				frameskip <= 0;
			 end else begin
			 end
		  end
		end
	 end else begin
	   // stop at end or goto begin
      if (addr != (WIDTH - 1)) // end of screen
      begin
        addr <= addr + 1;
      end else begin
		  // if mode == continuous
		  if (mode == 1'b0) addr <= 0;
		end
	 end
  end	 
end

// Value
reg [10:0] old_hdata;
reg [7:0] old_value;
reg [7:0] old_value2;
wire [7:0] value;
wire [7:0] value2;

// pos in values
wire [BUS-1:0] p = VDATA;///320 - VDATA;
wire [BUS-1:0] p2 = VDATA - 256;///320 - VDATA;
wire accept = (p <= old_value && p >= value) || (p <= value && p >= old_value);
wire accept2 = (p2 <= old_value2 && p2 >= value2) || (p2 <= value2 && p2 >= old_value2);
wire wd = HDATA < WIDTH;
//assign OUT_VALUE = (p == value) && (wd);
//assign OUT_SHADE = (accept) && (wd);

always @ (posedge CLK)
begin
  //OUT_VALUE <= (p == value) && (wd);
  OUT_VALUE <= (accept) && (wd);
  OUT_VALUE2 <= (accept2) && (wd);
  if (HDATA != old_hdata && wd) 
  begin
    old_value <= value;
    old_value2 <= value2;
	 old_hdata <= HDATA;
  end
end

// dual port memory for symbols buffer
RAMB16_S9_S9 #(
   .WRITE_MODE_A("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .WRITE_MODE_B("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .SIM_COLLISION_CHECK("NONE")  // "NONE", "WARNING_ONLY", "GENERATE_X_ONLY", "ALL" 
) buffer0 (
   .DIPA(0),
   .DOA(),      // Port A 8-bit Data Output
   .DOB(value),      // Port B 8-bit Data Output
   .ADDRA({frame, addr[10:0]}),  // Port A 11-bit Address Input
   .ADDRB({~frame, HDATA[10:0]}),  // Port B 11-bit Address Input unable
   .CLKA(CLK_ADC),    // Port A Clock
   .CLKB(CLK),    // Port B Clock
   .DIA(D),      // Port A 8-bit Data Input
   .DIB(8'h00),      // Port B 8-bit Data Input
   .ENA(1'b1),      // Port A RAM Enable Input
   .ENB(1'b1),      // Port B RAM Enable Input
   .SSRA(1'b0),    // Port A Synchronous Set/Reset Input
   .SSRB(1'b0),    // Port B Synchronous Set/Reset Input
   .WEA(1'b1),      // Port A Write Enable Input
   .WEB(1'b0)       // Port B Write Enable Input
);

RAMB16_S9_S9 #(
   .WRITE_MODE_A("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .WRITE_MODE_B("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
   .SIM_COLLISION_CHECK("NONE")  // "NONE", "WARNING_ONLY", "GENERATE_X_ONLY", "ALL" 
) buffer1 (
   .DIPA(0),
   .DOA(),      // Port A 8-bit Data Output
   .DOB(value2),      // Port B 8-bit Data Output
   .ADDRA({frame, addr[10:0]}),  // Port A 11-bit Address Input
   .ADDRB({~frame, HDATA[10:0]}),  // Port B 11-bit Address Input unable
   .CLKA(CLK_ADC),    // Port A Clock
   .CLKB(CLK),    // Port B Clock
   .DIA(D2),      // Port A 8-bit Data Input
   .DIB(8'h00),      // Port B 8-bit Data Input
   .ENA(1'b1),      // Port A RAM Enable Input
   .ENB(1'b1),      // Port B RAM Enable Input
   .SSRA(1'b0),    // Port A Synchronous Set/Reset Input
   .SSRB(1'b0),    // Port B Synchronous Set/Reset Input
   .WEA(1'b1),      // Port A Write Enable Input
   .WEB(1'b0)       // Port B Write Enable Input
);




endmodule
