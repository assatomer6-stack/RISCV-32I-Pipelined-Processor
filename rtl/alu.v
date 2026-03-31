module alu (
    input wire [31:0] rs,
    input wire [31:0] rt,
    input wire [3:0] alu_op,
    output reg [31:0] alu_result,
    output reg zero
);
    localparam AND = 4'b0000 ,OR = 4'b0001 , ADD = 4'b0010 , SUB = 4'b0110 , SLT = 4'b0111;
    always@(*)begin
        case(alu_op)
        AND: alu_result = rs & rt;
        OR: alu_result = rs | rt;
        ADD: alu_result = rs + rt;
        SUB: alu_result = rs - rt;
        SLT: alu_result = ($signed(rs) < $signed(rt)) ? 32'h1 : 32'h0;
		  default: alu_result = 32'b0;
        endcase
        zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;
    end
endmodule