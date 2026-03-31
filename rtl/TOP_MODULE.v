module TOP_MODULE(
    input wire clk,
    input wire rst,
	 output wire[31:0] pc_out
);

assign pc_out = if_PC;

// wire

// feedback from wb stage
wire [31:0] wb_data;
wire [4:0]  wb_rd;
wire        wb_reg_write;

// feedback from mem stage
wire [31:0] mem_alu_result;
wire [4:0]  mem_rd;
wire mem_reg_write;

// forwarding and hazard signals
wire [4:0]  exe_rd;
wire exe_mem_read;
wire  pc_write;
wire  if_id_write;
wire  pc_src;
wire  insert_bubble;

// pipeline flushes
wire if_id_flush, id_exe_flush;


//  IF STAGE

wire [31:0] if_PC; 
wire [31:0] if_inst; 
wire [31:0] if_pc_plus_4; 
wire [31:0] if_pc_next;
wire [31:0] branch_target; 

assign if_pc_next = pc_src ? branch_target : if_pc_plus_4;
assign if_id_flush = pc_src; // flushing if branch taken
assign id_exe_flush = pc_src;

ins_mem imem (
    .addr(if_PC),
    .instruction(if_inst)
);

pc pc_inst (
    .clk(clk),
    .rst(rst),
    .next_pc(if_pc_next), 
    .pc(if_PC),
    .pc_write(pc_write) 
);

pc_adder pc_adder_inst (
    .pc_current(if_PC),
    .pc_plus4(if_pc_plus_4)
);


//  ID STAGE

wire [31:0] id_PC;
wire [31:0] id_inst;
wire [31:0] id_rs1_data;
wire [31:0] id_rs2_data;
wire [31:0] id_imme;
wire [1:0]  id_alu_op;
//control lines
wire  id_alu_src, id_mem_read, id_mem_write, id_reg_write, id_mem_to_reg, id_branch;

IF_ID_REG if_id_reg (
    .clk(clk),
    .rst(rst),
    .flush(if_id_flush),
    .if_id_write(if_id_write),
    .if_PC(if_PC),
    .if_inst(if_inst),
    .id_PC(id_PC),
    .id_inst(id_inst)
);

control_unit cu_inst (
    .opcode(id_inst[6:0]),
    .alu_op(id_alu_op),
    .alu_src(id_alu_src),
    .branch(id_branch),
    .mem_read(id_mem_read),
    .mem_write(id_mem_write),
    .reg_write(id_reg_write),
    .mem_to_reg(id_mem_to_reg)
);

reg_file rf_inst (
    .clk(clk),
	 .rst(rst),
    .rs_addr(id_inst[19:15]),
    .rt_addr(id_inst[24:20]),
    .rd_addr(wb_rd),
    .write_data(wb_data),
    .reg_write(wb_reg_write),
    .rs_data(id_rs1_data),
    .rt_data(id_rs2_data)
);

immeGen imm_gen_inst (
    .instruction(id_inst),
    .immediate(id_imme)
);

HDU hdu_inst (
    .id_rs1(id_inst[19:15]),      
    .id_rs2(id_inst[24:20]),      
    .exe_rd(exe_rd),       
    .exe_mem_read(exe_mem_read),  
    .pc_write(pc_write),          
    .if_id_write(if_id_write),    
    .insert_bubble(insert_bubble)     
);

//insert bubble or control lines
wire id_reg_write_final  = insert_bubble ? 1'b0 : id_reg_write;
wire id_mem_to_reg_final = insert_bubble ? 1'b0 : id_mem_to_reg;
wire id_mem_read_final   = insert_bubble ? 1'b0 : id_mem_read;
wire id_mem_write_final  = insert_bubble ? 1'b0 : id_mem_write;
wire id_alu_src_final    = insert_bubble ? 1'b0 : id_alu_src;
wire id_branch_final     = insert_bubble ? 1'b0 : id_branch;
wire [1:0] id_alu_op_final = insert_bubble ? 2'b0 : id_alu_op;


//  EXE STAGE

//control lines
wire [1:0]  exe_alu_op;
wire   exe_alu_src, exe_branch, exe_mem_write, exe_reg_write, exe_mem_to_reg;
//data and pc
wire [31:0] exe_rs1_data, exe_rs2_data, exe_imm, exe_PC;
//reg adrr for forwarding unit
wire [4:0]  exe_rs1, exe_rs2;
//alu and alu_control signals
wire [2:0]  exe_func3;
wire  exe_func7;
wire [3:0]  alu_control_signals;
wire [31:0] final_alu_in_b;
wire [1:0]  forward_a, forward_b;
wire [31:0] exe_alu_result;
wire   exe_zero;
// forwarding mux outputs
reg [31:0] alu_in_a_forwarded;
reg [31:0] alu_in_b_forwarded;

assign branch_target = exe_PC + exe_imm; // calcating branch target

