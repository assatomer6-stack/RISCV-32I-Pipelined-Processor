module reg_file (
    input wire clk,
    input wire rst,
    input wire [4:0] rs_addr,
    input wire [4:0] rt_addr,
    input wire [4:0] rd_addr,
    input wire [31:0] write_data,
    input wire reg_write,
    output wire [31:0] rs_data,
    output wire [31:0] rt_data
);

    
    integer i;

    
    reg [31:0] registers [31:0];

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && (rd_addr != 5'd0)) begin
            registers[rd_addr] <= write_data;
        end
    end

   
    assign rs_data = (rs_addr != 5'd0) ? registers[rs_addr] : 32'b0;
    assign rt_data = (rt_addr != 5'd0) ? registers[rt_addr] : 32'b0;

endmodule