`timescale 1ns/1ps

module HDU_TB;
reg clk;
reg rst;


 TOP_MODULE uut (
.clk(clk),
.rst(rst)

);



always #5 clk = ~clk; // Clock with a period of 10 time units

initial begin
    $dumpfile("hdu_sim.vcd");
    $dumpvars(0, HDU_TB);

    clk = 0;
    rst =1;
    #42;
    rst=0;

    #1000;

    if(uut.rf_inst.registers[3] == 32'd200)begin
    $display("test good!");
 end
 else begin
    $display("test failed!");
 end
$display ("\n%d ", uut.rf_inst.registers[1]);
 $display ("\n%d  should be 200 ", uut.rf_inst.registers[3]);
 $display ("\n%d ", uut.rf_inst.registers[5]);
 $display ("\n%d ", uut.rf_inst.registers[6]);
$finish;
end
    

endmodule

