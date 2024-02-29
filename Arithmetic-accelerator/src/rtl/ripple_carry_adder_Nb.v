`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2023 10:38:40 PM
// Design Name: 
// Module Name: ripple_carry_adder_Nb
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


module ripple_carry_adder_Nb #(
    parameter   ADDER_WIDTH = 4
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
    );
    
    
    wire [ADDER_WIDTH-2:0] w_oCarry;
    
    //First instance generated separately
    full_adder full_adder_inst1
        ( .iA(iA[0:0]), .iB(iB[0:0]), .iCarry(iCarry), .oSum(oSum[0:0]), .oCarry(w_oCarry[0:0]));
        
    // variable to control for loop
    genvar i;

    // instantiate N 1-bit comparators
    generate
        for (i=1; i<ADDER_WIDTH-1; i=i+1) 
        begin
        full_adder full_adder_inst (
            .iA(iA[i:i]), 
            .iB(iB[i:i]), 
            .iCarry(w_oCarry[i-1:i-1]), 
            .oSum(oSum[i:i]), 
            .oCarry(w_oCarry[i:i])
        );
        end 
    endgenerate
    
    full_adder full_adder_instn
        ( .iA(iA[ADDER_WIDTH-1:ADDER_WIDTH-1]), .iB(iB[ADDER_WIDTH-1:ADDER_WIDTH-1]), .iCarry(w_oCarry[ADDER_WIDTH-2:ADDER_WIDTH-2]), 
        .oSum(oSum[ADDER_WIDTH-1:ADDER_WIDTH-1]), .oCarry(oCarry));
    
   
    
    
endmodule
