`timescale 1ns/1ps

module FW_FULL_TB;
    reg clk;
    reg rst;

    TOP_MODULE uut (
        .clk(clk), 
    .rst(rst));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fw_full_sim.vcd");
        $dumpvars(0, FW_FULL_TB);

        clk = 0; 
        rst = 1;
        #42;
        rst = 0;

        #500;

        
        $display("should be 10 %d", uut.rf_inst.registers[1]);
        $display("x2 should be 20 %d", uut.rf_inst.registers[2]);
        $display("x3 should be 30: %d", uut.rf_inst.registers[3]);
        $display("x4 should be 40: %d", uut.rf_inst.registers[4]);

        if (uut.rf_inst.registers[4] == 32'd40) begin
            $display("\n SUCCESS  FW cases (1A, 2A, 1B, 2B) and RF Bypass passed");
        end else begin
            $display("\n fail ! ");
        end

        $finish;
    end
endmodule