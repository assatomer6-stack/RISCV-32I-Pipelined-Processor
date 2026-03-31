module pc_adder(
    input wire [31:0] pc_current,
    output wire [31:0] pc_plus4
);
    assign pc_plus4 = pc_current + 4; 
endmodule