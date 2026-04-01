`timescale 1ns/1ps

module control_unit_tb;
reg [6:0] opcode;
wire reg_write;
wire alu_src;
wire mem_to_reg;
wire mem_read;
wire mem_write;
wire branch;
wire [1:0] alu_op;

control_unit uut(
    .opcode(opcode),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_to_reg(mem_to_reg),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .branch(branch),
    .alu_op(alu_op)
);

initial begin
$dumpfile("control_unit_sim.vcd");
$dumpvars(0, control_unit_tb);

// check for R-type instruction
opcode = 7'b0110011; // R-type
#1
if(reg_write !== 1'b1 || alu_src !== 1'b0 || mem_to_reg !== 1'b0 || mem_read !== 1'b0 || mem_write !== 1'b0 || branch !== 1'b0 || alu_op !== 2'b10) begin
    $display("Error: Control signals for R-type instruction are incorrect");
end
#9

// check for load word
opcode = 7'b0000011; // load word
#1
if(reg_write !== 1'b1 || alu_src !== 1'b1 || mem_to_reg !== 1'b1 || mem_read !== 1'b1 || mem_write !== 1'b0 || branch !== 1'b0 || alu_op !== 2'b00) begin
    $display("Error: Control signals for load word instruction are incorrect");
end
#9

// check for store word
opcode = 7'b0100011; // store word
#1
if(reg_write !== 1'b0 || alu_src !== 1'b1  || mem_read !== 1'b0 || mem_write !== 1'b1 || branch !== 1'b0 || alu_op !== 2'b00) begin
$display("Error: Control signals for store word instruction are incorrect");
end

#9

// check for branch equal
opcode = 7'b1100011; // branch equal
#1
if(reg_write !== 1'b0 || alu_src !== 1'b0 || mem_read !== 1'b0 || mem_write !== 1'b0 || branch !== 1'b1 || alu_op !== 2'b01) begin
    $display("Error: Control signals for branch equal instruction are incorrect");
end

#9

// check for addi
opcode = 7'b0010011; // I-type arithmetic (addi , andi , ori)
#1
if(reg_write !== 1'b1 || alu_src !== 1'b1 || mem_to_reg !== 1'b0 || mem_read !== 1'b0 || mem_write !== 1'b0 || branch !== 1'b0 || alu_op !== 2'b10) begin
    $display("Error: Control signals for addi instruction are incorrect");
end

#9

// check for illegal opcode (default case)
opcode = 7'b1111111; 
#1;
if(reg_write !== 1'b0 || mem_write !== 1'b0 || branch !== 1'b0) begin
    $display("Error: Control unit allowed a write/branch on an illegal opcode!");
end 
 #9

$finish;

end

endmodule

