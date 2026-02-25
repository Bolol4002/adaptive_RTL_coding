//=============================================================================
// Module: low_power_control_unit
// Description: Minimal Power-Efficient Control Unit with 5 basic opcodes.
//              Optimized for reduced switching activity.
//=============================================================================

`timescale 1ns / 1ps

module low_power_control_unit (
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

    // Opcode definitions
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
    
    // Registered outputs for power efficiency (prevents glitches)
    logic        reg_write_q;
    logic [2:0]  alu_op_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_write_q <= 1'b0;
            alu_op_q    <= ALU_NOP;
        end
        else if (valid) begin
            case (opcode)
                OPCODE_ADD: begin
                    reg_write_q <= 1'b1;
                    alu_op_q    <= ALU_ADD;
                end
                OPCODE_SUB: begin
                    reg_write_q <= 1'b1;
                    alu_op_q    <= ALU_SUB;
                end
                OPCODE_AND: begin
                    reg_write_q <= 1'b1;
                    alu_op_q    <= ALU_AND;
                end
                OPCODE_OR: begin
                    reg_write_q <= 1'b1;
                    alu_op_q    <= ALU_OR;
                end
                default: begin
                    reg_write_q <= 1'b0;
                    alu_op_q    <= ALU_NOP;
                end
            endcase
        end
        else begin
            // Hold values when not valid to reduce switching
            reg_write_q <= 1'b0;
            alu_op_q    <= ALU_NOP;
        end
    end
    
    assign reg_write = reg_write_q;
    assign alu_op    = alu_op_q;
    assign mem_read  = 1'b0;
    assign mem_write = 1'b0;
    assign alu_src   = 1'b0;
    assign branch    = 1'b0;
    assign jump      = 1'b0;

endmodule
