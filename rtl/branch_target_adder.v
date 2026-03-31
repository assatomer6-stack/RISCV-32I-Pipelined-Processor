module branch_target_adder(
    input wire [31:0] pc_current,
    input wire [31:0] imm_shifted,
    output wire [31:0] branch_target
);
    assign branch_target = pc_current + imm_shifted;

endmodule