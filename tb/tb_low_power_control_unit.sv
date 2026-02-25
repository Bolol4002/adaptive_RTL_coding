//=============================================================================
// Testbench: tb_low_power_control_unit
// Description: Testbench for Low-Power Control Unit verification
//=============================================================================

`timescale 1ns / 1ps

module tb_low_power_control_unit;

    // Parameters
    localparam CLK_PERIOD = 10;
    
    // DUT Signals
    logic        clk;
    logic        rst_n;
    logic [2:0]  opcode;
    logic        valid;
    logic        reg_write;
    logic        mem_read;
    logic        mem_write;
    logic        alu_src;
    logic [2:0]  alu_op;
    logic        branch;
    logic        jump;
    
    // Opcode definitions
    localparam OPCODE_NOP = 3'b000;
    localparam OPCODE_ADD = 3'b001;
    localparam OPCODE_SUB = 3'b010;
    localparam OPCODE_AND = 3'b011;
    localparam OPCODE_OR  = 3'b100;
    
    // Instantiate DUT
    low_power_control_unit DUT (
        .clk        (clk),
        .rst_n      (rst_n),
        .opcode     (opcode),
        .valid      (valid),
        .reg_write  (reg_write),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .alu_src    (alu_src),
        .alu_op     (alu_op),
        .branch     (branch),
        .jump       (jump)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        rst_n  = 0;
        opcode = OPCODE_NOP;
        valid  = 0;
        
        // Display header
        $display("=================================================");
        $display("  Low-Power Control Unit Testbench");
        $display("=================================================");
        $display("Time\tOpcode\tValid\tRegWr\tALUOp");
        $display("-------------------------------------------------");
        
        // Reset sequence
        #(CLK_PERIOD*2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        // Test NOP
        valid = 1;
        opcode = OPCODE_NOP;
        #(CLK_PERIOD*2);
        $display("%0t\t%b\t%b\t%b\t%b", $time, opcode, valid, reg_write, alu_op);
        
        // Test ADD
        opcode = OPCODE_ADD;
        #(CLK_PERIOD*2);
        $display("%0t\t%b\t%b\t%b\t%b", $time, opcode, valid, reg_write, alu_op);
        
        // Test SUB
        opcode = OPCODE_SUB;
        #(CLK_PERIOD*2);
        $display("%0t\t%b\t%b\t%b\t%b", $time, opcode, valid, reg_write, alu_op);
        
        #(CLK_PERIOD*5);
        $finish;
    end

endmodule
