##=============================================================================
## Constraints File: constraints.xdc
## Description: Xilinx Vivado constraints for Adaptive Control Unit
##              Modify pin assignments according to your target FPGA board
##=============================================================================

## Clock constraint - 100 MHz system clock
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk_i]

## Input delay constraints
set_input_delay -clock sys_clk -max 2.0 [get_ports {opcode_i[*]}]
set_input_delay -clock sys_clk -min 0.5 [get_ports {opcode_i[*]}]
set_input_delay -clock sys_clk -max 2.0 [get_ports valid_i]
set_input_delay -clock sys_clk -min 0.5 [get_ports valid_i]
set_input_delay -clock sys_clk -max 2.0 [get_ports mode_i]
set_input_delay -clock sys_clk -min 0.5 [get_ports mode_i]
set_input_delay -clock sys_clk -max 2.0 [get_ports rst_n_i]
set_input_delay -clock sys_clk -min 0.5 [get_ports rst_n_i]

## Output delay constraints
set_output_delay -clock sys_clk -max 2.0 [get_ports reg_write_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports reg_write_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports mem_read_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports mem_read_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports mem_write_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports mem_write_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports alu_src_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports alu_src_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports {alu_op_o[*]}]
set_output_delay -clock sys_clk -min 0.5 [get_ports {alu_op_o[*]}]
set_output_delay -clock sys_clk -max 2.0 [get_ports branch_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports branch_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports jump_o]
set_output_delay -clock sys_clk -min 0.5 [get_ports jump_o]
set_output_delay -clock sys_clk -max 2.0 [get_ports led_power_mode]
set_output_delay -clock sys_clk -min 0.5 [get_ports led_power_mode]
set_output_delay -clock sys_clk -max 2.0 [get_ports led_perf_mode]
set_output_delay -clock sys_clk -min 0.5 [get_ports led_perf_mode]

##=============================================================================
## Example Pin Assignments for Artix-7 (Basys3/Nexys4 boards)
## Uncomment and modify according to your specific FPGA board
##=============================================================================

## Clock
# set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk_i]

## Reset (Active Low - connect to button)
# set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports rst_n_i]

## Opcode inputs (switches SW0-SW3)
# set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {opcode_i[0]}]
# set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {opcode_i[1]}]
# set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {opcode_i[2]}]
# set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {opcode_i[3]}]

## Valid input (switch SW4)
# set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports valid_i]

## Mode input (switch SW5)
# set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports mode_i]

## LED outputs
# set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports led_power_mode]
# set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports led_perf_mode]

## Control signal outputs (directly to LEDs for debugging)
# set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports reg_write_o]
# set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports mem_read_o]
# set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports mem_write_o]
# set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports alu_src_o]
# set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {alu_op_o[0]}]
# set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {alu_op_o[1]}]
# set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {alu_op_o[2]}]
# set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports branch_o]
# set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports jump_o]

##=============================================================================
## Power Analysis Settings
##=============================================================================

## Set switching activity for accurate power estimation
# set_switching_activity -type register -toggle_rate 12.5 -static_probability 0.5

##=============================================================================
## Configuration settings
##=============================================================================

# set_property CONFIG_VOLTAGE 3.3 [current_design]
# set_property CFGBVS VCCO [current_design]
