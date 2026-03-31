module FORWARDING_UNIT(
    input wire [4:0] exe_rs1,
    input wire [4:0] exe_rs2,
    input wire [4:0] mem_rd,
    input wire [4:0] wb_rd,
    input wire mem_reg_write,
    input wire wb_reg_write,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

// Forwarding logic for EX stage for rs1
always@(*)begin
    
    if( mem_reg_write && (mem_rd !=0) && (mem_rd == exe_rs1))begin
        forwardA = 2'b10;
    end
    else if (wb_reg_write && (wb_rd !=0) && (wb_rd == exe_rs1))begin
        forwardA = 2'b01;
    end
    else begin
        forwardA = 2'b00;
    end
end

// Forwarding logic for EX stage for rs2
always@(*)begin
    
    if( mem_reg_write && (mem_rd !=0) && (mem_rd == exe_rs2))begin
        forwardB = 2'b10;
    end
    else if (wb_reg_write && (wb_rd !=0) && (wb_rd == exe_rs2))begin
        forwardB = 2'b01;
    end
    else begin
        forwardB = 2'b00;
    end
end

endmodule
    