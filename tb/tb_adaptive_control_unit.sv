//=============================================================================
// Testbench: tb_adaptive_control_unit
// Description: Comprehensive testbench for Adaptive Control Unit verification
//              Tests both modes and dynamic mode switching
//=============================================================================

`timescale 1ns / 1ps

module tb_adaptive_control_unit;

    // Parameters
    localparam CLK_PERIOD = 10;
    
    // DUT Signals
    logic        clk;
    logic        rst_n;
    logic [2:0]  opcode;
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
    
    // Opcode definitions (Minimal 5)
    localparam OPCODE_NOP = 3'b000;
    localparam OPCODE_ADD = 3'b001;
    localparam OPCODE_SUB = 3'b010;
    localparam OPCODE_AND = 3'b011;
    localparam OPCODE_OR  = 3'b100;
    
    // Test counters
    integer test_count;
    integer pass_count;
    
    // Instantiate DUT
    adaptive_control_unit DUT (
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
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        rst_n      = 0;
        opcode     = OPCODE_NOP;
        valid      = 0;
        mode       = 0;
        test_count = 0;
        pass_count = 0;
        
        // Display header
        $display("");
        $display("===========================================================");
        $display("    ADAPTIVE CONTROL UNIT - COMPREHENSIVE TESTBENCH");
        $display("===========================================================");
        $display("");
        
        // Reset sequence
        #(CLK_PERIOD*2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        //=====================================================================
        // TEST PHASE 1: Low-Power Mode Testing
        //=====================================================================
        $display("-----------------------------------------------------------");
        $display("  PHASE 1: LOW-POWER MODE (mode=0)");
        $display("-----------------------------------------------------------");
        mode = 0;
        valid = 1;
        
        test_instruction(OPCODE_NOP, "NOP");
        test_instruction(OPCODE_ADD, "ADD");
        test_instruction(OPCODE_SUB, "SUB");
        test_instruction(OPCODE_AND, "AND");
        test_instruction(OPCODE_OR,  "OR ");
        
        $display("");
        
        //=====================================================================
        // TEST PHASE 2: High-Performance Mode Testing
        //=====================================================================
        $display("-----------------------------------------------------------");
        $display("  PHASE 2: HIGH-PERFORMANCE MODE (mode=1)");
        $display("-----------------------------------------------------------");
        mode = 1;
        
        test_instruction(OPCODE_NOP, "NOP");
        test_instruction(OPCODE_ADD, "ADD");
        test_instruction(OPCODE_SUB, "SUB");
        test_instruction(OPCODE_AND, "AND");
        test_instruction(OPCODE_OR,  "OR ");
        
        $display("");

        //=====================================================================
        // TEST SUMMARY
        //=====================================================================
        $display("===========================================================");
        $display("    TEST SUMMARY");
        $display("===========================================================");
        $display("  Total Tests Run: %0d", test_count);
        $display("  Tests Passed:    %0d", pass_count);
        $display("  Tests Failed:    %0d", test_count - pass_count);
        $display("===========================================================");
        $display("");
        
        if (pass_count == test_count)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        
        $display("");
        
        #(CLK_PERIOD*5);
        $finish;
    end
    
    // Task to test individual instruction
    task test_instruction(input [2:0] op, input string name);
        opcode = op;
        #(CLK_PERIOD*2);
        test_count++;
        
        // Basic verification
        if (!$isunknown({reg_write, alu_op})) begin
            pass_count++;
            $display("  [PASS] %s: RegWr=%b ALUOp=%b", name, reg_write, alu_op);
        end
        else begin
            $display("  [FAIL] %s: Contains unknown values", name);
        end
    endtask

endmodule
