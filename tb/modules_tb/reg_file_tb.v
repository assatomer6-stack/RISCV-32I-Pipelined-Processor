`timescale 1ns/1ps

module reg_file_tb;
reg clk;
reg [4:0] rs_addr;
reg [4:0] rt_addr;
reg [4:0] rd_addr;
reg [31:0] write_data;
reg reg_write;
wire [31:0] rs_data;
wire [31:0] rt_data;

reg_file uut (
    .clk(clk),
    .rs_addr(rs_addr),
    .rt_addr(rt_addr),
    .rd_addr(rd_addr),
    .write_data(write_data),
    .reg_write(reg_write),
    .rs_data(rs_data),
    .rt_data(rt_data)
);


initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock with a period of 10 time units
end

initial begin
$dumpfile("reg_file_sim.vcd");
$dumpvars(0, reg_file_tb);


//reset initial values
reg_write =0;  
rd_addr = 5'b00000; 
write_data = 32'h00000000;
rs_addr = 5'b00000;
rt_addr = 5'b00000;
#10


// writing to register 1 and check read from zero register
reg_write =1;
rd_addr = 5'b00001; // write to register 1
write_data = 32'h00000001;
rs_addr = 5'b00000; // read from zero register
rt_addr = 5'b00000; // read from zero register
#10

// writing to register 2 and check read from register 1 and zero register
rd_addr = 5'b00010; // write to register 2
reg_write =1;
write_data = 32'h00000002;
rs_addr = 5'b00001; // read from register 1
rt_addr = 5'b00000; // read from zero register
#10

// trying to write to zero register reading from register 1 and 2
rd_addr = 5'b00000; // write to zero register
reg_write =1;
write_data = 32'hffffffff;
rs_addr = 5'b00000; // read from 1 register
rt_addr = 5'b00000; // read from 2 register
#10

// check for reg write signal
rd_addr = 5'b00010; // write to register 2
reg_write =0;
write_data = 32'h00000003;
rs_addr = 5'b00001; // read from register 1
rt_addr = 5'b00010; // read from register 2
#10
 
// simulate writing to register 2 and check read from register 2(we expect to see 2 not 3 until next clock edge)
rd_addr = 5'b00010; // write to register 2
reg_write =1;
write_data = 32'h00000003;
rs_addr = 5'b00000; 
rt_addr = 5'b00010; // read from register 2
#20

$finish;

end

endmodule