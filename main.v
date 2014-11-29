`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: makkosik
// 
// Create Date:    19:54:16 02/28/2012 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Description: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main(
    input wire CLK50,
	 
	 // ADC
	 output wire ADC_P,
	 output wire ADC_N,
    input wire DRY_P,
    input wire DRY_M,
    input wire L0_1_P,
    input wire L0_1_N,
    input wire L2_3_P,
    input wire L2_3_N,
    input wire L4_5_P,
    input wire L4_5_N,
    input wire L6_7_P,
    input wire L6_7_N,
    input wire L8_9_P,
    input wire L8_9_N,
    input wire L10_11_P,
    input wire L10_11_N,
    input wire L12_13_P,
    input wire L12_13_N,
    input wire L14_15_P,
    input wire L14_15_N,
	 
	 // DDS
	 output wire FSYNC,
	 output wire SCLK,
	 output wire SDATA,
	 	 
	 // VGA
	 output wire HSYNC,
	 output wire VSYNC,
	 output wire [2:0] RED,
	 output wire [2:0] GREEN,
	 output wire [1:0] BLUE,
	 
	 // USB
	 input wire IFCLK,
	 input wire STMEN,
	 input wire FLAGA,
	 input wire FLAGB,
	 output wire SLRD,
	 output wire SLWR,
	 output wire SLOE,
	 output wire PKTEND,
	 output wire [1:0] FIFOADR,
	 inout wire [7:0] USBDB,
	 
	 input wire [7:0] SWITCH,
	 
	 output wire [7:0] LED
);

// pps
wire pps;
pps #(.DIV(48000000)) pps_gen (
    .clk(IFCLK),
	 .strobe(pps)
);

// processor
//reg [15:0] slow;
//always @ (posedge CLK50)
//  slow <= slow + 1;
//wire SLOWLESS = slow[10];

wire [7:0] port_id;
wire write_strobe;
wire read_strobe;
wire [7:0] out_port;
wire [7:0] in_port;
wire interrupt;
wire interrupt_ack;
embedded_kcpsm3 pico (
	.port_id(port_id),
	.write_strobe(write_strobe),
	.read_strobe(read_strobe),
	.out_port(out_port),
	.in_port(in_port),
	.interrupt(interrupt),
	.interrupt_ack(interrupt_ack),
	.reset(0),
//	.clk(SLOWLESS)
   .clk(CLK50)
);


// ADC
OBUFDS #(.IOSTANDARD("DEFAULT")) obuf_0 (
   .I(IFCLK),
	.O(ADC_P),
	.OB(ADC_N)
);

// 48 DCM
wire clkA;
wire clkB;
wire _c0;
wire _c1;

BUFG BUFG_inst (
   .O(_c1),     // Clock buffer output
   .I(_c0)      // Clock buffer input
);

wire [7:0] status;
DCM_SP #(
   .CLKDV_DIVIDE(2.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                       //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
   .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
   .CLKFX_MULTIPLY(2), // Can be any integer from 2 to 32
   .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
   .CLKIN_PERIOD(20.0),  // Specify period of input clock ns
   .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
   .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
   .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                         //   an integer from 0 to 15
   .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
   .DUTY_CYCLE_CORRECTION("FALSE"), // Duty cycle correction, TRUE or FALSE
   .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
   .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
) DCM_SP_inst (
   .CLK0(_c0),     // 0 degree DCM CLK output
   .CLK180(clkB), // 180 degree DCM CLK output
   .CLK270(), // 270 degree DCM CLK output
   .CLK2X(),   // 2X DCM CLK output
   .CLK2X180(), // 2X, 180 degree DCM CLK out
   .CLK90(),   // 90 degree DCM CLK output
   .CLKDV(),   // Divided DCM CLK out (CLKDV_DIVIDE)
   .CLKFX(),   // DCM CLK synthesis out (M/D)
   .CLKFX180(), // 180 degree CLK synthesis out
   .LOCKED(LED[0]), // DCM LOCK status output
   .PSDONE(), // Dynamic phase adjust done output
   .STATUS(), // 8-bit DCM status bits output
   .CLKFB(_c1),   // DCM clock feedback
   .CLKIN(IFCLK),   // Clock input (from IBUFG, BUFG or DCM)
   .PSCLK(),   // Dynamic phase adjust clock input
   .PSEN(1'b0),     // Dynamic phase adjust enable input
   .PSINCDEC(), // Dynamic phase adjust increment/decrement
   .RST(1'b0)        // DCM asynchronous reset input
);

assign clkA = _c0;


// DRY clock
wire rdry;
IBUFGDS #(.IOSTANDARD("LVDS_25"), .IBUF_DELAY_VALUE("12"), .DIFF_TERM("TRUE")) ibuf_d (.I(DRY_P), .IB(DRY_M), .O(rdry));

//BUF (buf variant)
wire bdry;
BUFG bufg (.I(rdry),.O(bdry));

//BUF (buf variant)
wire bdry2;
BUFG bufg2 (.I(bdry),.O(bdry2));
//wire clkin = bdry2;
//wire notclk = ~bdry2; 



wire dry;
wire [15:0] adc_out; // Unsigned
wire [15:0] sign_adc_out = {~adc_out[15], adc_out[14:0]}; // Signed
adc adc (
//	 .clkA(bdry2),
    //.clkB(~bdry2),
	 .clkA(clkB),
    .clkB(clkA),
	 .L0_1_P(L0_1_P),
	 .L0_1_N(L0_1_N),
	 .L2_3_P(L2_3_P),
	 .L2_3_N(L2_3_N),
	 .L4_5_P(L4_5_P),
	 .L4_5_N(L4_5_N),
	 .L6_7_P(L6_7_P),
	 .L6_7_N(L6_7_N),
	 .L8_9_P(L8_9_P),
	 .L8_9_N(L8_9_N),
	 .L10_11_P(L10_11_P),
	 .L10_11_N(L10_11_N),
	 .L12_13_P(L12_13_P),
	 .L12_13_N(L12_13_N),
	 .L14_15_P(L14_15_P),
	 .L14_15_N(L14_15_N),
	 .dry(dry),
	 .out(adc_out)
);


reg [21:0] d;
always @ (posedge dry) d <= d + 1;

//assign LED[0] = 0;
assign LED[1] = 0;
assign LED[3] = 0;
assign LED[2] = d[21];

//assign LED = t[21:14];
assign LED[7:4] = adc_out[11:8];

// stats ADC
stats16 #(.BASE(248)) st_adc (
  // data
  .clk(dry),
  .pps(pps),
  .data(adc_out),
  // IO
  .port_id(port_id),
  .in_port(in_port),
  .read_strobe(read_strobe)
);


// DCM
wire clk65;
DCM #(.M(13), .D(10)) dcm_vga (
    .in(CLK50),
	 .fx_out(clk65)
); 

// VGA
wire [11:0] hdata;
wire [11:0] vdata;
wire blank;
wire vsync;
vga1024x768x60 vga (
    .clk(clk65),
    .hsync(HSYNC),
    .vsync(vsync),
    .hdata(hdata),
    .vdata(vdata),
    .blank(blank)
);
assign VSYNC = vsync;

wire OUT_VALUEA;
wire OUT_VALUEB;
wire line = OUT_VALUEA || OUT_VALUEB;
m_buffer #(.WIDTH(1023), .BUS(12)) bf (
   .CLK_ADC(dry),
	.CLK(clk65),
   .D(adc_out[7:0]),
   .D2(adc_out[15:8]),
	.HDATA(hdata),
	.VDATA(vdata),
	.NEXT_FRAME(VSYNC),
	.OUT_VALUE(OUT_VALUEA),
	.OUT_VALUE2(OUT_VALUEB)
);

// VGA
wire text;
wire area;
video #(.BASE(16)) video (
	 // io
	 .port_id(port_id),
	 .out_port(out_port),
	 .write_strobe(write_strobe),
    // data
    .clk(clk65),
    .hdata(hdata),
    .vdata(vdata),
	 .area(area),
    .out(text)
);

// buffer line & area
reg bline;
reg bblank;
always @ (posedge clk65)
begin
  bline <= line;
  bblank <= blank;
end

// mix color
wire [7:0] color = (text == 1'b1) ? 8'hFF : ((area) ? ((bline) ? 8'b01101100 : 0) : ((bline) ? 8'b11111100 : 0));
wire [7:0] bcolor = (bblank == 1'b1) ? 0 : color; 

assign RED = bcolor[7:5];
assign GREEN = bcolor[4:2];
assign BLUE = bcolor[1:0];


// cordic
wire [23:0] data_I;
wire [23:0] data_Q;
wire strobe;
wire [31:0] freq;
receiver rec (
    .clock(dry),
//	 .rate(2'b01), // 10   old 01 == 78.125kHz
//	 .frequency(32'd601295421 + {8'h00, SWITCH, 16'h0000}),
	 .frequency(freq),
	 .in_data(sign_adc_out),
	 .out_strobe(strobe),
	 .out_data_I(data_I),
	 .out_data_Q(data_Q)
);

// FQ Meter clock of sampler
/*frequency_meter #(.BASE(240)) frqmtr_rcvr (
    .clk(IFCLK),
	 .pps(pps),
	 .in(strobe),
    // IO
    .port_id(port_id),
    .in_port(in_port),
    .read_strobe(read_strobe)
);*/


/*
reg [23:0] _data_I;
reg [23:0] _data_Q;
always @ (posedge dry)
begin
  if (strobe == 1'b1)
  begin
    _data_I <= data_I;
    _data_Q <= data_Q;
  end
end

// div by 1000 and test gen
reg [31:0] sample;
reg [9:0] divider;
wire ustrobe = divider == 210;
always @ (posedge IFCLK)
begin
  if (divider == 200)
  begin
//    sample <= {1'b0, _data_Q[23:9], 1'b0, _data_I[23:9]}; // first is I then Q
    sample <= {_data_Q[23:8], _data_I[23:8]}; // first is I then Q
  end	 
  if (divider == 999)
  begin
    divider <= 0;
  end else begin
    divider <= divider + 1;
  end
end */

//USB
StreamIOvhd usb (
    .SCLK(IFCLK),//khz48),
	 .STROBE(strobe),
//	 .SDATA({data_Q[23:8], data_I[23:8]}),//sample),
	 .SDATA0({data_I[23:0], 8'b0}),
	 .SDATA1({data_Q[23:0], 8'b0}),
//	 .SDATA0({8'hA3, 8'hA2, 8'hA1, 8'hA0}),
//	 .SDATA1({8'hB3, 8'hB2, 8'hB1, 8'hB0}),
	 .ODATA(freq),
    .IFCLK(IFCLK),
	 .STMEN(STMEN),
	 .FLAGA(FLAGA),
	 .FLAGB(FLAGB),
	 .SLRD(SLRD),
	 .SLWR(SLWR),
	 .SLOE(SLOE),
	 .PKTEND(PKTEND),
	 .FIFOADR(FIFOADR),
	 .USBDB(USBDB)
);

// FQ Meter clock of sampler
/*frequency_meter #(.BASE(244)) frqmtr_usb (
    .clk(IFCLK),
	 .pps(pps),
	 .in(divider < 16),
    // IO
    .port_id(port_id),
    .in_port(in_port),
    .read_strobe(read_strobe)
);*/

// DDS
reg [1:0] dds_clk;
always @ (posedge CLK50)
begin
  dds_clk <= dds_clk + 1;
end

dds #(.BASE(24)) dds (
    .clk(dds_clk[1]),
	 .FSYNC(FSYNC),
	 .SCLK(SCLK),
	 .SDATA(SDATA),
	 // io
	 .port_id(port_id),
	 .out_port(out_port),
	 .write_strobe(write_strobe)
);

endmodule
