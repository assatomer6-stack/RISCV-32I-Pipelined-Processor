`timescale 1ns/1ps

module FIB_TB;
    reg clk;
    reg rst;

    // Unit Under Test (UUT)
    TOP_MODULE uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Setup waveform dumping
        $dumpfile("fib_sim.vcd");
        $dumpvars(0, FIB_TB);

        // Initialization
        clk = 0;
        rst = 1;
        #42;
        rst = 0;

        // Wait for the pipeline to finish 8 iterations
        #2500;

        $display("\n--- Fibonacci Sequence Test Results ---");
        $display("F(9) Final Value in x1: %d (Expected: 34)", uut.rf_inst.registers[1]);
         $display("F(9) Final Value in x2: %d (Expected: 34)", uut.rf_inst.registers[2]);

        $display("Loop Counter x4 state: %d (Expected: 0)", uut.rf_inst.registers[4]);
        $display("Base Address x6 state: %d (Expected: 100)", uut.rf_inst.registers[6]);

        // Final check
        if(uut.rf_inst.registers[1] == 32'd34) begin
            $display("\n***********************************");
            $display("* FIBONACCI TEST PASSED      *");
            $display("***********************************");
        end else begin
            $display("\n###################################");
            $display("#      FIBONACCI TEST FAILED      #");
            $display("###################################");
        end

        $finish;
    end

endmodule