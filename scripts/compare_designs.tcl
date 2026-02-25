#=============================================================================
# Vivado TCL Script: compare_designs.tcl
# Description: Synthesizes Low-Power and High-Performance units separately
#              and generates comparison reports
#=============================================================================

# Project Settings
set part_number "xc7a35tcpg236-1"
set src_dir "./src"

#=============================================================================
# Synthesize and Report: Low-Power Control Unit
#=============================================================================
puts "=============================================="
puts " Synthesizing LOW-POWER Control Unit"
puts "=============================================="

create_project lp_control "./vivado_lp" -part $part_number -force
add_files -norecurse "$src_dir/low_power_control_unit.sv"
set_property top low_power_control_unit [current_fileset]
update_compile_order -fileset sources_1

# Create clock constraint
create_clock -period 10.000 -name clk [get_ports clk]

synth_design -top low_power_control_unit -part $part_number
opt_design
place_design
route_design

file mkdir "./reports_comparison"

report_timing_summary -file "./reports_comparison/lp_timing.rpt"
report_utilization -file "./reports_comparison/lp_utilization.rpt"
report_power -file "./reports_comparison/lp_power.rpt"

# Extract metrics
set lp_slack [get_property SLACK [get_timing_paths -max_paths 1]]
set lp_luts [get_property USED [get_cells -hierarchical -filter {PRIMITIVE_TYPE =~ CLB.LUT.*}]]

puts "Low-Power Unit: Slack = $lp_slack ns, LUTs = $lp_luts"

close_project

#=============================================================================
# Synthesize and Report: High-Performance Control Unit
#=============================================================================
puts ""
puts "=============================================="
puts " Synthesizing HIGH-PERFORMANCE Control Unit"
puts "=============================================="

create_project hp_control "./vivado_hp" -part $part_number -force
add_files -norecurse "$src_dir/high_perf_control_unit.sv"
set_property top high_perf_control_unit [current_fileset]
update_compile_order -fileset sources_1

# Create clock constraint
create_clock -period 10.000 -name clk [get_ports clk]

synth_design -top high_perf_control_unit -part $part_number
opt_design
place_design
route_design

report_timing_summary -file "./reports_comparison/hp_timing.rpt"
report_utilization -file "./reports_comparison/hp_utilization.rpt"
report_power -file "./reports_comparison/hp_power.rpt"

# Extract metrics
set hp_slack [get_property SLACK [get_timing_paths -max_paths 1]]
set hp_luts [get_property USED [get_cells -hierarchical -filter {PRIMITIVE_TYPE =~ CLB.LUT.*}]]

puts "High-Perf Unit: Slack = $hp_slack ns, LUTs = $hp_luts"

close_project

#=============================================================================
# Summary Comparison
#=============================================================================
puts ""
puts "=============================================="
puts " COMPARISON SUMMARY"
puts "=============================================="
puts ""
puts "| Design Variant  | Timing Slack | LUTs |"
puts "|-----------------|--------------|------|"
puts "| Low-Power       | $lp_slack ns      | $lp_luts   |"
puts "| High-Performance| $hp_slack ns      | $hp_luts   |"
puts ""
puts "Reports saved in: ./reports_comparison/"
puts "=============================================="
