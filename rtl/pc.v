module pc (
    input wire [31:0] next_pc,
    input wire clk,
    input wire rst,
    input wire pc_write, // control signal to enable/disable PC update
    output reg [31:0] pc
);
    always@(posedge clk , posedge rst) begin
        if(rst) begin
            pc <= 32'b0;
        end else if (pc_write) begin
            pc <= next_pc; 
        end else begin
            pc <= pc; 
        end
    end
endmodule