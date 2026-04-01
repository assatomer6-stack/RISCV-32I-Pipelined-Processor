module immeGen_tb;
reg [31:0] instruction;
wire [31:0] immediate;

immeGen uut(
    .instruction(instruction),
    .immediate(immediate)
);

initial begin
$dumpfile("immeGen_sim.vcd");
$dumpvars(0, immeGen_tb);

// 1. I-type (ADDI with negative value)
        // Instruction: addi x1, x0, -1 (Imm = 0xFFF)
        instruction = 32'hFFF00093; 
        #10;
        $display("I-type Check:  Inst=%h | Imm=%d (Expected: -1)", instruction, $signed(immediate));

        // 2. S-type (SW with positive offset)
        // Instruction: sw x2, 8(x1) (Imm = 8)
        instruction = 32'h00208423; 
        #10;
        $display("S-type Check:  Inst=%h | Imm=%d (Expected: 8)", instruction, $signed(immediate));

        // 3. B-type (BEQ with negative jump)
        // Instruction: beq x0, x0, -4 (Imm = -4)
        instruction = 32'hFE000EE3; 
        #10;
        $display("B-type Check:  Inst=%h | Imm=%d (Expected: -4)", instruction, $signed(immediate));

        // 4. U-type (LUI with upper value)
        // Instruction: lui x1, 0x12345 (Imm = 0x12345000)
        instruction = 32'h123450B7; 
        #10;
        $display("U-type Check:  Inst=%h | Imm=%h (Expected: 12345000)", instruction, immediate);

        // 5. J-type (JAL with max forward jump ~1MB)
        // Max 20-bit signed imm: 0x7FFFF -> Shisted left by 1 gives 0xFFFFE
        instruction = 32'h7FFFF0EF; 
        #10;
        $display("J-type Check:  Inst=%h | Imm=%d (Expected Max Forward: 1048574)", instruction, $signed(immediate));

        // 6. Default Check (R-type - ADD)
        // Instruction: add x1, x2, x3 (No Immediate)
        instruction = 32'h003100B3; 
        #10;
        $display("Default Check: Inst=%h | Imm=%d (Expected: 0)", instruction, immediate);

        $display("--- Simulation Finished ---");
        $finish;
    end
endmodule

