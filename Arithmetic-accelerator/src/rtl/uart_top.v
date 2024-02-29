`timescale 1ns / 1ps

module uart_top #(
    parameter   OPERAND_WIDTH = 512,
    parameter   ADDER_WIDTH   = 128,
    parameter   NBYTES        = OPERAND_WIDTH / 8,  
    // values for the UART (in case we want to change them)
    parameter   CLK_FREQ      = 125_000_000,
    parameter   BAUD_RATE     = 115_200
  )  
  (
    input   wire   iClk, iRst,
    input   wire   iRx,
    output  wire   oTx
  );
  
  // Buffer to exchange data between Pynq-Z2 and laptop
//  reg [NBYTES*8-1:0] rBuffer;
  reg [NBYTES*8-1:0] rBuffer1, rBuffer2;
  wire [(NBYTES)*8:0] wBuffer3;
  reg [(NBYTES+1)*8-1:0] rBufferRes;
  
  // State definition  
  localparam s_IDLE         = 3'b000;
  localparam s_WAIT_RX1     = 3'b001;
  localparam s_WAIT_RX2     = 3'b010;
  localparam s_ADDITION     = 3'b011;
  localparam s_TX           = 3'b100;
  localparam s_WAIT_TX      = 3'b101;
  localparam s_DONE         = 3'b110;
  localparam s_WAIT_ADD_SUB = 3'b111;
   
  // Declare all variables needed for the finite state machine 
  // -> the FSM state
  reg [2:0]   rFSM;  
  
  // Connection to UART TX (inputs = registers, outputs = wires)
  reg         rTxStart;
  reg [7:0]   rTxByte;
  
  wire        wTxBusy;
  wire        wTxDone;
  
  wire [7:0] wRxByte;
  wire wRxDone;
        
  uart_tx #(  .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) )
  UART_TX_INST
    (.iClk(iClk),
     .iRst(iRst),
     .iTxStart(rTxStart),
     .iTxByte(rTxByte),
     .oTxSerial(oTx),
     .oTxBusy(wTxBusy),
     .oTxDone(wTxDone)
     );
     

     
  uart_rx #( .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) )
  UART_RX_INST
  (.iClk(iClk),
   .iRst(iRst),
   .iRxSerial(iRx),
   .oRxByte(wRxByte),
   .oRxDone(wRxDone)
   );
   
   reg r_StartAdd;
   wire w_DoneAdd;
  
       
   mp_adder #( .OPERAND_WIDTH(OPERAND_WIDTH), .ADDER_WIDTH(ADDER_WIDTH) ) MP_ADDER_INST
   (.iClk(iClk),
    .iRst(iRst),
    .iStart(r_StartAdd),
    .iCommand(r_add_sub[0]),
    .iOpA(rBuffer1),
    .iOpB(rBuffer2),
    .oRes(wBuffer3),
    .oDone(w_DoneAdd)
   );
   
   // Create a reg variable to store the command (add or sub)
   reg [7:0] r_add_sub;

     
  reg [$clog2(NBYTES):0] rCnt_Current;
  
  
  always @(posedge iClk)
  begin
  
  // reset all registers upon reset
  if (iRst == 1 ) 
    begin
      rFSM <= s_IDLE;
      rTxStart <= 0;
      rCnt_Current <= 0;
      rTxByte <= 0;
      rBuffer1 <= 0;
      rBuffer2 <= 0;
      rBufferRes <= 0;
      
      
    end 
  else 
    begin
      case (rFSM)
   
        s_IDLE :
          begin
            rFSM <= s_WAIT_ADD_SUB;
          end
        //Receieve the command (add or sub)
        s_WAIT_ADD_SUB :
          begin
            if (wRxDone==1)
                begin
                    //move to other state
                    r_add_sub <= wRxByte;
                    rFSM <= s_WAIT_RX1;
                end 
             else
                begin
                    rFSM <= s_WAIT_ADD_SUB;
                end           
          end
        
        s_WAIT_RX1 :
          begin
          r_StartAdd <= 0;
            if (wRxDone==1)
                begin
                if(rCnt_Current<NBYTES-1)
                    begin
                    rCnt_Current<=rCnt_Current+1;
                    rFSM <= s_WAIT_RX1;
                    //sth with the buffer, check again 
                    rBuffer1 <= { rBuffer1[NBYTES*8-9:0],wRxByte};            
                    end
                else
                    begin
                    //move to other state
                    rCnt_Current<=0;
                    rBuffer1 <= { rBuffer1[NBYTES*8-9:0],wRxByte}; 
                    rFSM <= s_WAIT_RX2;
                    
                    end
                end 
             else
                begin
                    rFSM <= s_WAIT_RX1;
                end           
          end
          
          s_WAIT_RX2 :
          begin
            if (wRxDone==1)
                begin
                if(rCnt_Current<NBYTES-1)
                    begin
                    //Set r_StartAdd = 0
                    r_StartAdd <= 0;
                    rCnt_Current<=rCnt_Current+1;
                    rFSM <= s_WAIT_RX2;
                    //sth with the buffer, check again 
                    rBuffer2 <= { rBuffer2[NBYTES*8-9:0],wRxByte};            
                    end
                else
                    begin
                    //move to other state
                    rCnt_Current<=0;
                    rBuffer2 <= { rBuffer2[NBYTES*8-9:0],wRxByte}; 
                    r_StartAdd <= 1;                  
                    rFSM <= s_ADDITION;
                    
                    end
                end 
             else
                begin
                    r_StartAdd <= 0;
                    rFSM <= s_WAIT_RX2;
                end           
          end  
        
        s_ADDITION:
        begin
            rCnt_Current<=0;
            
//            rBuffer1 <= 0;
//            rBuffer2 <= 0;
            if(w_DoneAdd != 1)
                begin
                    r_StartAdd <= 1;
                    rFSM <= s_ADDITION;
                end
            else
                begin
                r_StartAdd <= 0;
                rFSM <= s_TX;
                if(r_add_sub[0] == 0)
                    begin
                    rBufferRes <= {7'b0000000,wBuffer3};
                    end
                else
                    begin
                    rBufferRes <= {8'b00000000,wBuffer3[OPERAND_WIDTH-1:0]};
                    end
                end
        
        end
             
        s_TX :
          begin
          
            if ( (rCnt_Current < (NBYTES+1)) && (wTxBusy ==0) ) 
              begin
                rFSM <= s_WAIT_TX;
                rTxStart <= 1; 
                rTxByte <= rBufferRes[(NBYTES+1)*8-1:(NBYTES+1)*8-8];            // we send the uppermost byte
                rBufferRes <= {rBufferRes[(NBYTES+1)*8-9:0] , 8'b0000_0000};    // we shift from right to left
                rCnt_Current <= rCnt_Current + 1;
              end 
            else 
              begin 
                    
                rFSM <= s_DONE;
                rTxStart <= 0;
                rTxByte <= 0;
                rCnt_Current <= 0;
                    
              end
            end 
            
            s_WAIT_TX :
              begin
                if (wTxDone) begin
                  rFSM <= s_TX;
                end else begin
                  rFSM <= s_WAIT_TX;
                  rTxStart <= 0;                   
                end
              end 
              
            s_DONE :
              begin
                rFSM <= s_DONE;
              end 

            default :
              rFSM <= s_IDLE;
             
          endcase
      end
    end       
    
endmodule
