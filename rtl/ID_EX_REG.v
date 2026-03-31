module ID_EX_REG(
    input wire clk,
    input wire rst,
    input wire flush,
    //control signals
    //exe control signals
    input wire [1:0]id_alu_op,
    input wire id_alu_src,
    //mem control signals
    input wire id_branch,
    input wire id_mem_read,
    input wire id_mem_write,
    //wb control signals
    input wire id_reg_write,
    input wire id_mem_to_reg,
    

    // reg data
    input wire [31:0] id_rs1_data,
    input wire [31:0] id_rs2_data,

    // imm
    input wire [31:0] id_imm,

    // rd , rs1, rs2 - for forwarding and hazard detection
    input wire [4:0] id_rd,
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    //pc
    input wire [31:0] id_PC,

    //alu control signals
    input wire [2:0] id_func3,
    input wire id_func7,

    //output signals
   
    //control signals
    output reg [1:0] exe_alu_op,
    output reg exe_alu_src,
    output reg exe_branch,
    output reg exe_mem_read,
    output reg exe_mem_write,
    output reg exe_reg_write,
    output reg exe_mem_to_reg,
    

    // reg data
    output reg [31:0] exe_rs1_data,
    output reg [31:0] exe_rs2_data,

    // imm
    output reg [31:0] exe_imm,

    // rd , rs1, rs2 - for forwarding and hazard detection
    output reg [4:0] exe_rd,
    output reg [4:0] exe_rs1,
    output reg [4:0] exe_rs2,

    //pc
    output reg [31:0] exe_PC,

    //alu control signals
    output reg [2:0] exe_func3,
    output reg exe_func7



);

always@(posedge clk , posedge rst)begin
    
    if(rst)begin
        exe_alu_op <= 2'b00;
        exe_alu_src <= 1'b0;
        exe_branch <= 1'b0;
        exe_mem_read <= 1'b0;
        exe_mem_write <= 1'b0;
        exe_reg_write <= 1'b0;
        exe_mem_to_reg <= 1'b0;

        exe_rs1_data <= 32'b0;
        exe_rs2_data <= 32'b0;

        exe_imm <= 32'b0;

        exe_rd <= 5'b0;
        exe_rs1 <= 5'b0;
        exe_rs2 <= 5'b0;

        exe_PC <= 32'b0;

        exe_func3 <= 3'b000;
        exe_func7 <= 1'b0;

    end else if (flush) begin
        // On flush, we want to insert a NOP
        exe_alu_op <= 2'b00; 
        exe_alu_src <= 1'b0; 
        exe_branch <= 1'b0; 
        exe_mem_read <= 1'b0; 
        exe_mem_write <= 1'b0; 
        exe_reg_write <= 1'b0; 
        exe_mem_to_reg <= 1'b0; 

        exe_rs1_data <= 32'b0; 
        exe_rs2_data <= 32'b0; 

        exe_imm <= 32'b0; 

        exe_rd <= 5'b0; 
        exe_rs1 <= 5'b0; 
        exe_rs2 <= 5'b0; 

        exe_PC <= 32'b0;  

        exe_func3 <= 3'b000; 
        exe_func7 <= 1'b0; 

    end else begin
        // control signals
        exe_alu_op <= id_alu_op;
        exe_alu_src <= id_alu_src;
        exe_branch <= id_branch;
        exe_mem_read <= id_mem_read;
        exe_mem_write <= id_mem_write;
        exe_reg_write <= id_reg_write;
        exe_mem_to_reg <= id_mem_to_reg;

        // reg data
        exe_rs1_data <= id_rs1_data;
        exe_rs2_data <= id_rs2_data;

        // imm
        exe_imm <= id_imm;

        // rd , rs1, rs2 - for forwarding and hazard detection
        exe_rd <= id_rd;
        exe_rs1 <= id_rs1;
        exe_rs2 <= id_rs2;

        //pc
        exe_PC <= id_PC;

        //alu control signals
        exe_func3 <= id_func3;
        exe_func7 <= id_func7;

    end
end

endmodule