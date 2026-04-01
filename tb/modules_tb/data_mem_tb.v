`timescale 1ns/1ps
module data_mem_tb;
reg clk;
    reg [31:0] addr;
    reg [31:0] write_data;
    reg write_enable;
    reg mem_read;
    wire [31:0] read_data;

    data_mem uut (
        .clk(clk),
        .addr(addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    initial clk =0;
    always #5 clk = ~clk; // 10 time units clock period
        
        
   

    initial begin
        $dumpfile("data_mem_sim.vcd");
        $dumpvars(0, data_mem_tb);
        // Initialize signals
        addr = 0;
        write_data = 0;
        write_enable = 0;
        mem_read = 0;

        // Test writing to memory
        #10;

        @(negedge clk); 
        addr = 32'h00000000; // Address 0
        write_data = 32'hDEADBEEF; // Data to write
        write_enable = 1; // Enable write

        
       @(negedge clk);
        // Test reading from memory
        write_enable = 0; // Disable write
        mem_read = 1; // Enable read

        #1; // Wait for read to complete

        // Check if read data matches written data
        if (read_data == 32'hDEADBEEF) begin
            $display("Test Passed: Read data matches written data.");
        end else begin
            $display("Test Failed: Read data does not match written data.");
            $display("Expected: %h, Got: %h", 32'hDEADBEEF, read_data);
        end

    @(negedge clk);
        //check control signals and initial values
write_enable = 0; // Disable write
write_data = 32'hCAFEBABE; // Data to write
addr = 32'h00000004; 



@(negedge clk);
mem_read = 1; // Enable read
write_enable = 0; // Disable write

#1; // Wait for read to complete

if (read_data == 32'h00000000) begin
    $display("Test Passed: Unwritten memory returns zero.");
end else begin
    $display("Test Failed: Unwritten memory does not return zero.");
    $display("Expected: %h, Got: %h", 32'h00000000, read_data);
end



        $finish; // End simulation
    end

endmodule