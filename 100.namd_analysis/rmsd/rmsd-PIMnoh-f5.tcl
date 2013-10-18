
set outfile [open rmsd-PIMnoh-f6-end.dat w];                                             
set nf [molinfo top get numframes]
set frame6 [atomselect top "segname PIM and noh" frame 6]
set sel [atomselect top "segname PIM and noh"]

# rmsd calculation loop

for {set i 7 } {$i < $nf } { incr i } {
    $sel frame $i
    $sel move [measure fit $sel $frame6]
    puts $outfile "[measure rmsd $sel $frame6]"
 }
close $outfile
