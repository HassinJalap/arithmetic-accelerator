`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////


module uart_rx #(
  parameter   CLK_FREQ      = 125_000_000,
  parameter   BAUD_RATE     = 115_200,
  // Example: 125 MHz Clock / 115200 baud UART -> CLKS_PER_BIT = 1085 
  parameter   CLKS_PER_BIT  = CLK_FREQ / BAUD_RATE
)
(
  input wire        iClk, iRst,
  input wire        iRxSerial,
  output wire [7:0] oRxByte, 
  output wire       oRxDone
 );
 
 //0. State definition  
  localparam sIDLE             = 3'b000;
  localparam sRX_START         = 3'b001;
  localparam sRX_DATA          = 3'b010;
  localparam sRX_SAMPLE        = 3'b011;
  localparam sRX_DATA_COMPLETE = 3'b100;
  localparam sRX_STOP          = 3'b101;
  localparam sRX_DONE          = 3'b110;
  
  // Register variables required to drive the FSM
  //---------------------------------------------
  // Remember:  -> 'current' is the register output
  //            -> 'next' is the register input
  
  // -> FSM state
  reg [2:0] rFSM_Current, wFSM_Next; 
  
  // -> counter to keep track of the clock cycles
  reg [$clog2(CLKS_PER_BIT):0]   rCnt_Current, wCnt_Next;
    
  // -> counter to keep track of receieved bits
  // (between 0 and 7)
  reg [2:0] rBit_Current, wBit_Next;
  
  // -> the byte we want to receive (we keep building a copy of it)
  // It is like parallelizing serial data coming in
  //First the data, would go into the next register, then from there the rRxData_Current
  reg [7:0] rRxData_Current, wRxData_Next;  
  
  // Double-register the input wire to prevent metastability issues
  reg rRx1, rRx2;
  
  always @(posedge iClk)
    begin
      rRx1 <= iRxSerial;
      rRx2 <= rRx1;
    end

  
  //1. State register with sync reset
  
  always @(posedge iClk)
    begin
      if(iRst == 1)
      begin
          rFSM_Current <= sIDLE;
          rCnt_Current <= 0;
          rBit_Current <= 0;
          rRxData_Current <= 0;
      end
      
      else
      begin
          rFSM_Current <= wFSM_Next;
          rCnt_Current <= wCnt_Next;
          rBit_Current <= wBit_Next;
          rRxData_Current <= wRxData_Next;
      
      end
      
    
    
    end
 
 //2. Next state logic
 
 always @(*)
    begin
    
        case(rFSM_Current)
        // IDLE STATE:
        // -> we simply wait here until there is a 0 at iRxSerial (falling edge)
        // -> when iTxStart is asserted, we copy the byte to send
        //    (iTxByte) into our local register (rTxData_Current)  
        //    and we are ready to start the frame transmission  
        
            sIDLE: 
                begin
                wCnt_Next = 0;
                wBit_Next = 0;
                wRxData_Next = 0; 
                if(iRxSerial == 0)
                    wFSM_Next = sRX_START;
                else
                    wFSM_Next = sIDLE;
                end
            
            sRX_START:
                begin
                    wBit_Next = 0;
                    wRxData_Next = rRxData_Current;
                    if(rCnt_Current < (CLKS_PER_BIT - 1) ) begin
                        wFSM_Next = sRX_START;
                        wCnt_Next = rCnt_Current + 1;
                    end else begin
                    //we have waited CLKS_PER_BIT cycles to for the start bit
                        wFSM_Next = sRX_DATA;
                        wCnt_Next = 0;
                    end

                end
            //sRX_DATA. We stay in this state to recieve the entire byte. For the first sample, we sample
            // after CLKS_PER_BIT/2 cycles and then for the next 7 samples after CLKS_PER_BIT cycles as we
            // will be in the middle of the sample already
            
            
            ///////////
            
            sRX_DATA:
                begin
                    if(rCnt_Current < (((CLKS_PER_BIT-1)/2) - 1))
                        begin
                        wFSM_Next = sRX_DATA;
                        wCnt_Next = rCnt_Current + 1;
                        wBit_Next = rBit_Current;
                        wRxData_Next = rRxData_Current;
                        end
                    //We are in the middle of the data sample
                    else
                        begin
                        wFSM_Next = sRX_SAMPLE;
                        wCnt_Next = rCnt_Current + 1;
                        wBit_Next = rBit_Current;
                        wRxData_Next = rRxData_Current;
                        end
                
                end
                
            sRX_SAMPLE:
                begin
                    wFSM_Next = sRX_DATA_COMPLETE;
                    wCnt_Next = rCnt_Current + 1;
                    wBit_Next = rBit_Current;
                    wRxData_Next = {rRx2, rRxData_Current[7:1]};
                
                end
                
            sRX_DATA_COMPLETE:
                begin
                    if(rCnt_Current < (CLKS_PER_BIT - 1))
                        begin
                        wFSM_Next = sRX_DATA_COMPLETE;
                        wCnt_Next = rCnt_Current + 1;
                        wBit_Next = rBit_Current;
                        wRxData_Next = rRxData_Current;
                        end
                    else
                        begin
                        if(rBit_Current < 7)
                            begin
                            wFSM_Next = sRX_DATA;
                            wCnt_Next = 0;
                            wBit_Next = rBit_Current+1;
                            wRxData_Next = rRxData_Current;
                            end
                        else
                            begin
                            wFSM_Next = sRX_STOP;
                            wCnt_Next = 0;
                            wBit_Next = 0;
                            wRxData_Next = rRxData_Current;
                            end    
                        end
                    
                
                end
            
//            ////////
//            sRX_DATA:
//                begin
//                    //we haven't sampled the first bit
//                    if(rBit_Current == 0)
//                        begin
//                        //If we haven't reached the middle of the bit then keep waiting
//                        if(rCnt_Current < ((CLKS_PER_BIT)/2 - 1))
//                            begin
//                            wFSM_Next = sRX_DATA;
//                            wCnt_Next = rCnt_Current + 1;
//                            wBit_Next = rBit_Current;
//                            wRxData_Next = rRxData_Current;
//                            end
//                        //we have reached the middle of the bit
//                        else
//                            begin
//                            wRxData_Next = {rRx2, rRxData_Current[7:1]};
//                            wFSM_Next = sRX_DATA;
//                            wCnt_Next = 0;
//                            wBit_Next = rBit_Current+1;
//                            end
//                        end
//                    // we have already sampled the first bit -> clock counter is already at 0    
//                    else
//                        begin
//                            //a cycle is not completed -> we are not in the middle of the bit so we keep counting
//                            if(rCnt_Current < (CLKS_PER_BIT - 1))
//                                begin
//                                wFSM_Next = sRX_DATA;
//                                wCnt_Next = rCnt_Current + 1;
//                                wBit_Next = rBit_Current;
//                                wRxData_Next = rRxData_Current;    
//                                end
//                            //we have reached the middle of the bit    
//                            else
//                                begin
//                                wCnt_Next = 0;

//                                //if we haven't already sampled all bits
//                                if(rBit_Current < 7)
//                                    begin
//                                    wFSM_Next = sRX_DATA;
//                                    wBit_Next = rBit_Current + 1;
//                                    wRxData_Next = {rRx2, rRxData_Current[7:1]};
//                                    end
//                                //we have already sampled all of the bits so now we transition into the stop state -> at this point clock counter is at CLKS_PER_BIT/2
//                                else
//                                    begin
//                                    wFSM_Next = sRX_STOP;
//                                    wRxData_Next = {rRx2, rRxData_Current[7:1]};
//                                    wBit_Next = 0;
////                                    wRxData_Next = rRxData_Current;
//                                    end
//                                end
                            
//                        end
                
//                end
                
            sRX_STOP:
                begin
                    wRxData_Next = rRxData_Current;
                    wBit_Next = 0;
                    
                    if (rCnt_Current < (CLKS_PER_BIT - 1))
                        begin
                            wFSM_Next = sRX_STOP;
                            wCnt_Next = rCnt_Current + 1;
                        end
                    else
                        begin
                            wFSM_Next = sRX_DONE;
                            wCnt_Next = 0;
                        end
                    
                end
                
            sRX_DONE:
                begin
                wRxData_Next = rRxData_Current;
                wBit_Next = 0;
                wCnt_Next = 0;
                wFSM_Next = sIDLE;
                end
               
            default:
                begin
                wFSM_Next = sIDLE;
                wCnt_Next = 0;
                wBit_Next = 0;
                wRxData_Next = 0;
                
                end
            
                
            endcase

    
    
    end
    
    //Output logic
    
    assign oRxByte = rRxData_Current;
    assign oRxDone = (rFSM_Current == sRX_DONE) ? 1 : 0;

  
  
  
endmodule
