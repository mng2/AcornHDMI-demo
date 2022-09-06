#*****************************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Tcl script for re-creating project
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "proj_demo_dvi"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "proj_demo_dvi.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/proj_demo_dvi"]"

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a200tfbg484-3

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xc7a200tfbg484-3" -objects $obj
set_property -name "platform.description" -value "Vivado generated DSA" -objects $obj
set_property -name "platform.uses_pr" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
#set obj [get_filesets sources_1]

# Rebuild user ip_repo's index before adding any source files
#update_ip_catalog -rebuild

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_package.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_boot_rom.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_bus_keeper.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_busswitch.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cfs.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_alu.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_bus.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_control.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_cp_bitmanip.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_cp_fpu.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_cp_muldiv.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_cp_shifter.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_decompressor.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_cpu_regfile.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_debug_dm.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_debug_dtm.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_dmem.entity.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/mem/neorv32_dmem.default.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_fifo.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_gpio.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_gptmr.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_icache.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_imem.entity.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/mem/neorv32_imem.default.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_mtime.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_neoled.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_pwm.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_slink.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_spi.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_sysinfo.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_twi.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_wdt.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_wishbone.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_xirq.vhd"] \
 [file normalize "${origin_dir}/../ip/neorv32/rtl/core/neorv32_application_image.vhd"] \
 [file normalize "${origin_dir}/src/interface_axi.sv"] \
 [file normalize "${origin_dir}/src/interface_wishbone.sv"] \
 [file normalize "${origin_dir}/src/interface_mig.sv"] \
 [file normalize "${origin_dir}/src/pkg_dvi.sv"] \
 [file normalize "${origin_dir}/src/pkg_mig_framebuffer.sv"] \
 [file normalize "${origin_dir}/src/clock_wrapper.sv"] \
 [file normalize "${origin_dir}/src/mig_acorn_wrapper.sv"] \
 [file normalize "${origin_dir}/src/tmds_xmitter.sv"] \
 [file normalize "${origin_dir}/src/hdmi_xmitter.sv"] \
 [file normalize "${origin_dir}/src/framebuffer_wishbone.sv"] \
 [file normalize "${origin_dir}/src/xadc_wishbone.sv"] \
 [file normalize "${origin_dir}/src/fake_16550A.sv"] \
 [file normalize "${origin_dir}/src/axi_pcie_wrapper.sv"] \
 [file normalize "${origin_dir}/src/axi_to_axilite_wrapper.sv"] \
 [file normalize "${origin_dir}/src/width_change_wrapper.sv"] \
 [file normalize "${origin_dir}/src/neorv32_uart_cut.vhd"] \
 [file normalize "${origin_dir}/src/neorv32_test_setup_bootloader.vhd"] \
 [file normalize "${origin_dir}/bootl/neorv32_bootloader_image.vhd"] \
 [file normalize "${origin_dir}/src/neorv32_top.vhd"] \
 [file normalize "${origin_dir}/src/axi_pcie_example_top.sv"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_package.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/src/neorv32_test_setup_bootloader.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_application_image.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/bootl/neorv32_bootloader_image.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_boot_rom.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_bus_keeper.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_busswitch.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cfs.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_alu.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_bus.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_control.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_cp_bitmanip.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_cp_fpu.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_cp_muldiv.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_cp_shifter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_decompressor.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_cpu_regfile.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_debug_dm.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_debug_dtm.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_dmem.entity.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/mem/neorv32_dmem.default.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_fifo.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_gpio.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_gptmr.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_icache.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_imem.entity.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/mem/neorv32_imem.default.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_mtime.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_neoled.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_pwm.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_slink.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_spi.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_sysinfo.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/src/neorv32_top.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_twi.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_wdt.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_wishbone.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/../ip/neorv32/rtl/core/neorv32_xirq.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

set file "$origin_dir/src/neorv32_uart_cut.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "neorv32" -objects $file_obj

