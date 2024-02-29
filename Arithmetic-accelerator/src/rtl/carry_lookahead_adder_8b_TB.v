`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 06:26:40 PM
// Design Name: 
// Module Name: carry_lookahead_adder_8b_TB
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


module carry_lookahead_adder_8b_TB();

reg [7:0] r_iA, r_iB;
reg r_iCarry;
wire [7:0] w_oSum;
wire w_oCarry;

carry_lookahead_adder_8b carry_lookahead_adder_8b_inst
    ( .iA(r_iA), .iB(r_iB), .iCarryIn(r_iCarry), .oSum(w_oSum), .oCarry(w_oCarry) );

integer i;

initial
    begin

    $monitor ("(%d + %d + %d) = %d", r_iA, r_iB, r_iCarry, {w_oCarry, w_oSum});  

    // Use a for loop to apply random values to the input  
    for (i = 0; i < 15; i = i+1) 
    begin  
        #10 
        r_iA <= $random;  
        r_iB <= $random;  
        r_iCarry <= $random;  
    end  
end


endmodule