module cnt60(clk_sys,Q,seg);
//clk_high,clk_low,
 input wire clk_sys;
 /*output reg*/
 reg clk_low,clk_high;
 output Q,seg;
 reg [7:0]q;
 reg [7:0]Q;
 reg [3:0] seg=4'b1110;
 
 integer tmp1=0;
 integer tmp2=0;
 initial 
  clk_low <=2'b0;
 initial 
  clk_high <=2'b0;
 //fen pin
 always@(posedge clk_sys)
 begin
  tmp1=tmp1+1;
  tmp2=tmp2+1;
  if(tmp1>25000)
   begin
    clk_high <= ~clk_high;
    tmp1<=0;
   end
  if(tmp2>25000000)
  begin
   clk_low <= ~clk_low;
   tmp2 <=0;
  end
 end
 always@(posedge clk_low)
 begin
  if(q[3:0]==4'b1001)
  begin 
   q[7:4]<= q[7:4]+4'b0001;
   q[3:0]<= 4'b0000;
  end
  else 
  begin
   q<= q+1;
  end
  if(q[7:4]==4'b0110) q<=8'b00000000;
 end
 
 always@(posedge clk_high) 
 begin
 seg<={seg[2:0],seg[3]};
 end
 reg [3:0] duan;
 always@(seg)
 case(seg)
  4'b1101:duan=q[7:4];
  4'b1110:duan=q[3:0];
  default:duan=4'hf;
 endcase
 always @(duan)
 begin   
  case(duan)
  4'b0000:Q=8'b00111111;
  4'b0001:Q=8'b00000110;
  4'b0010:Q=8'b01011011;
  4'b0011:Q=8'b01001111;
  4'b0100:Q=8'b01100110;
  4'b0101:Q=8'b01101101;
  4'b0110:Q=8'b01111101;
  4'b0111:Q=8'b00000111;
  4'b1000:Q=8'b01111111;
  4'b1001:Q=8'b01101111;
  4'b1111:Q=8'b00000000;
  default:Q=8'b00000000;
  endcase
 end
endmodule   