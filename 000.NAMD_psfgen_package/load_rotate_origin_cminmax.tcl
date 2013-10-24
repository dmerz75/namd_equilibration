#!/usr/bin/tclsh

# load_rotate_orient.tcl
# This script orients a protein on the Z-axis.

# mol new
# mol load, mol list, mol delete 7

# python equivalents
# load('pdb','alanine.pdb')
# load('psf','alanine.psf')

# set molecule [lindex $argv 0]
# puts $molecule
# exit

# source from TKCON
proc orient_protein_on_z { molec start end } {
    # protein
    set all [atomselect $molec all]

    set resid_CA_begin_coord [atomselect $molec "resid $start and name CA"]
    set resid_CA_end_coord [atomselect $molec "resid $end and name CA"]


    set pos_begin [measure center $resid_CA_begin_coord]
    # set inv_pos_begin [vecinvert [measure center $resid_CA_begin_coord]]
    set pos_end   [measure center $resid_CA_end_coord]

    # get the protein vector; $end - $begin for vecsub
    set protein_vector [vecsub $pos_end $pos_begin]
    set prot_on_x [transvecinv $protein_vector]

    # translate from x0,y0,z0 to {0.1 -0.5 0.08}
    # set inv_protein_vector [vecinvert [vecsub $pos_end $pos_begin]]
    # set inv_protein_vector [vecadd $inv_protein_vector {0.1 -0.05 0.08}]

    # translate: (1) near origin (2) to x axis
    # (1)
    # $all moveby $inv_pos_begin
    # (2)
    $all move $prot_on_x
    $all move [trans y -90]
    set pos_begin [vecinvert [measure center $resid_CA_begin_coord]]
    $all moveby $pos_begin
    $all moveby {0.01 -0.05 0.08}
    $all writepsf 00_start.psf
    $all writepdb 00_start.pdb

    set ptn_ca [atomselect $molec "segname PTN and name CA"]
    $ptn_ca set beta 1
    $all writepdb hold_ca.ref
    # $ptn_ca writepdb hold_ca.ref

    set ptn [atomselect $molec "segname PTN"]
    $ptn set beta 1
    $all writepdb hold.ref
    # $ptn writepdb hold.ref

}

proc draw_origin { molec x y z} {
    # draw dashed red lines on the scaled unit vectors
    puts "$molec"
    # set mol_id [mol new]
    # puts "$scaled_vector"
    set scaled_vector [vecscale $z {0 0 1}]
    graphics $molec color blue
    graphics $molec line {0 0 0} $scaled_vector width 8 style dashed
    set scaled_vector [vecscale $y {0 1 0}]
    graphics $molec color green
    graphics $molec line {0 0 0} $scaled_vector width 8 style dashed
    set scaled_vector [vecscale $x {1 0 0}]
    graphics $molec color red
    graphics $molec line {0 0 0} $scaled_vector width 8 style dashed
    # mol delete $molec
}

proc solvation { molec } {
    # package require psfgen
    # protein
    # source psf.pgn
    
    mol load psf mol_nw.psf pdb mol_nw.pdb
    package require solvate
    solvate vac.psf vac.pdb -t 9 -o wbox
    # autoionize -psf mol_wb.psf -pdb mol_wb.pdb -neutralize

    # # protein
    # set all [atomselect $molec all]
    # set mol_name [molinfo $molec get filename]
    # set f_id [lindex [split $mol_name .] 0]
    # set wb "wb_"
    # set fname "$wb$f_id"
    # solvate $
    
}

proc get_center_minmax { molec } {
    # protein
    mol load psf 00_start.psf pdb 00_start.pdb
    set all [atomselect $molec all]

    set mm [measure minmax $all]
    set cen [measure center $all]
    set mol_name [molinfo $molec get filename]
    # set f_id [lindex [split $mol_name .] 0]
    set f_id [lindex [split [split [lindex $mol_name 0] " "] "."] 0]
    set cm "center_minmax_"
    set fname "$cm$f_id.dat"
    set cellbasis [vecsub [lindex $mm 1] [lindex $mm 0]]

    set outfile [open $fname w];
    puts $outfile "# Molecule ID:"
    puts $outfile "$mol_name"
    puts $outfile "# Center:"
    puts $outfile "$cen"
    puts $outfile "# MinMax:"
    puts $outfile "$mm"
    puts $outfile "$cellbasis"
    close $outfile
    
    # set a1 [molinfo $molec get center_matrix]
    # rotate_matrix,global_matrix,scale_matrix,view_matrix


    draw_origin $molec 12.0 12.0 25.0
}


# _________________________
# Executed Commands Section

# _______
set idn 0
                    # CHANGE 1 (ID number from VMD Main)


# ___________________
# orient_protein_on_z
orient_protein_on_z $idn 37 42          
    # argv: molec first_residue second_residue
    #  - check ionized.pdb
    # hsp70 4,385

                    # CHANGE 2 (CA's to place on z-axis)

# ___________
# draw_origin
draw_origin $idn 12.0 12.0 25.0         
    # argv molec scaling
    # draw_origin $mol_id 5.0 5.0 15.0
                    
                    # OPTIONAL CHANGE (by system size)

# _________
# solvation
# argv --
# solvation 0
    # FIRST: use vmd -dispdev text -e noh.pgn
    # JUST: use vmd -pdb 00.pdb -dispdev text -e psf.pgn 

# _________________
# get_center_minmax
set idn2 [expr $idn + 1]
get_center_minmax $idn2
    # argv molec
