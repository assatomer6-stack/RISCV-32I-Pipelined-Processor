module data_mem (
    input wire clk,
    input wire mem_read,
    input wire write_enable,
    input wire [31:0]addr,
    input wire [31:0]write_data,
    output wire [31:0]read_data
);
    integer i;
    reg [31:0] mem [0:255]; // 256 words of 32-bit memory
initial begin
    for(i = 0; i < 256; i = i + 1) begin
        mem[i] <= 32'b0;
    end

end
    always@(posedge clk) begin
        if(write_enable)begin
            mem[addr[9:2]] <= write_data;
        end
    end

    assign read_data =mem_read ? mem[addr[9:2]] : 32'b0; // Word-aligned access (4 bytes per word)
endmodule