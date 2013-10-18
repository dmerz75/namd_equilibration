
set outfile [open rmsd_pepnoh.dat w];                                             
set nf [molinfo top get numframes]
set frame0 [atomselect top "segname PEP and noh" frame 0]
set sel [atomselect top "segname PEP and noh"]

# rmsd calculation loop
for {set i 1 } {$i < $nf } { incr i } {
    $sel frame $i
    $sel move [measure fit $sel $frame0]
    puts $outfile "[measure rmsd $sel $frame0]"
 }

close $outfile
