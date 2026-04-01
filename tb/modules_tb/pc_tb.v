`timescale 1ns/1ps

module pc_tb;
reg [31:0] next_pc;
reg clk;
reg reset;
wire [31:0] pc;

pc uut (
    .next_pc(next_pc),
    .clk(clk),
    .reset(reset),
    .pc(pc)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock with a period of 10 time units
end

initial begin

$dumpfile("pc_sim.vcd");
$dumpvars(0, pc_tb);

    clk = 0;
    reset =1;
    next_pc = 32'h00000004;

    #10

    reset = 0;
    next_pc = 32'h00000008;

    #10

    reset =0;
    next_pc = 32'h0000000c;

    //check for a-sync reset

    #2 

    reset =1;
    next_pc = 32'h00002010;

    #10
    reset=0;
    next_pc = 32'h00002014;
    
    #10

    $finish;
    

end

endmodule