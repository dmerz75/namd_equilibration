set outfile [open extCA1-4.dat w];                                             
set nf [molinfo top get numframes]

for {set i 0 } {$i < $nf } { incr i } {

# for 1-10
    set ca1 [atomselect top "resid 1 and name CA" frame $i]
    set ca10 [atomselect top "resid 10 and name CA" frame $i]

    set ca1pos [lindex [$ca1 get {x y z}] 0]
    set ca10pos [lindex [$ca10 get {x y z}] 0]
    set difvec110 [vecsub $ca10pos $ca1pos] 
    set dist110 [expr [veclength $difvec110]]
# for 2-9
    set ca2 [atomselect top "resid 2 and name CA" frame $i]
    set ca9 [atomselect top "resid 9 and name CA" frame $i]

    set ca2pos [lindex [$ca2 get {x y z}] 0]
    set ca9pos [lindex [$ca9 get {x y z}] 0]
    set difvec29 [vecsub $ca9pos $ca2pos] 
    set dist29 [expr [veclength $difvec29]]
# for 3-8
    set ca3 [atomselect top "resid 3 and name CA" frame $i]
    set ca8 [atomselect top "resid 8 and name CA" frame $i]

    set ca3pos [lindex [$ca3 get {x y z}] 0]
    set ca8pos [lindex [$ca8 get {x y z}] 0]
    set difvec38 [vecsub $ca8pos $ca3pos] 
    set dist38 [expr [veclength $difvec38]]
# for 4-7
    set ca4 [atomselect top "resid 4 and name CA" frame $i]
    set ca7 [atomselect top "resid 7 and name CA" frame $i]

    set ca4pos [lindex [$ca4 get {x y z}] 0]
    set ca7pos [lindex [$ca7 get {x y z}] 0]
    set difvec47 [vecsub $ca7pos $ca4pos] 
    set dist47 [expr [veclength $difvec47]]


    puts $outfile "$i $dist110 $dist29 $dist38 $dist47"
 }
close $outfile
