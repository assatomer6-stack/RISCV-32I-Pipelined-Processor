module MEM_WB_REG(
    input wire clk,
    input wire rst,

    //control signals
   input wire mem_to_reg,
    input wire reg_write,

    //data signals
    input wire [31:0] mem_read_data,
    input wire [31:0] mem_alu_result,

    //rd for forwarding and hazard detection
    input wire [4:0] mem_rd,

    //output signals
    output reg wb_mem_to_reg,
    output reg wb_reg_write,

    output reg [31:0] wb_read_data,
    output reg [31:0] wb_alu_result,

    output reg [4:0] wb_rd

);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wb_mem_to_reg <= 0;
        wb_reg_write <= 0;
        wb_read_data <= 32'b0;
        wb_alu_result <= 32'b0;
        wb_rd <= 5'b0;
    end else begin
        wb_mem_to_reg <= mem_to_reg;
        wb_reg_write <= reg_write;
        wb_read_data <= mem_read_data;
        wb_alu_result <= mem_alu_result;
        wb_rd <= mem_rd;
    end
end

endmodule