# Set 'sources_1' fileset file properties for local files

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "axi_pcie_example_top" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constr/pins.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "pins.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constr/timing.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "timing.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constr/debug.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "debug.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constr/bitstream.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "bitstream.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "[get_files debug.xdc]" -objects $obj
set_property -name "target_part" -value "xc7a200tfbg484-3" -objects $obj
set_property -name "target_ucf" -value "[get_files debug.xdc]" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "axi_pcie_example_top" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a200tfbg484-3 -flow {Vivado Synthesis 2019} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2019" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "part" -value "xc7a200tfbg484-3" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a200tfbg484-3 -flow {Vivado Implementation 2019} -strategy "Performance_ExtraTimingOpt" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Performance_ExtraTimingOpt" [get_runs impl_1]
  set_property flow "Vivado Implementation 2019" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {

}
set obj [get_runs impl_1]
set_property -name "part" -value "xc7a200tfbg484-3" -objects $obj
set_property -name "strategy" -value "Performance_ExtraTimingOpt" -objects $obj
set_property -name "steps.place_design.args.directive" -value "ExtraTimingOpt" -objects $obj
set_property -name "steps.phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "Explore" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.write_bitstream.args.bin_file" -value "1" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${_xil_proj_name_}"

# generate ip

create_ip -name axi_pcie -vendor xilinx.com -library ip -module_name axi_pcie_x1g1
set_property -dict [list CONFIG.Component_Name {axi_pcie_x1g1}\
 CONFIG.NO_OF_LANES {X1} CONFIG.MAX_LINK_SPEED {2.5_GT/s}\
 CONFIG.VENDOR_ID {0x9710} CONFIG.DEVICE_ID {0x9922}\
 CONFIG.SUBSYSTEM_VENDOR_ID {0xA000} CONFIG.SUBSYSTEM_ID {0x1000}\
 CONFIG.ENABLE_CLASS_CODE {false}\
 CONFIG.BASE_CLASS_MENU {Simple_communication_controllers}\
 CONFIG.SUB_CLASS_INTERFACE_MENU {16550_compatible_serial_controller}\
 CONFIG.NUM_MSI_REQ {0} CONFIG.CLASS_CODE {0x070002}\
 CONFIG.shared_logic_in_core {false}\
 CONFIG.S_AXI_DATA_WIDTH {64} CONFIG.M_AXI_DATA_WIDTH {64}] [get_ips axi_pcie_x1g1]
set pcieloc $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/axi_pcie_x1g1
generate_target all [get_files $pcieloc/axi_pcie_x1g1.xci]
export_ip_user_files -of_objects [get_files $pcieloc/axi_pcie_x1g1.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $pcieloc/axi_pcie_x1g1.xci]
set_property strategy Flow_PerfOptimized_high [get_runs axi_pcie_x1g1_synth_1]
set_property IS_MANAGED false [get_files $pcieloc/axi_pcie_x1g1.xci]
# we need to edit /ip/axi_pcie_x1g1/axi_pcie_x1g1/source/axi_pcie_X0Y0.xdc
# to set the correct lane mapping
# hacky find/replace from https://stackoverflow.com/questions/36874745/tcl-replace-string-in-file
cd $pcieloc/axi_pcie_x1g1/source
set fd [open "axi_pcie_X0Y0.xdc" r]
set newfd [open "temp.tmp" w]
while {[gets $fd line] >= 0} {
    set newline0 [string map {GTPE2_CHANNEL_X0Y7 SYMBOL_LANE0} $line]
    set newline4 [string map {SYMBOL_LANE0 GTPE2_CHANNEL_X0Y6} $newline0]
    puts $newfd $newline4
}
close $fd
close $newfd
file rename -force "temp.tmp" "axi_pcie_X0Y0.xdc"
cd $proj_dir/..

create_ip -name axi_dwidth_converter -vendor xilinx.com -library ip -module_name axi_dwconv_64_32
set_property -dict [list CONFIG.Component_Name {axi_dwconv_64_32}\
 CONFIG.SI_DATA_WIDTH {64} CONFIG.MI_DATA_WIDTH {32}\
 CONFIG.SI_ID_WIDTH {0}] [get_ips axi_dwconv_64_32]
set iploc $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/axi_dwconv_64_32
generate_target all [get_files $iploc/axi_dwconv_64_32.xci]
export_ip_user_files -of_objects [get_files $iploc/axi_dwconv_64_32.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $iploc/axi_dwconv_64_32.xci]

