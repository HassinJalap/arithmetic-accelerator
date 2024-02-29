//`timescale 1ns / 1ps

//module uart_top_TB ();
 
//  // Define signals for module under test (UART_TOP)
//  reg  rClk = 0;
//  reg  rRst = 0;
//  wire wRx, wTx;
  
//  //Define signals for Tx and Rx
//  reg rTxStart;
//  reg [7:0] rTxByte;
  
//  wire [7:0] wRxByte;
  
//  wire wTxBusy, wRxDone, wTxDone;
  
  
//  // We downscale the values in the simulation
//  // this will give CLKS_PER_BIT = 100 / 10 = 10
//  localparam CLK_FREQ_inst  = 100;
//  localparam BAUD_RATE_inst = 10;
  
//  // Instantiate DUT  
//  uart_top 
//  #(  .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst) )
//  uart_top_inst
//  ( .iClk(rClk), .iRst(rRst), .iRx(wRx), .oTx(wTx) );
  
//  //Instantiate a transmitter to send one byte to the receiver
//  uart_tx
//  #(  .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst) )
  
//  uart_tx_inst
//  (.iRst(rRst), .iClk(rClk), .iTxStart(rTxStart), .iTxByte(rTxByte), .oTxSerial(wRx), .oTxBusy(wTxBusy), .oTxDone(wTxDone));
  
//  //Instantiate receiver to get the transmitted byte by the UART top
//  uart_rx
//  #(  .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst) )
  
//  uart_rx_inst
//  (.iRst(rRst), .iClk(rClk), .iRxSerial(wTx), .oRxByte(wRxByte), .oRxDone(wRxDone));
  
//  // Define clock signal
//  localparam CLOCK_PERIOD = 5;
  
//  always
//    #(CLOCK_PERIOD/2) rClk <= !rClk;
 
//  // Input stimulus
//  initial
//    begin
//      rRst = 1;
//      #(5*CLOCK_PERIOD);
      
//      rRst =0;
//      //Let it run a couple clock periods
//      #(5*CLOCK_PERIOD);
      
//      //Assert the start bit
//      rTxByte = "H";
//      #(5*CLOCK_PERIOD);
//      rTxStart = 1;
//      #(CLOCK_PERIOD);
//      rTxStart = 0;
//      rTxByte = "";
      
      
//      // Let it run for a while
//      #(5000*CLOCK_PERIOD);
      
//      if(wRxByte == "H") $display("PASSED the test!");
//      else                 $display("FAILED the test");
      
//      #(CLOCK_PERIOD);
      
            
//      $stop;
           
//    end
   
//endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 08:29:28 AM
// Design Name: 
// Module Name: uart_TOP2_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module uart_top_TB ();
 
  // Define signals for module under test
  reg  rClk = 0;
  reg  rRst = 0;
  reg wRx;
  wire  wTx;
  
  // We downscale the values in the simulation
  // this will give CLKS_PER_BIT = 100 / 10 = 10
  localparam CLK_FREQ_inst  = 100;
  localparam BAUD_RATE_inst = 10;
  
  // Instantiate DUT  
  uart_top 
  #(  .CLK_FREQ(CLK_FREQ_inst), .BAUD_RATE(BAUD_RATE_inst) )
  uart_top_inst
  ( .iClk(rClk), .iRst(rRst), .iRx(wRx), .oTx(wTx) );
  
  // Define clock signal
  localparam CLOCK_PERIOD = 10;
  
  always
    #(CLOCK_PERIOD/2) rClk <= !rClk;
 
  // Input stimulus
  initial
    begin
      rRst = 1;
      #(5*CLOCK_PERIOD);
      
      
      rRst =0;
      
            
                
    end
   initial begin
   
    #(100*CLOCK_PERIOD); // wait a bit for reset to complete

    // Send 12 bytes of data from the laptop to the FPGA
    // (in ASCII: "Hello, World!")
    wRx = 1;
    #(100*CLOCK_PERIOD);
    
    wRx = 0;
    #(10*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    wRx = 1;
    #(80*CLOCK_PERIOD);
    wRx = 0;
    #(22*CLOCK_PERIOD);
    

    // Wait for the transmission to complete
    #1000000000;
    $stop;
 end
    
  
   
endmodule
