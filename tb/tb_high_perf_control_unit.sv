//=============================================================================
// Testbench: tb_high_perf_control_unit
// Description: Testbench for High-Performance Control Unit verification
//=============================================================================

`timescale 1ns / 1ps

module tb_high_perf_control_unit;

    // Parameters
    localparam CLK_PERIOD = 10;
    
    // DUT Signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  opcode;
    logic        valid;
    logic        reg_write;
    logic        mem_read;
    logic        mem_write;
    logic        alu_src;
    logic [2:0]  alu_op;
    logic        branch;
    logic        jump;
    
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
    
    // Instantiate DUT
    high_perf_control_unit DUT (
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
        $display("  High-Performance Control Unit Testbench");
        $display("=================================================");
        $display("Time\tOpcode\tValid\tRegWr\tMemRd\tMemWr\tALUSrc\tALUOp\tBranch\tJump");
        $display("-------------------------------------------------");
        
        // Reset sequence
        #(CLK_PERIOD*2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        // Test NOP
        valid = 1;
        opcode = OPCODE_NOP;
        #(CLK_PERIOD*2);
        display_outputs("NOP");
        
        // Test ADD
        opcode = OPCODE_ADD;
        #(CLK_PERIOD*2);
        display_outputs("ADD");
        
        // Test SUB
        opcode = OPCODE_SUB;
        #(CLK_PERIOD*2);
        display_outputs("SUB");
        
        // Test AND
        opcode = OPCODE_AND;
        #(CLK_PERIOD*2);
        display_outputs("AND");
        
        // Test OR
        opcode = OPCODE_OR;
        #(CLK_PERIOD*2);
        display_outputs("OR");
        
        // Test XOR
        opcode = OPCODE_XOR;
        #(CLK_PERIOD*2);
        display_outputs("XOR");
        
        // Test LOAD
        opcode = OPCODE_LOAD;
        #(CLK_PERIOD*2);
        display_outputs("LOAD");
        
        // Test STORE
        opcode = OPCODE_STORE;
        #(CLK_PERIOD*2);
        display_outputs("STORE");
        
        // Test BRANCH
        opcode = OPCODE_BRANCH;
        #(CLK_PERIOD*2);
        display_outputs("BRANCH");
        
        // Test JUMP
        opcode = OPCODE_JUMP;
        #(CLK_PERIOD*2);
        display_outputs("JUMP");
        
        // Test SLL
        opcode = OPCODE_SLL;
        #(CLK_PERIOD*2);
        display_outputs("SLL");
        
        // Test SRL
        opcode = OPCODE_SRL;
        #(CLK_PERIOD*2);
        display_outputs("SRL");
        
        // Test with valid = 0
        valid = 0;
        opcode = OPCODE_ADD;
        #(CLK_PERIOD*2);
        display_outputs("ADD(inv)");
        
        $display("=================================================");
        $display("  High-Performance Control Unit Test Complete");
        $display("=================================================");
        
        #(CLK_PERIOD*5);
        $finish;
    end
    
    // Task to display outputs
    task display_outputs(input string instr_name);
        $display("%0t\t%s\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time, instr_name, valid, reg_write, mem_read, 
                 mem_write, alu_src, alu_op, branch, jump);
    endtask

endmodule
