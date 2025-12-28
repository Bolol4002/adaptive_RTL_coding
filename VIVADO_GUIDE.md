# Adaptive RTL Control Unit - Vivado Quick Start Guide

## Project Structure

```
VLSI_PBL/
├── src/                          # Design source files
│   ├── low_power_control_unit.sv    # Power-efficient control unit
│   ├── high_perf_control_unit.sv    # High-performance control unit
│   ├── adaptive_control_unit.sv     # Adaptive wrapper module
│   └── top_adaptive_control.sv      # Top-level for synthesis
├── tb/                           # Testbench files
│   ├── tb_low_power_control_unit.sv
│   ├── tb_high_perf_control_unit.sv
│   └── tb_adaptive_control_unit.sv
├── constraints/                  # Constraint files
│   └── constraints.xdc
├── scripts/                      # Automation scripts
│   ├── run_vivado.tcl
│   └── compare_designs.tcl
└── README.md
```

---

## Quick Start - Xilinx Vivado

### Method 1: Using TCL Script (Recommended)

1. Open Vivado
2. Navigate to: **Tools → Run Tcl Script**
3. Browse to `scripts/run_vivado.tcl`
4. Click **OK**

This will automatically:
- Create the project
- Add all source files
- Run synthesis and implementation
- Generate timing, utilization, and power reports

### Method 2: Manual Project Setup

1. **Create New Project**
   - Open Vivado → Create Project
   - Name: `adaptive_control_unit`
   - Project Type: RTL Project

2. **Add Design Sources**
   - Add all `.sv` files from `src/` folder

3. **Add Simulation Sources**
   - Add all `.sv` files from `tb/` folder

4. **Add Constraints**
   - Add `constraints.xdc` from `constraints/` folder

5. **Set Top Module**
   - Right-click `top_adaptive_control` → Set as Top

---

## Running Simulation

1. In Vivado, go to **Flow Navigator → Simulation → Run Simulation**
2. Select **Run Behavioral Simulation**
3. Choose testbench:
   - `tb_adaptive_control_unit` - Complete adaptive unit test
   - `tb_low_power_control_unit` - Low-power unit only
   - `tb_high_perf_control_unit` - High-perf unit only

---

## Synthesis & Implementation

1. **Run Synthesis**: Flow Navigator → Run Synthesis
2. **Run Implementation**: Flow Navigator → Run Implementation
3. **Generate Bitstream** (optional): Flow Navigator → Generate Bitstream

---

## Viewing Reports (Key Metrics for Evaluation)

After implementation, open reports from:
- **Reports → Timing → Report Timing Summary**
- **Reports → Utilization → Report Utilization**
- **Reports → Power → Report Power**

### Key Metrics to Compare

| Metric | Low-Power Design | High-Performance Design |
|--------|------------------|------------------------|
| **Dynamic Power** | Lower | Higher |
| **LUT Count** | Lower | Higher |
| **Critical Path Delay** | Higher (slower) | Lower (faster) |
| **Max Frequency** | Lower | Higher |
| **Timing Slack** | May be negative | More positive |

---

## Design Comparison Script

To compare both designs side-by-side:

1. Open Vivado TCL Console
2. Run: `source scripts/compare_designs.tcl`

This generates comparison reports in `reports_comparison/` folder.

---

## Control Unit Operation

### Opcode Table

| Opcode | Binary | Instruction | reg_write | mem_read | mem_write | alu_op |
|--------|--------|-------------|-----------|----------|-----------|--------|
| 0000 | NOP | No operation | 0 | 0 | 0 | 111 |
| 0001 | ADD | Add | 1 | 0 | 0 | 000 |
| 0010 | SUB | Subtract | 1 | 0 | 0 | 001 |
| 0011 | AND | Bitwise AND | 1 | 0 | 0 | 010 |
| 0100 | OR | Bitwise OR | 1 | 0 | 0 | 011 |
| 0101 | XOR | Bitwise XOR | 1 | 0 | 0 | 100 |
| 0110 | LOAD | Load from memory | 1 | 1 | 0 | 000 |
| 0111 | STORE | Store to memory | 0 | 0 | 1 | 000 |
| 1000 | BRANCH | Conditional branch | 0 | 0 | 0 | 001 |
| 1001 | JUMP | Unconditional jump | 0 | 0 | 0 | 111 |
| 1010 | SLL | Shift left logical | 1 | 0 | 0 | 101 |
| 1011 | SRL | Shift right logical | 1 | 0 | 0 | 110 |

### Mode Selection

- **mode = 0**: Low-Power Mode (reduced switching activity)
- **mode = 1**: High-Performance Mode (parallel decoding, faster)

---

## Design Highlights

### Low-Power Control Unit
- Sequential/cascaded if-else decoding
- Clock gating via valid signal
- Registered outputs to minimize glitches
- Maintains state when no valid instruction

### High-Performance Control Unit
- Parallel one-hot decoding
- Precomputed control signals using OR gates
- Minimal critical path delay
- Immediate response to input changes

### Adaptive Wrapper
- Runtime mode switching
- MUX-based output selection
- Status indicators for current mode

---

## Expected Results

After synthesis and implementation, you should observe:

1. **Low-Power Unit**: Lower LUT count, lower power, but higher delay
2. **High-Performance Unit**: Higher LUT count, higher power, but lower delay
3. **Adaptive Unit**: Combined resources, flexible operation

This demonstrates that RTL coding style significantly impacts power and performance without changing the datapath architecture.