create_ip -name axi_protocol_converter -vendor xilinx.com -library ip -module_name axi_to_axilite
set_property -dict [list CONFIG.Component_Name {axi_to_axilite}] [get_ips axi_to_axilite]
set iploc $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/axi_to_axilite
generate_target all [get_files $iploc/axi_to_axilite.xci]
export_ip_user_files -of_objects [get_files $iploc/axi_to_axilite.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $iploc/axi_to_axilite.xci]

cd $proj_dir
file copy ../mig/mig_acorn_8Gb_DDR3.prj $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/mig_a.prj
create_ip -name mig_7series -vendor xilinx.com -library ip -module_name mig_7series_0
set_property -dict [list CONFIG.XML_INPUT_FILE {../mig_a.prj} CONFIG.RESET_BOARD_INTERFACE {Custom} CONFIG.MIG_DONT_TOUCH_PARAM {Custom} CONFIG.BOARD_MIG_PARAM {Custom} CONFIG.SYSTEM_RESET.INSERT_VIP {0} CONFIG.CLK_REF_I.INSERT_VIP {0} CONFIG.RESET.INSERT_VIP {0} CONFIG.DDR3_RESET.INSERT_VIP {0} CONFIG.DDR2_RESET.INSERT_VIP {0} CONFIG.LPDDR2_RESET.INSERT_VIP {0} CONFIG.QDRIIP_RESET.INSERT_VIP {0} CONFIG.RLDII_RESET.INSERT_VIP {0} CONFIG.RLDIII_RESET.INSERT_VIP {0} CONFIG.CLOCK.INSERT_VIP {0} CONFIG.MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S_AXI_CTRL.INSERT_VIP {0} CONFIG.S_AXI.INSERT_VIP {0} CONFIG.SYS_CLK_I.INSERT_VIP {0} CONFIG.ARESETN.INSERT_VIP {0} CONFIG.C0_RESET.INSERT_VIP {0} CONFIG.C0_DDR3_RESET.INSERT_VIP {0} CONFIG.C0_DDR2_RESET.INSERT_VIP {0} CONFIG.C0_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C0_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C0_RLDII_RESET.INSERT_VIP {0} CONFIG.C0_RLDIII_RESET.INSERT_VIP {0} CONFIG.C0_CLOCK.INSERT_VIP {0} CONFIG.C0_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C0_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C0_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C0_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C0_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S0_AXI_CTRL.INSERT_VIP {0} CONFIG.S0_AXI.INSERT_VIP {0} CONFIG.C0_SYS_CLK_I.INSERT_VIP {0} CONFIG.C0_ARESETN.INSERT_VIP {0} CONFIG.C1_RESET.INSERT_VIP {0} CONFIG.C1_DDR3_RESET.INSERT_VIP {0} CONFIG.C1_DDR2_RESET.INSERT_VIP {0} CONFIG.C1_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C1_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C1_RLDII_RESET.INSERT_VIP {0} CONFIG.C1_RLDIII_RESET.INSERT_VIP {0} CONFIG.C1_CLOCK.INSERT_VIP {0} CONFIG.C1_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C1_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C1_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C1_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C1_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S1_AXI_CTRL.INSERT_VIP {0} CONFIG.S1_AXI.INSERT_VIP {0} CONFIG.C1_SYS_CLK_I.INSERT_VIP {0} CONFIG.C1_ARESETN.INSERT_VIP {0} CONFIG.C2_RESET.INSERT_VIP {0} CONFIG.C2_DDR3_RESET.INSERT_VIP {0} CONFIG.C2_DDR2_RESET.INSERT_VIP {0} CONFIG.C2_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C2_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C2_RLDII_RESET.INSERT_VIP {0} CONFIG.C2_RLDIII_RESET.INSERT_VIP {0} CONFIG.C2_CLOCK.INSERT_VIP {0} CONFIG.C2_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C2_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C2_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C2_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C2_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S2_AXI_CTRL.INSERT_VIP {0} CONFIG.S2_AXI.INSERT_VIP {0} CONFIG.C2_SYS_CLK_I.INSERT_VIP {0} CONFIG.C2_ARESETN.INSERT_VIP {0} CONFIG.C3_RESET.INSERT_VIP {0} CONFIG.C3_DDR3_RESET.INSERT_VIP {0} CONFIG.C3_DDR2_RESET.INSERT_VIP {0} CONFIG.C3_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C3_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C3_RLDII_RESET.INSERT_VIP {0} CONFIG.C3_RLDIII_RESET.INSERT_VIP {0} CONFIG.C3_CLOCK.INSERT_VIP {0} CONFIG.C3_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C3_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C3_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C3_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C3_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S3_AXI_CTRL.INSERT_VIP {0} CONFIG.S3_AXI.INSERT_VIP {0} CONFIG.C3_SYS_CLK_I.INSERT_VIP {0} CONFIG.C3_ARESETN.INSERT_VIP {0} CONFIG.C4_RESET.INSERT_VIP {0} CONFIG.C4_DDR3_RESET.INSERT_VIP {0} CONFIG.C4_DDR2_RESET.INSERT_VIP {0} CONFIG.C4_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C4_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C4_RLDII_RESET.INSERT_VIP {0} CONFIG.C4_RLDIII_RESET.INSERT_VIP {0} CONFIG.C4_CLOCK.INSERT_VIP {0} CONFIG.C4_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C4_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C4_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C4_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C4_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S4_AXI_CTRL.INSERT_VIP {0} CONFIG.S4_AXI.INSERT_VIP {0} CONFIG.C4_SYS_CLK_I.INSERT_VIP {0} CONFIG.C4_ARESETN.INSERT_VIP {0} CONFIG.C5_RESET.INSERT_VIP {0} CONFIG.C5_DDR3_RESET.INSERT_VIP {0} CONFIG.C5_DDR2_RESET.INSERT_VIP {0} CONFIG.C5_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C5_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C5_RLDII_RESET.INSERT_VIP {0} CONFIG.C5_RLDIII_RESET.INSERT_VIP {0} CONFIG.C5_CLOCK.INSERT_VIP {0} CONFIG.C5_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C5_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C5_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C5_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C5_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S5_AXI_CTRL.INSERT_VIP {0} CONFIG.S5_AXI.INSERT_VIP {0} CONFIG.C5_SYS_CLK_I.INSERT_VIP {0} CONFIG.C5_ARESETN.INSERT_VIP {0} CONFIG.C6_RESET.INSERT_VIP {0} CONFIG.C6_DDR3_RESET.INSERT_VIP {0} CONFIG.C6_DDR2_RESET.INSERT_VIP {0} CONFIG.C6_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C6_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C6_RLDII_RESET.INSERT_VIP {0} CONFIG.C6_RLDIII_RESET.INSERT_VIP {0} CONFIG.C6_CLOCK.INSERT_VIP {0} CONFIG.C6_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C6_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C6_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C6_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C6_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S6_AXI_CTRL.INSERT_VIP {0} CONFIG.S6_AXI.INSERT_VIP {0} CONFIG.C6_SYS_CLK_I.INSERT_VIP {0} CONFIG.C6_ARESETN.INSERT_VIP {0} CONFIG.C7_RESET.INSERT_VIP {0} CONFIG.C7_DDR3_RESET.INSERT_VIP {0} CONFIG.C7_DDR2_RESET.INSERT_VIP {0} CONFIG.C7_LPDDR2_RESET.INSERT_VIP {0} CONFIG.C7_QDRIIP_RESET.INSERT_VIP {0} CONFIG.C7_RLDII_RESET.INSERT_VIP {0} CONFIG.C7_RLDIII_RESET.INSERT_VIP {0} CONFIG.C7_CLOCK.INSERT_VIP {0} CONFIG.C7_MMCM_CLKOUT0.INSERT_VIP {0} CONFIG.C7_MMCM_CLKOUT1.INSERT_VIP {0} CONFIG.C7_MMCM_CLKOUT2.INSERT_VIP {0} CONFIG.C7_MMCM_CLKOUT3.INSERT_VIP {0} CONFIG.C7_MMCM_CLKOUT4.INSERT_VIP {0} CONFIG.S7_AXI_CTRL.INSERT_VIP {0} CONFIG.S7_AXI.INSERT_VIP {0} CONFIG.C7_SYS_CLK_I.INSERT_VIP {0} CONFIG.C7_ARESETN.INSERT_VIP {0}] [get_ips mig_7series_0]
set iploc $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/mig_7series_0
generate_target all [get_files $iploc/mig_7series_0.xci]
export_ip_user_files -of_objects [get_files $iploc/mig_7series_0.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $iploc/mig_7series_0.xci]
