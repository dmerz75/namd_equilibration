# NAMD Equilibrated Systems
===========================
Our test case is with amino acid residues 37-42 in protein 3bgm.

## Structure Preparations
Find it on the protein data bank.
Download PDB File (Text).
Next, alter the coordinates and sequence as necessary.
Finally, proceed to psfgen section.

## PSFGEN: protein structure file generation
Using the 000.NAMD_psfgen_package directory, let's create the psf file.
Let us start with a generic name, 00.pdb, for our starting protein coordinates,
in an empty directory called prep. (namd_equilibration/molecules_repo/3bgm/prep)

        cd molecules_repo

        mkdir 3bgm

        cd 3bgm

        mkdir prep

        cp ~/Downloads/3bgm.pdb prep/00.pdb

        cd prep

We need the tcl-based pgn scripts from 000.NAMD_psfgen_package directory.

        cp ../../../000.NAMD_psfgen_package/* .

Now, we use noh.pgn to remove the hydrogens from your protein.

        vmd -dispdev text -e noh.pgn > noh.log

*View source, [noh.pgn](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/noh.pgn).*

Generate the psf (protein structure file) using psf.pgn.

        vmd -dispdev text -e psf.pgn > psf.log

Start vmd.

        vmd

Open the TK Console window: ``VMD Main -> Extensions -> TK Console``.
On the VMD TkConsole (% indicates a TkCon commmand) enter:
Solvate your protein and balance your charge using solvate.pgn and ionize.pgn.

        % source solvate.pgn

        % source ionize.pgn

        % exit

Next, use load_rotate_origin_cminmax.tcl to rotate your protein, place the \alpha-carbon
of your choice near the origin (slightly shifted, 0.05,-0.1,0.02), obtain the minimum and
maximum dimensions of your solvated system and its center. These will be written to an outfile
titled, center_minmax_start.dat.
Note: Necessary adjustments to load_rotate_origin_cminmax.tcl include identifying the
\alpha-carbon residue positions that are to be aligned on the z-axis and the shift from the
origin you may desire.

        vmd -psf ionized.psf -pdb ionized.pdb

        % source load_rotate_origin_cminmax.tcl

You should have the following ready for equilibration

        ls *

        start.pdb start.psf hold.ref hold_ca.ref

## Minimization & Equilibration
Minimization and equilibration will remove internal potential energy and
prepare your system for production simulations.

        Vacuum: minv.namd
        Implicit: mini.namd
        Explicit: mine.namd
        Temperature Increases: tempbyfor.namd, tempbyreassign.namd

## Voth Method Equilibration 
For equilibrating explicitly solvated systems.

        mkdir ../equilibrate

        cp start* hold* par_all27* center_minmax_start.dat ../equilibrate/
