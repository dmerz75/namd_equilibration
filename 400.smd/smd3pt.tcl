# Atoms selected for force application
set id1 [atomid P1 17 CA]
set grp1 {}
lappend grp1 $id1
set a1 [addgroup $grp1]

set id2 [atomid P1 32 CA]
set grp2 {}
lappend grp2 $id2
set a2 [addgroup $grp2]

set id3 [atomid P1 44 CA]
set grp3 {}
lappend grp3 $id3
set a3 [addgroup $grp3]


# set the output frequency, initialize the time counter
set Tclfreq 50
set t 0

# constraint points
set c1x 54.1
set c1y 140.0
set c1z 30.0

set c2x 51.2
set c2y 115.0
set c2z 105.0

set c3x 51.7
set c3y 48.0
set c3z 82.0


# force constant (kcal/mol/A^2)
# set k 7.2
set k 2.0

# pulling velocity (A/timestep)
set v 0.0000

set outfilename da_smd_tcl.out
open $outfilename w

proc calcforces {} {

    global Tclfreq t k v a1 a2 c1x c1y c1z c2x c2y c2z outfilename
    global a3 c3x c3y c3z

    # get coordinates
    loadcoords coordinate

    set r1 $coordinate($a1)
    set r1x [lindex $r1 0]
    set r1y [lindex $r1 1]
    set r1z [lindex $r1 2]

    set r2 $coordinate($a2)
    set r2x [lindex $r2 0]
    set r2y [lindex $r2 1]
    set r2z [lindex $r2 2]

    set r3 $coordinate($a3)
    set r3x [lindex $r3 0]
    set r3y [lindex $r3 1]
    set r3z [lindex $r3 2]

    # calculate forces

    set f1x [expr $k*($c1x-$r1x)]
    set f1y [expr $k*($c1y-$r1y)]
    set f1z [expr $k*($c1z-$r1z)]
    lappend f1 $f1x $f1y $f1z

    set f2x [expr $k*($c2x-$r2x)]
    set f2y [expr $k*($c2y-$r2y)]
    set f2z [expr $k*($c2z+$v*$t-$r2z)]
    lappend f2 $f2x $f2y $f2z

    set f3x [expr $k*($c3x-$r3x)]
    set f3y [expr $k*($c3y-$r3y)]
    set f3z [expr $k*($c3z+$v*$t-$r3z)]
    lappend f3 $f3x $f3y $f3z

    # apply forces
    addforce $a1 $f1
    addforce $a2 $f2
    addforce $a3 $f3

    # output
    set foo [expr $t % $Tclfreq]
    if { $foo == 0 } {
        set outfile [open $outfilename a]
        set time [expr $t*1.0/1000.0]
        puts $outfile "$time $r2z $f2z"
        close $outfile
    }
    incr t
    return
}
