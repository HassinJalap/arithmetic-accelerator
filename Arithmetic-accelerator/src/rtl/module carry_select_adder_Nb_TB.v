`timescale 1ns / 1ps

module carry_select_adder_Nb_TB;

    reg [127:0] a,b;
    reg cin;
    wire [127:0] sum;
    wire cout;

  carry_select_adder_Nb uut(.iA(a), .iB(b),.iCarryIn(cin),.oSum(sum),.oCarry(cout));

initial begin
  a=0; b=0; cin=0;
  #100 a=128'd0; b=128'd0; cin=1'd1;
  #100 a=128'd2245456; b=128'd25643; cin=1'd1;
  #100 a=128'd2252131; b=128'd23988765; cin=1'd0;
   #100 a=128'd22286545; b=128'd248653123; cin=1'd1;
  #100 a=128'd22564654562; b=128'd12346523; cin=1'd0;
  #100 a=128'd212316546; b=128'd34352432; cin=1'd0;
  #100 a=128'd2131565; b=128'd1534843; cin=1'd1;
  #100 a=128'd46456123; b=128'd321354; cin=1'd1;
  #100 a=128'd13553152; b=128'd46231322; cin=1'd0;
end

initial
  $monitor( "A=%d, B=%d, Cin= %d, Sum=%d", a,b,cin,{cout,sum});
endmodule
