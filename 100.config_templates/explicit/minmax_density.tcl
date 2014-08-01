#!/usr/bin/tclsh

proc get_center_minmax { molec } {
    # protein
    # mol load psf start.psf pdb start.pdb
    set all [atomselect $molec all]

    set mm [measure minmax $all]
    set cen [measure center $all]
    set mol_name [molinfo $molec get filename]
    # set f_id [lindex [split $mol_name .] 0]
    set f_id [lindex [split [split [lindex $mol_name 0] " "] "."] 0]
    set cm "center_minmax_"
    set fname "$cm$f_id.dat"
    set cellbasis [vecsub [lindex $mm 1] [lindex $mm 0]]

    set cbx [lindex $cellbasis 0]
    set cby [lindex $cellbasis 1]
    set cbz [lindex $cellbasis 2]
    set volume [expr $cbx * $cby * $cbz]

    set prot [atomselect top water]
    set size [$prot num]
    set num_waters [expr [$prot num] / 3]
    set density [expr $num_waters / $volume * 29.89]

    set outfile [open $fname w];
    puts $outfile "# Molecule ID:"
    puts $outfile "$mol_name"
    puts $outfile "# Center:"
    puts $outfile "$cen"
    puts $outfile "# MinMax:"
    puts $outfile "$mm"
    puts $outfile "# cellbasis:"
    puts $outfile "$cellbasis"
    puts $outfile "# Density:"
    puts $outfile "$density"
    close $outfile

}

# _________________________
# Executed Commands Section

# _______
# set idn 0
                    # CHANGE 1 (ID number from VMD Main)

# _________________
# get_center_minmax
# set idn2 [expr $idn + 1]
# get_center_minmax $idn2
    # argv molec
get_center_minmax 0
