//=============================================================================
// Module: high_perf_control_unit
// Description: Minimal High-Performance Control Unit with 5 basic opcodes.
//              Optimized for parallel execution and minimum latency.
//=============================================================================

`timescale 1ns / 1ps

module high_perf_control_unit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [2:0]  opcode,      // 3-bit opcode for basic 5 instructions
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

    // Opcode definitions (Simplified to 5 basic ones)
    localparam OPCODE_NOP = 3'b000;
    localparam OPCODE_ADD = 3'b001;
    localparam OPCODE_SUB = 3'b010;
    localparam OPCODE_AND = 3'b011;
    localparam OPCODE_OR  = 3'b100;
    
    // ALU Operation codes
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;
    localparam ALU_NOP = 3'b111;
    
    // Parallel decoding
    logic is_add, is_sub, is_and, is_or;
    
    assign is_add = (opcode == OPCODE_ADD);
    assign is_sub = (opcode == OPCODE_SUB);
    assign is_and = (opcode == OPCODE_AND);
    assign is_or  = (opcode == OPCODE_OR);
    
    // Internal signals for parallel logic
    logic        reg_write_comb;
    logic [2:0]  alu_op_comb;
    
    assign reg_write_comb = valid & (is_add | is_sub | is_and | is_or);
    
    // ALU Op selection (Parallel using OR-MUX logic)
    assign alu_op_comb = ({3{is_add}} & ALU_ADD) |
                         ({3{is_sub}} & ALU_SUB) |
                         ({3{is_and}} & ALU_AND) |
                         ({3{is_or}}  & ALU_OR)  |
                         ({3{~(is_add|is_sub|is_and|is_or)}} & ALU_NOP);

    // Synchronous outputs for high performance pipeline
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_write <= 1'b0;
            mem_read  <= 1'b0;
            mem_write <= 1'b0;
            alu_src   <= 1'b0;
            alu_op    <= ALU_NOP;
            branch    <= 1'b0;
            jump      <= 1'b0;
        end
        else begin
            reg_write <= reg_write_comb;
            alu_op    <= alu_op_comb;
            mem_read  <= 1'b0;
            mem_write <= 1'b0;
            alu_src   <= 1'b0;
            branch    <= 1'b0;
            jump      <= 1'b0;
        end
    end

endmodule
