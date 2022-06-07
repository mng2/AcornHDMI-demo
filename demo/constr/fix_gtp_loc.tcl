
# we need to edit $proj_dir/$_xil_proj_name_.srcs/sources_1/ip/axi_pcie_x1g1/axi_pcie_x1g1/source/axi_pcie_X0Y0.xdc
# to set the correct lane mapping

# in this tcl.PRE environment the paths promised by UG894
# don't seem to work correctly in 2019.2
# [get_property DIRECTORY [current_project]]
# returns "."
# [current_project]
# returns "Project"
# [get_property DIRECTORY [current_run]]
# returns "./.runs/impl_1" ???
# so let's just make use of pwd to figure out where we are
set script_dir [pwd]
# which gives [...]proj_demo_dvi/proj_demo_dvi.runs/axi_pcie_x1g1_synth_1
cd ../..
set proj_dir [pwd]
set proj_name [file tail [pwd]]
# Vivado 2020.2 puts unmanaged source in a different dot-dir (grr)
set v [version]
set ver [string range $v 8 11]
if { $ver < 2020 } {
    set dotdir srcs
} else {
    set dotdir gen
}
set pcieloc $proj_dir/${proj_name}.${dotdir}/sources_1/ip/axi_pcie_x1g1

cd $pcieloc/axi_pcie_x1g1/source
set fd [open "axi_pcie_X0Y0.xdc" r]
# check first line to see if we've already modified it
# not so important for one lane but will mess up multiple lanes
gets $fd line
puts $line
if {[string match "*ALREADYMODIFIED*" $line]} {
    puts "xdc already modified, skipping"
    set domodify 0
} else {
    set newfd [open "temp.tmp" w]
    puts $newfd "# ALREADYMODIFIED"
    # hacky find/replace from https://stackoverflow.com/questions/36874745/tcl-replace-string-in-file
    while {[gets $fd line] >= 0} {
        set newline0 [string map {GTPE2_CHANNEL_X0Y7 SYMBOL_LANE0} $line]
        set newline4 [string map {SYMBOL_LANE0 GTPE2_CHANNEL_X0Y6} $newline0]
        puts $newfd $newline4
    }
    close $newfd
    set domodify 1
}
close $fd
if {$domodify==1} {
    file rename -force "temp.tmp" "axi_pcie_X0Y0.xdc"
    puts "modified xdc"
}
# go back to original start dir otherwise things don't work
cd $script_dir
