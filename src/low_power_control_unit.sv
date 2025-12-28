//=============================================================================
// Module: low_power_control_unit
// Description: Power-Efficient Control Unit optimized to reduce switching 
//              activity and power consumption using conditional decoding
//              and gated logic.
//=============================================================================

`timescale 1ns / 1ps

module low_power_control_unit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  opcode,      // 4-bit opcode for instruction
    input  logic        valid,       // Valid instruction signal
    
    // Control outputs
    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        alu_src,
    output logic [2:0]  alu_op,
    output logic        branch,
    output logic        jump
);

    // Internal gating signal to reduce unnecessary switching
    logic gate_enable;
    
    // Registered outputs to reduce glitches and switching activity
    logic        reg_write_int;
    logic        mem_read_int;
    logic        mem_write_int;
    logic        alu_src_int;
    logic [2:0]  alu_op_int;
    logic        branch_int;
    logic        jump_int;
    
    // Opcode definitions
    localparam OPCODE_NOP    = 4'b0000;
    localparam OPCODE_ADD    = 4'b0001;
    localparam OPCODE_SUB    = 4'b0010;
    localparam OPCODE_AND    = 4'b0011;
    localparam OPCODE_OR     = 4'b0100;
    localparam OPCODE_XOR    = 4'b0101;
    localparam OPCODE_LOAD   = 4'b0110;
    localparam OPCODE_STORE  = 4'b0111;
    localparam OPCODE_BRANCH = 4'b1000;
    localparam OPCODE_JUMP   = 4'b1001;
    localparam OPCODE_SLL    = 4'b1010;
    localparam OPCODE_SRL    = 4'b1011;
    
    // ALU Operation codes
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;
    localparam ALU_XOR = 3'b100;
    localparam ALU_SLL = 3'b101;
    localparam ALU_SRL = 3'b110;
    localparam ALU_NOP = 3'b111;
    
    //=========================================================================
    // Power-Efficient Design Strategy:
    // 1. Use clock gating via valid signal to prevent unnecessary switching
    // 2. Sequential conditional decoding (cascaded if-else) vs parallel
    // 3. Register all outputs to minimize glitches
    // 4. Default to NOP state to minimize activity
    //=========================================================================
    
    // Gate enable logic - only decode when valid instruction present
    assign gate_enable = valid;
    
    // Sequential/Conditional Decoding - Power Optimized
    // Uses cascaded if-else to minimize parallel switching
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_write_int <= 1'b0;
            mem_read_int  <= 1'b0;
            mem_write_int <= 1'b0;
            alu_src_int   <= 1'b0;
            alu_op_int    <= ALU_NOP;
            branch_int    <= 1'b0;
            jump_int      <= 1'b0;
        end
        else if (gate_enable) begin
            // Default values - minimize switching by keeping defaults
            reg_write_int <= 1'b0;
            mem_read_int  <= 1'b0;
            mem_write_int <= 1'b0;
            alu_src_int   <= 1'b0;
            alu_op_int    <= ALU_NOP;
            branch_int    <= 1'b0;
            jump_int      <= 1'b0;
            
            // Conditional cascaded decoding - reduces parallel switching
            if (opcode == OPCODE_NOP) begin
                // NOP - all signals remain at default (low power)
            end
            else if (opcode == OPCODE_ADD) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_ADD;
            end
            else if (opcode == OPCODE_SUB) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_SUB;
            end
            else if (opcode == OPCODE_AND) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_AND;
            end
            else if (opcode == OPCODE_OR) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_OR;
            end
            else if (opcode == OPCODE_XOR) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_XOR;
            end
            else if (opcode == OPCODE_LOAD) begin
                reg_write_int <= 1'b1;
                mem_read_int  <= 1'b1;
                alu_src_int   <= 1'b1;
                alu_op_int    <= ALU_ADD;
            end
            else if (opcode == OPCODE_STORE) begin
                mem_write_int <= 1'b1;
                alu_src_int   <= 1'b1;
                alu_op_int    <= ALU_ADD;
            end
            else if (opcode == OPCODE_BRANCH) begin
                branch_int    <= 1'b1;
                alu_op_int    <= ALU_SUB;
            end
            else if (opcode == OPCODE_JUMP) begin
                jump_int      <= 1'b1;
            end
            else if (opcode == OPCODE_SLL) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_SLL;
            end
            else if (opcode == OPCODE_SRL) begin
                reg_write_int <= 1'b1;
                alu_op_int    <= ALU_SRL;
            end
        end
        // When gate_enable is low, outputs maintain previous values
        // This reduces unnecessary switching activity
    end
    
    // Output assignment
    assign reg_write = reg_write_int;
    assign mem_read  = mem_read_int;
    assign mem_write = mem_write_int;
    assign alu_src   = alu_src_int;
    assign alu_op    = alu_op_int;
    assign branch    = branch_int;
    assign jump      = jump_int;

endmodule
