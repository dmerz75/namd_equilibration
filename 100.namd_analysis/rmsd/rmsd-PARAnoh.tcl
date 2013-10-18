
set outfile [open rmsd-PARAnoh.dat w];                                             
set nf [molinfo top get numframes]
set frame0 [atomselect top "segname PARA and noh" frame 0]
set sel [atomselect top "segname PARA and noh"]

# rmsd calculation loop
for {set i 1 } {$i < $nf } { incr i } {
    $sel frame $i
    $sel move [measure fit $sel $frame0]
    puts $outfile "[measure rmsd $sel $frame0]"
 }

close $outfile
