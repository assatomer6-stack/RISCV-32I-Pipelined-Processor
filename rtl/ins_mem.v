module ins_mem (
    input wire [31:0] addr,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:255]; // 256 words of 32-bit memory
    integer i;
    initial begin
        //reset mem to nop
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000013;
        end
        $readmemh("program.hex", memory);
    end

    always @(*) begin
        instruction = memory[addr[9:2]]; // Word-aligned access (4 bytes per instruction)
    end
endmodule