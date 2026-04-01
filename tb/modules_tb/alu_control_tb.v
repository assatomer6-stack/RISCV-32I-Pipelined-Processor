`timescale 1ns/1ps

module alu_control_tb;
reg func7;
reg [2:0] func3;
reg [1:0] alu_op;
wire [3:0] alu_control_signal;

alu_control uut (
    .func7(func7),
    .func3(func3),
    .alu_op(alu_op),
    .alu_control_signal(alu_control_signal)
);

initial begin
$dumpfile("alu_control_sim.vcd");
$dumpvars(0, alu_control_tb);


// check for load/store word
alu_op = 2'b00;
func3 = 3'b111; // func3 should not matter for load word
func7 = 1'b0; // func7 should not matter for load word
#1
if(alu_control_signal !== 4'b0010) begin
    $display("Error: Expected ALU control signal for load/store word is 0010, got %b", alu_control_signal);
end
#9


// check for branch equal
alu_op = 2'b01;
func3 = 3'b000; // func3 should not matter for branch equal
func7 = 1'b0; // func7 should not matter for branch equal
#1
if(alu_control_signal !== 4'b0110) begin
    $display("Error: Expected ALU control signal for branch equal is 0110, got %b", alu_control_signal);
end
#9

// check for R-type ADD
alu_op = 2'b10;
func3 = 3'b000;
func7 = 1'b0; // should produce ADD
#1
if(alu_control_signal !== 4'b0010) begin
    $display("Error: Expected ALU control signal for R-type ADD is 0010, got %b", alu_control_signal);
end
#9

// check for R-type SUB
alu_op = 2'b10;
func3 = 3'b000;
func7 = 1'b1; // should produce SUB
#1
if(alu_control_signal !== 4'b0110) begin
    $display("Error: Expected ALU control signal for R-type SUB is 0110, got %b", alu_control_signal);
end
#9

// check for R-type AND
alu_op = 2'b10;
func3 = 3'b111;
func7 = 1'b0; // should produce AND
#1
if(alu_control_signal !== 4'b0000) begin
    $display("Error: Expected ALU control signal for R-type AND is 0000, got %b", alu_control_signal);
end
#9

// check for R-type OR
alu_op = 2'b10;
func3 = 3'b110;
func7 = 1'b0; // should produce OR
#1
if(alu_control_signal !== 4'b0001) begin
    $display("Error: Expected ALU control signal for R-type OR is 0001, got %b", alu_control_signal);
end
#9
// check for R-type SLT
alu_op = 2'b10;
func3 = 3'b010;
func7 = 1'b0; // should produce SLT
#1
if(alu_control_signal !== 4'b0111) begin
    $display("Error: Expected ALU control signal for R-type SLT is 0111, got %b", alu_control_signal);
end
#9

// check for default case
alu_op = 2'b11; // invalid alu_op should default to ADD
func3 = 3'b000; // func3 should not matter for default case
func7 = 1'b0; // func7 should not matter for default case
#1
if(alu_control_signal !== 4'b0010) begin
    $display("Error: Expected ALU control signal for default case is 0010, got %b", alu_control_signal);
end
#9

$finish;
end


endmodule