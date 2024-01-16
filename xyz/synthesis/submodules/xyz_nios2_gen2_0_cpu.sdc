# Legal Notice: (C)2024 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	xyz_nios2_gen2_0_cpu 	xyz_nios2_gen2_0_cpu:*
set 	xyz_nios2_gen2_0_cpu_oci 	xyz_nios2_gen2_0_cpu_nios2_oci:the_xyz_nios2_gen2_0_cpu_nios2_oci
set 	xyz_nios2_gen2_0_cpu_oci_break 	xyz_nios2_gen2_0_cpu_nios2_oci_break:the_xyz_nios2_gen2_0_cpu_nios2_oci_break
set 	xyz_nios2_gen2_0_cpu_ocimem 	xyz_nios2_gen2_0_cpu_nios2_ocimem:the_xyz_nios2_gen2_0_cpu_nios2_ocimem
set 	xyz_nios2_gen2_0_cpu_oci_debug 	xyz_nios2_gen2_0_cpu_nios2_oci_debug:the_xyz_nios2_gen2_0_cpu_nios2_oci_debug
set 	xyz_nios2_gen2_0_cpu_wrapper 	xyz_nios2_gen2_0_cpu_debug_slave_wrapper:the_xyz_nios2_gen2_0_cpu_debug_slave_wrapper
set 	xyz_nios2_gen2_0_cpu_jtag_tck 	xyz_nios2_gen2_0_cpu_debug_slave_tck:the_xyz_nios2_gen2_0_cpu_debug_slave_tck
set 	xyz_nios2_gen2_0_cpu_jtag_sysclk 	xyz_nios2_gen2_0_cpu_debug_slave_sysclk:the_xyz_nios2_gen2_0_cpu_debug_slave_sysclk
set 	xyz_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $xyz_nios2_gen2_0_cpu $xyz_nios2_gen2_0_cpu_oci]
set 	xyz_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $xyz_nios2_gen2_0_cpu_oci_path $xyz_nios2_gen2_0_cpu_oci_break]
set 	xyz_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $xyz_nios2_gen2_0_cpu_oci_path $xyz_nios2_gen2_0_cpu_ocimem]
set 	xyz_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $xyz_nios2_gen2_0_cpu_oci_path $xyz_nios2_gen2_0_cpu_oci_debug]
set 	xyz_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $xyz_nios2_gen2_0_cpu_oci_path $xyz_nios2_gen2_0_cpu_wrapper $xyz_nios2_gen2_0_cpu_jtag_tck]
set 	xyz_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $xyz_nios2_gen2_0_cpu_oci_path $xyz_nios2_gen2_0_cpu_wrapper $xyz_nios2_gen2_0_cpu_jtag_sysclk]
set 	xyz_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $xyz_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$xyz_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$xyz_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$xyz_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$xyz_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$xyz_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$xyz_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$xyz_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$xyz_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$xyz_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$xyz_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$xyz_nios2_gen2_0_cpu_jtag_sr*    -to *$xyz_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$xyz_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$xyz_nios2_gen2_0_cpu_oci_debug_path|monitor_go
