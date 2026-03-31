module control_unit (
    input wire [6:0] opcode,
    output reg reg_write,
    output reg alu_src,
    output reg mem_to_reg,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg [1:0] alu_op
);
    always@(*)begin
        case(opcode)
        7'b0110011: begin // R-type
            reg_write = 1'b1;
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            branch = 1'b0;
            alu_op = 2'b10;
        end
        7'b0000011: begin // load word
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_to_reg = 1'b1;
            mem_read = 1'b1;
            mem_write = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00;
        end
        7'b0100011: begin // store word
            reg_write = 1'b0;
            alu_src = 1'b1;
            mem_to_reg = 1'bx; // don't care
            mem_read = 1'b0;
            mem_write = 1'b1;
            branch = 1'b0;
            alu_op = 2'b00;
        end
        7'b1100011: begin // branch equal , branch not equal
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_to_reg = 1'b0; 
            mem_read = 1'b0;
            mem_write = 1'b0;
            branch = 1'b1;
            alu_op = 2'b01;
        end

        

            7'b0010011: begin // addi , andi , ori
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10; // use R-type ALU control for I-type arithmetic
            end
        default: begin // default to NOP for safety
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00; // default to load/store ALU op for safety
        end
        endcase
    end

    endmodule