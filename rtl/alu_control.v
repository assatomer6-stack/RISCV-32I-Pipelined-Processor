module alu_control (
    input wire func7,
    input wire [2:0] func3,
    input wire [1:0]alu_op,
    output reg [3:0] alu_control_signal
);

   always@(*)begin
    case(alu_op)
    2'b00: alu_control_signal = 4'b0010;
    2'b01 : alu_control_signal = 4'b0110; 
    2'b10:begin
        case(func3)
        3'b000:alu_control_signal = func7 ? 4'b0110 : 4'b0010;
        3'b111:alu_control_signal = 4'b0000;
        3'b110:alu_control_signal = 4'b0001;
        3'b010:alu_control_signal = 4'b0111;
        default: alu_control_signal = 4'b0010; // default to ADD for safety
        endcase
    end
    default: alu_control_signal = 4'b0010; // default to ADD for safety
    endcase
       end 
endmodule