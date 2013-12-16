#!/bin/sh

function solvate {
    vmd -dispdev text -e noh.pgn > noh.log
    vmd -dispdev text -e psf.pgn > psf.log
    # vmd -dispdev text -e align_vac.tcl
    vmd -dispdev text -e solvate.pgn > solvate.log
    vmd -psf wbox.psf -pdb wbox.pdb
    vmd -dispdev text -e load_rotate_origin_cminmax.tcl
}
function resolvate {
    vmd -dispdev text -e solvate.pgn > solvate.log
    vmd -psf wbox.psf -pdb wbox.pdb && wait
    vmd -dispdev text -e load_rotate_origin_cminmax.tcl
}
