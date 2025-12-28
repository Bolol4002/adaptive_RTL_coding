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
        
        // Test all instructions in low-power mode
        test_instruction(OPCODE_NOP,    "NOP   ");
        test_instruction(OPCODE_ADD,    "ADD   ");
        test_instruction(OPCODE_SUB,    "SUB   ");
        test_instruction(OPCODE_AND,    "AND   ");
        test_instruction(OPCODE_OR,     "OR    ");
        test_instruction(OPCODE_XOR,    "XOR   ");
        test_instruction(OPCODE_LOAD,   "LOAD  ");
        test_instruction(OPCODE_STORE,  "STORE ");
        test_instruction(OPCODE_BRANCH, "BRANCH");
        test_instruction(OPCODE_JUMP,   "JUMP  ");
        test_instruction(OPCODE_SLL,    "SLL   ");
        test_instruction(OPCODE_SRL,    "SRL   ");
        
        $display("");
        
        //=====================================================================
        // TEST PHASE 2: High-Performance Mode Testing
        //=====================================================================
        $display("-----------------------------------------------------------");
        $display("  PHASE 2: HIGH-PERFORMANCE MODE (mode=1)");
        $display("-----------------------------------------------------------");
        mode = 1;
        
        // Test all instructions in high-performance mode
        test_instruction(OPCODE_NOP,    "NOP   ");
        test_instruction(OPCODE_ADD,    "ADD   ");
        test_instruction(OPCODE_SUB,    "SUB   ");
        test_instruction(OPCODE_AND,    "AND   ");
        test_instruction(OPCODE_OR,     "OR    ");
        test_instruction(OPCODE_XOR,    "XOR   ");
        test_instruction(OPCODE_LOAD,   "LOAD  ");
        test_instruction(OPCODE_STORE,  "STORE ");
        test_instruction(OPCODE_BRANCH, "BRANCH");
        test_instruction(OPCODE_JUMP,   "JUMP  ");
        test_instruction(OPCODE_SLL,    "SLL   ");
        test_instruction(OPCODE_SRL,    "SRL   ");
        
        $display("");
        
        //=====================================================================
        // TEST PHASE 3: Dynamic Mode Switching
        //=====================================================================
        $display("-----------------------------------------------------------");
        $display("  PHASE 3: DYNAMIC MODE SWITCHING");
        $display("-----------------------------------------------------------");
        
        // Start in low-power mode
        mode = 0;
        opcode = OPCODE_ADD;
        #(CLK_PERIOD*2);
        $display("  [%0t] Mode=LOW_POWER, Opcode=ADD", $time);
        $display("         power_mode_active=%b, perf_mode_active=%b", 
                 power_mode_active, perf_mode_active);
        
        // Switch to high-performance mode
        mode = 1;
        #(CLK_PERIOD*2);
        $display("  [%0t] Mode=HIGH_PERF, Opcode=ADD", $time);
        $display("         power_mode_active=%b, perf_mode_active=%b", 
                 power_mode_active, perf_mode_active);
        
        // Rapid mode switching
        $display("");
        $display("  Rapid Mode Switching Test:");
        repeat(5) begin
            mode = ~mode;
            opcode = $urandom_range(0, 11);
            #(CLK_PERIOD*2);
            $display("    [%0t] Mode=%s, Opcode=%b, RegWr=%b, ALUOp=%b",
                     $time, mode ? "HP" : "LP", opcode, reg_write, alu_op);
        end
        
        $display("");
        
        //=====================================================================
        // TEST PHASE 4: Valid Signal Testing
        //=====================================================================
        $display("-----------------------------------------------------------");
        $display("  PHASE 4: VALID SIGNAL BEHAVIOR");
        $display("-----------------------------------------------------------");
        
        mode = 1;
        opcode = OPCODE_ADD;
        
        // Test with valid = 1
        valid = 1;
        #(CLK_PERIOD*2);
        $display("  [%0t] valid=1, Opcode=ADD -> reg_write=%b", $time, reg_write);
        
        // Test with valid = 0
        valid = 0;
        #(CLK_PERIOD*2);
        $display("  [%0t] valid=0, Opcode=ADD -> reg_write=%b", $time, reg_write);
        
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
    task test_instruction(input [3:0] op, input string name);
        opcode = op;
        #(CLK_PERIOD*2);
        test_count++;
        
        // Basic verification (just check that outputs are valid)
        if (!$isunknown({reg_write, mem_read, mem_write, alu_src, alu_op, branch, jump})) begin
            pass_count++;
            $display("  [PASS] %s: RegWr=%b MemRd=%b MemWr=%b ALUSrc=%b ALUOp=%b Br=%b Jmp=%b",
                     name, reg_write, mem_read, mem_write, alu_src, alu_op, branch, jump);
        end
        else begin
            $display("  [FAIL] %s: Contains unknown values", name);
        end
    endtask

endmodule
