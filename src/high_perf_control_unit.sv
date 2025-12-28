//=============================================================================
// Module: high_perf_control_unit
// Description: High-Performance Control Unit optimized for faster execution
//              through parallel decoding and precomputed control signals.
//              Minimizes critical path delay at the cost of higher switching.
//=============================================================================

`timescale 1ns / 1ps

module high_perf_control_unit (
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
    // High-Performance Design Strategy:
    // 1. Parallel decoding using one-hot decoded signals
    // 2. Combinational logic for minimum critical path
    // 3. Precomputed control signals derived in parallel
    // 4. No clock gating - immediate response
    //=========================================================================
    
    // One-hot decoded instruction signals (parallel decoding)
    logic is_nop, is_add, is_sub, is_and, is_or, is_xor;
    logic is_load, is_store, is_branch, is_jump, is_sll, is_srl;
    
    // Parallel one-hot decoding - all comparisons happen simultaneously
    assign is_nop    = (opcode == OPCODE_NOP);
    assign is_add    = (opcode == OPCODE_ADD);
    assign is_sub    = (opcode == OPCODE_SUB);
    assign is_and    = (opcode == OPCODE_AND);
    assign is_or     = (opcode == OPCODE_OR);
    assign is_xor    = (opcode == OPCODE_XOR);
    assign is_load   = (opcode == OPCODE_LOAD);
    assign is_store  = (opcode == OPCODE_STORE);
    assign is_branch = (opcode == OPCODE_BRANCH);
    assign is_jump   = (opcode == OPCODE_JUMP);
    assign is_sll    = (opcode == OPCODE_SLL);
    assign is_srl    = (opcode == OPCODE_SRL);
    
    // Precomputed control signals - derived in parallel using OR gates
    // This minimizes the critical path by avoiding cascaded logic
    
    // Register Write: All ALU operations and LOAD
    logic reg_write_comb;
    assign reg_write_comb = valid & (is_add | is_sub | is_and | is_or | 
                                      is_xor | is_load | is_sll | is_srl);
    
    // Memory Read: Only LOAD instruction
    logic mem_read_comb;
    assign mem_read_comb = valid & is_load;
    
    // Memory Write: Only STORE instruction
    logic mem_write_comb;
    assign mem_write_comb = valid & is_store;
    
    // ALU Source: LOAD and STORE use immediate/offset
    logic alu_src_comb;
    assign alu_src_comb = valid & (is_load | is_store);
    
    // Branch signal
    logic branch_comb;
    assign branch_comb = valid & is_branch;
    
    // Jump signal
    logic jump_comb;
    assign jump_comb = valid & is_jump;
    
    // ALU Operation - parallel MUX using one-hot signals
    logic [2:0] alu_op_comb;
    assign alu_op_comb = ({3{is_add}}    & ALU_ADD) |
                         ({3{is_sub}}    & ALU_SUB) |
                         ({3{is_and}}    & ALU_AND) |
                         ({3{is_or}}     & ALU_OR)  |
                         ({3{is_xor}}    & ALU_XOR) |
                         ({3{is_sll}}    & ALU_SLL) |
                         ({3{is_srl}}    & ALU_SRL) |
                         ({3{is_load}}   & ALU_ADD) |  // Load uses ADD for address
                         ({3{is_store}}  & ALU_ADD) |  // Store uses ADD for address
                         ({3{is_branch}} & ALU_SUB) |  // Branch uses SUB for compare
                         ({3{is_nop | is_jump}} & ALU_NOP);
    
    // Output registers - single flip-flop stage for timing
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
            // Direct assignment - no conditional logic in sequential block
            reg_write <= reg_write_comb;
            mem_read  <= mem_read_comb;
            mem_write <= mem_write_comb;
            alu_src   <= alu_src_comb;
            alu_op    <= alu_op_comb;
            branch    <= branch_comb;
            jump      <= jump_comb;
        end
    end

endmodule
