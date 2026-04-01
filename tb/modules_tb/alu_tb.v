`timescale 1ns/1ps

module alu_tb; 
reg [31:0] rs;
reg [31:0] rt;
reg [3:0] alu_op;
wire [31:0] alu_result;
wire zero;  


alu uut(
    .rs(rs),
    .rt(rt),
    .alu_op(alu_op),
    .alu_result(alu_result),
    .zero(zero)
);

initial begin
$dumpfile("alu_sim.vcd");
$dumpvars(0, alu_tb);

rs = 32'h00000000;
rt = 32'h00000000;
alu_op = 4'b0000; 

#10
// check AND operation

rs = 32'hffff0000;
rt = 32'h0000ffff;
alu_op = 4'b0000;

#10
// check OR operation
rs = 32'hffff0000;
rt = 32'h0000ffff;
alu_op = 4'b0001;

#10
// check ADD operation 
rs = 32'h00000020;
rt = 32'h00000010;
alu_op = 4'b0010;



#10
// check SUB operation
rs = 32'h11111110;
rt = 32'h0000000f;
alu_op = 4'b0110;

#10
// check SLT operation
rs = 32'h00000005;
rt = 32'h0000000a;
alu_op = 4'b0111;

#10
// check SLT operation
rs = 32'h0000000a;
rt = 32'h00000005;
alu_op = 4'b0111;

#10

// check SLT operation with negative and positive number
rs = 32'hFFFFFFFF; 
rt = 32'd5;
alu_op = 4'b0111;

#10

// check ZERO flag
rs = 32'h00000005;
rt = 32'h00000005;
alu_op = 4'b0110;

#10

$finish;


end
    
endmodule