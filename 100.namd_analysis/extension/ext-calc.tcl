

set outfile [open ext-ca110.dat w];                                             
set nf [molinfo top get numframes]

for {set i 0 } {$i < $nf } { incr i } {
    set beg [atomselect top "resid 1 and name CA" frame $i]
    set end [atomselect top "resid 10 and name CA" frame $i]

    set begpos [lindex [$beg get {x y z}] 0]
    set endpos [lindex [$end get {x y z}] 0]
    set difvec [vecsub $endpos $begpos] 
    set dist [expr [veclength $difvec]]

    puts $outfile "$i $dist"
 }
close $outfile
