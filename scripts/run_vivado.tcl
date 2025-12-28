#=============================================================================
# Vivado TCL Script: run_vivado.tcl
# Description: Automates synthesis, implementation, and reporting in Vivado
# Usage: Open Vivado -> Tools -> Run Tcl Script -> Select this file
#        OR run from command line: vivado -mode batch -source run_vivado.tcl
#=============================================================================

# Project Settings - MODIFY THESE AS NEEDED
set project_name "adaptive_control_unit"
set project_dir  "./vivado_project"
set part_number  "xc7a35tcpg236-1"  ;# Basys3 FPGA, change for your board

# Source files location
set src_dir      "../src"
set tb_dir       "../tb"
set constr_dir   "../constraints"

#=============================================================================
# Create Project
#=============================================================================
puts "=============================================="
puts " Creating Vivado Project: $project_name"
puts "=============================================="

create_project $project_name $project_dir -part $part_number -force

#=============================================================================
# Add Source Files
#=============================================================================
puts "Adding design source files..."

add_files -norecurse [list \
    "$src_dir/low_power_control_unit.sv" \
    "$src_dir/high_perf_control_unit.sv" \
    "$src_dir/adaptive_control_unit.sv" \
    "$src_dir/top_adaptive_control.sv" \
]

#=============================================================================
# Add Simulation Files
#=============================================================================
puts "Adding simulation testbench files..."

add_files -fileset sim_1 -norecurse [list \
    "$tb_dir/tb_low_power_control_unit.sv" \
    "$tb_dir/tb_high_perf_control_unit.sv" \
    "$tb_dir/tb_adaptive_control_unit.sv" \
]

#=============================================================================
# Add Constraints
#=============================================================================
puts "Adding constraint files..."

add_files -fileset constrs_1 -norecurse "$constr_dir/constraints.xdc"

#=============================================================================
# Set Top Module
#=============================================================================
set_property top top_adaptive_control [current_fileset]
set_property top tb_adaptive_control_unit [get_filesets sim_1]

#=============================================================================
# Update Compile Order
#=============================================================================
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#=============================================================================
# Run Synthesis
#=============================================================================
puts ""
puts "=============================================="
puts " Running Synthesis..."
puts "=============================================="

launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Check synthesis status
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "ERROR: Synthesis failed!"
    exit 1
}
puts "Synthesis completed successfully!"

#=============================================================================
# Run Implementation
#=============================================================================
puts ""
puts "=============================================="
puts " Running Implementation..."
puts "=============================================="

launch_runs impl_1 -jobs 4
wait_on_run impl_1

# Check implementation status
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation failed!"
    exit 1
}
puts "Implementation completed successfully!"

#=============================================================================
# Generate Reports
#=============================================================================
puts ""
puts "=============================================="
puts " Generating Reports..."
puts "=============================================="

open_run impl_1

# Create reports directory
file mkdir "./reports"

# Timing Report
report_timing_summary -file "./reports/timing_summary.rpt"
puts "  - Timing summary report generated"

# Utilization Report
report_utilization -file "./reports/utilization.rpt"
puts "  - Utilization report generated"

# Power Report
report_power -file "./reports/power.rpt"
puts "  - Power report generated"

# Design Analysis Report
report_design_analysis -file "./reports/design_analysis.rpt"
puts "  - Design analysis report generated"

#=============================================================================
# Extract Key Metrics
#=============================================================================
puts ""
puts "=============================================="
puts " KEY METRICS SUMMARY"
puts "=============================================="

# Get timing information
set timing_slack [get_property SLACK [get_timing_paths -max_paths 1]]
puts "  Critical Path Slack: $timing_slack ns"

# Calculate Fmax from WNS
if {$timing_slack != ""} {
    set clock_period 10.0
    set achieved_period [expr {$clock_period - $timing_slack}]
    set fmax [expr {1000.0 / $achieved_period}]
    puts "  Max Frequency (Fmax): [format %.2f $fmax] MHz"
}

puts ""
puts "=============================================="
puts " PROJECT COMPLETED SUCCESSFULLY!"
puts "=============================================="
puts ""
puts "Reports saved in: ./reports/"
puts "  - timing_summary.rpt"
puts "  - utilization.rpt" 
puts "  - power.rpt"
puts "  - design_analysis.rpt"
puts ""
