module IF_ID_REG(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire if_id_write, // control signal to enable/disable IF/ID register update
    input wire [31:0] if_PC,
    input wire [31:0] if_inst,
    output reg [31:0] id_PC,
    output reg [31:0] id_inst

);


always @(posedge clk , posedge rst) begin
    if (rst) begin
        id_PC <= 32'b0;
        id_inst <= 32'h00000013; // NOP instruction
        
    end else if (flush) begin
        id_PC <= 32'b0;
        id_inst <= 32'h00000013; // NOP instruction

    end else if (if_id_write) begin
        id_PC <= if_PC;
        id_inst <= if_inst;
    end
    else begin
        id_PC <= id_PC; 
        id_inst <= id_inst; 
    end
end

endmodule
    