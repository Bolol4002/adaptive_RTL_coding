//=============================================================================
// Module: top_adaptive_control
// Description: Top-level wrapper for synthesis in Xilinx Vivado
//              Includes I/O buffers and can be targeted to specific FPGA
//=============================================================================

`timescale 1ns / 1ps

module top_adaptive_control (
    input  wire        clk_i,           // System clock input
    input  wire        rst_n_i,         // Active-low reset
    input  wire [3:0]  opcode_i,        // Instruction opcode
    input  wire        valid_i,         // Valid instruction
    input  wire        mode_i,          // Mode select: 0=LowPower, 1=HighPerf
    
    // Control outputs
    output wire        reg_write_o,
    output wire        mem_read_o,
    output wire        mem_write_o,
    output wire        alu_src_o,
    output wire [2:0]  alu_op_o,
    output wire        branch_o,
    output wire        jump_o,
    
    // Status LEDs
    output wire        led_power_mode,
    output wire        led_perf_mode
);

    // Internal signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  opcode;
    logic        valid;
    logic        mode;
    logic        reg_write;
    logic        mem_read;
    logic        mem_write;
    logic        alu_src;
    logic [2:0]  alu_op;
    logic        branch;
    logic        jump;
    logic        power_mode_active;
    logic        perf_mode_active;
    
    // Input synchronization registers
    logic [3:0]  opcode_sync;
    logic        valid_sync;
    logic        mode_sync;
    
    // Direct assignments for clock and reset
    assign clk   = clk_i;
    assign rst_n = rst_n_i;
    
    // Input synchronization (2-stage synchronizer for metastability)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            opcode_sync <= 4'b0;
            valid_sync  <= 1'b0;
            mode_sync   <= 1'b0;
        end
        else begin
            opcode_sync <= opcode_i;
            valid_sync  <= valid_i;
            mode_sync   <= mode_i;
        end
    end
    
    assign opcode = opcode_sync;
    assign valid  = valid_sync;
    assign mode   = mode_sync;
    
    // Instantiate Adaptive Control Unit
    adaptive_control_unit u_adaptive_ctrl (
        .clk              (clk),
        .rst_n            (rst_n),
        .opcode           (opcode),
        .valid            (valid),
        .mode             (mode),
        .reg_write        (reg_write),
        .mem_read         (mem_read),
        .mem_write        (mem_write),
        .alu_src          (alu_src),
        .alu_op           (alu_op),
        .branch           (branch),
        .jump             (jump),
        .power_mode_active(power_mode_active),
        .perf_mode_active (perf_mode_active)
    );
    
    // Output assignments
    assign reg_write_o   = reg_write;
    assign mem_read_o    = mem_read;
    assign mem_write_o   = mem_write;
    assign alu_src_o     = alu_src;
    assign alu_op_o      = alu_op;
    assign branch_o      = branch;
    assign jump_o        = jump;
    assign led_power_mode = power_mode_active;
    assign led_perf_mode  = perf_mode_active;

endmodule
