module HDU(
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,
    input wire [4:0] exe_rd,
    input wire exe_reg_write,
    input wire exe_mem_read,
    output reg pc_write,
    output reg if_id_write,
    output reg insert_bubble
);

always@(*)begin
    if(exe_mem_read && ((exe_rd == id_rs1) || (exe_rd == id_rs2)) && (exe_rd !=0))begin
        pc_write =0;
        insert_bubble =1;
        if_id_write =0;
    end
    else begin
    pc_write =1;
    insert_bubble =0;
    if_id_write =1;
    end
end

endmodule