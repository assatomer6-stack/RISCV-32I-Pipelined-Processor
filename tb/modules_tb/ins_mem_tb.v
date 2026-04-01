`timescale 1ns/1ps

module ins_mem_tb;
reg [31:0]addr;
wire [31:0] instruction;


    // Instantiate the Unit Under Test (UUT)
    ins_mem uut (
        .addr(addr),
        .instruction(instruction)
    );

    
    integer i;

    initial begin
        
        $dumpfile("ins_mem_sim.vcd");
        $dumpvars(0, ins_mem_tb);

        
        
        // 1. addi x1, x0, 10 
        uut.memory[0] = 32'h00A00093; 
        // 2. addi x2, x0, 20
        uut.memory[1] = 32'h01400113; 
        // 3. add x3, x1, x2 (x3 = 30)
        uut.memory[2] = 32'h002081B3; 
        // 4. sw x3, 4(x0) (Store 30 at address 4)
        uut.memory[3] = 32'h00302223; 
        // 5. lw x4, 4(x0) (Load value from address 4)
        uut.memory[4] = 32'h00402203; 
        // 6. beq x1, x1, -8 (Branch back 2 instructions)
        uut.memory[5] = 32'hFE108CE3; 

        #1;

        //memory access
        
        for (i = 0; i < 6; i = i + 1) begin
            addr = i * 4; 
            #10;   
        end

        $finish;
    end

endmodule