ID_EX_REG id_ex_reg_inst (
    .clk(clk),
    .rst(rst),
    .flush(pc_src), 
    .id_alu_op(id_alu_op_final),
    .id_alu_src(id_alu_src_final),
    .id_branch(id_branch_final),
    .id_mem_read(id_mem_read_final),
    .id_mem_write(id_mem_write_final),
    .id_reg_write(id_reg_write_final),
    .id_mem_to_reg(id_mem_to_reg_final),
    .id_rs1_data(id_rs1_data),
    .id_rs2_data(id_rs2_data),
    .id_imm(id_imme),              
    .id_PC(id_PC),
    .id_rs1(id_inst[19:15]),
    .id_rs2(id_inst[24:20]),
    .id_rd(id_inst[11:7]),
    .id_func3(id_inst[14:12]),
    .id_func7(id_inst[30]&id_inst[5]),  // suporting I type   
       
    .exe_alu_op(exe_alu_op),
    .exe_alu_src(exe_alu_src),
    .exe_branch(exe_branch),
    .exe_mem_read(exe_mem_read),
    .exe_mem_write(exe_mem_write),
    .exe_reg_write(exe_reg_write),
    .exe_mem_to_reg(exe_mem_to_reg),
    .exe_rs1_data(exe_rs1_data),
    .exe_rs2_data(exe_rs2_data),
    .exe_imm(exe_imm),
    .exe_rd(exe_rd),
    .exe_rs1(exe_rs1),
    .exe_rs2(exe_rs2),
    .exe_PC(exe_PC),
    .exe_func3(exe_func3),
    .exe_func7(exe_func7)
);

//creating MUX for forwarding

always @(*) begin
    case (forward_a) 
        2'b00: alu_in_a_forwarded = exe_rs1_data;
        2'b01: alu_in_a_forwarded = wb_data;       
        2'b10: alu_in_a_forwarded = mem_alu_result; 
        default: alu_in_a_forwarded = exe_rs1_data;
    endcase
end

always @(*) begin
    case (forward_b)
        2'b00: alu_in_b_forwarded = exe_rs2_data;
        2'b01: alu_in_b_forwarded = wb_data;
        2'b10: alu_in_b_forwarded = mem_alu_result;
        default: alu_in_b_forwarded = exe_rs2_data;
    endcase
end

//finel MUX for imm or rs2

assign final_alu_in_b = (exe_alu_src) ? exe_imm : alu_in_b_forwarded;

FORWARDING_UNIT fr_inst(
    .exe_rs1(exe_rs1),
    .exe_rs2(exe_rs2),
    .mem_rd(mem_rd),
    .wb_rd(wb_rd),
    .mem_reg_write(mem_reg_write),
    .wb_reg_write(wb_reg_write),
    .forwardA(forward_a),
    .forwardB(forward_b)
);

alu_control alu_control_inst(
    .func7(exe_func7),
    .func3(exe_func3),
    .alu_op(exe_alu_op),
    .alu_control_signal(alu_control_signals)
);

alu alu_inst(
    .rs(alu_in_a_forwarded),
    .rt(final_alu_in_b),
    .alu_op(alu_control_signals),
    .alu_result(exe_alu_result),
    .zero(exe_zero)
);

assign pc_src = exe_zero & exe_branch; // if branch then flush if id and pc_next = branch_target

// MEM STAGE

wire [31:0] mem_rs2_data , mem_read_data , mem_branch_target;
wire mem_branch, mem_zero, mem_mem_read, mem_mem_write, mem_mem_to_reg;

EX_MEM_REG exe_mem_reg(
    .clk(clk),
    .rst(rst),
    .flush(1'b0),

    .exe_branch(exe_branch),
    .exe_mem_read(exe_mem_read),
    .exe_mem_write(exe_mem_write),
    .exe_reg_write(exe_reg_write),
    .exe_mem_to_reg(exe_mem_to_reg),
    .exe_zero(exe_zero),
    .exe_alu_result(exe_alu_result),
    .exe_rs2_data(alu_in_b_forwarded), 
    .exe_rd(exe_rd),
    .exe_branch_target(branch_target), //at first implemnted branch decison on mem stage later implemnted in exe stage saving on flush 

    .mem_branch(mem_branch), // also not needed 
    .mem_mem_read(mem_mem_read),
    .mem_mem_write(mem_mem_write),
    .mem_reg_write(mem_reg_write),    
    .mem_mem_to_reg(mem_mem_to_reg),
    .mem_zero(mem_zero),//also not needed
    .mem_alu_result(mem_alu_result),  
    .mem_rs2_data(mem_rs2_data),      
    .mem_rd(mem_rd),                 
    .mem_branch_target(mem_branch_target)
);


data_mem data_mem_inst(
.clk(clk),
.mem_read(mem_mem_read),
.write_enable(mem_mem_write),
.addr(mem_alu_result),
.write_data( mem_rs2_data),
.read_data(mem_read_data)
);

// wb stage
wire wb_mem_to_reg;
wire [31:0] wb_read_data , wb_alu_result;

MEM_WB_REG mem_wb_reg(

    .clk(clk),
    .rst(rst),
    //control signals
     .mem_to_reg(mem_mem_to_reg),
     .reg_write(mem_reg_write),

     //data signals
     .mem_read_data(mem_read_data),
      .mem_alu_result(mem_alu_result),

    //rd for forwarding and hazard detection
     .mem_rd(mem_rd),

    //output signals
     .wb_mem_to_reg(wb_mem_to_reg),
     .wb_reg_write(wb_reg_write),

      .wb_read_data(wb_read_data),
     .wb_alu_result(wb_alu_result),

     .wb_rd(wb_rd)
);

assign wb_data = wb_mem_to_reg ? wb_read_data : wb_alu_result;

endmodule