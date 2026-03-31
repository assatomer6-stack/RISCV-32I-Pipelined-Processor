module EX_MEM_REG(
    input wire clk,
    input wire rst,
    input wire flush,

    //control signals
    //mem control signals
    input wire exe_branch,
    input wire exe_mem_read,
    input wire exe_mem_write,

    //wb control signals
    input wire exe_reg_write,
    input wire exe_mem_to_reg,

    //flags
    input wire exe_zero,

    //alu result
    input wire [31:0] exe_alu_result,

    // reg data for sw
    input wire [31:0] exe_rs2_data,

    // rd - for forwarding and hazard detection
    input wire [4:0] exe_rd,

    //pc
    
    input wire [31:0] exe_branch_target,

    //output signals

    //control signals
    
    output reg mem_branch,
    output reg mem_mem_read,
    output reg mem_mem_write,
    output reg mem_reg_write,
    output reg mem_mem_to_reg,
    //flags
    output reg mem_zero,
    //alu result
    output reg [31:0] mem_alu_result,
    // reg data for sw
    output reg [31:0] mem_rs2_data,
    // rd - for forwarding and hazard detection
    output reg [4:0] mem_rd,
    //pc
    
    output reg [31:0] mem_branch_target


);

always@(posedge clk , posedge rst ) begin
    if (rst) begin
        mem_branch <= 0;
        mem_mem_read <= 0;
        mem_mem_write <= 0;
        mem_reg_write <= 0;
        mem_mem_to_reg <= 0;
        mem_zero <= 0;
        mem_alu_result <= 32'b0;
        mem_rs2_data <= 32'b0;
        mem_rd <= 5'b0;
        mem_branch_target <= 32'b0;
    end else if (flush) begin
        mem_branch <= 0;
        mem_mem_read <= 0;
        mem_mem_write <= 0;
        mem_reg_write <= 0;
        mem_mem_to_reg <= 0;
        mem_zero <= 0;
        mem_alu_result <= 32'b0;
        mem_rs2_data <= 32'b0;
        mem_rd <= 5'b0;
        mem_branch_target <= 32'b0;

    end else begin
        //control signals
        mem_branch <= exe_branch;
        mem_mem_read <= exe_mem_read;
        mem_mem_write <= exe_mem_write;
        mem_reg_write <= exe_reg_write;
        mem_mem_to_reg <= exe_mem_to_reg;
        //flag
        mem_zero <= exe_zero;
        //alu result
        mem_alu_result <= exe_alu_result;
        // reg data for sw
        mem_rs2_data <= exe_rs2_data;
        // rd - for forwarding and hazard detection
        mem_rd <= exe_rd;
        //pc
        mem_branch_target <= exe_branch_target;

    end
end

endmodule