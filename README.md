# NAMD Equilibrated Systems
by: Dale R. Merz Jr.
====================
Setting up solvated NAMD systems

## Prepare your structure.
   Find it on the protein data bank.
Download PDB File (Text)
Alter the coordinates and sequence as necessary.

## PSFGEN: preparation
### Description: 
    Using the 000.NAMD_psfgen_package directory, let's create the psf file.
### Objective: 
    to correctly generate psf and pdb files for equilibration, in any
solvent (vacuum, implicit, explicit).
### Directions:
    1. name the pdb file accordingly, i.e. 00.pdb (see noh.pgn)
    2. Generate the protein structure with no hydrogens.
       On the command line, enter:
       >>> vmd -dispdev text -e noh.pgn > noh.log
    3. Generate the psf (protein structure file).
       On the command line, enter:
       >>> vmd -dispdev text -e psf.pgn > psf.log
    4. Start vmd.
       >>> vmd
       Open the TK Console window from the VMD Main -> Extensions -> TK Console.
       On the VMD TkConsole, enter:
       % source solvate.pgn
       % source ionize.pgn
       % exit
       Change the executed commands section. Identify 1st and last CA's.    
       >>> vmd -psf ionized.psf -pdb ionized.pdb
       % source load_rotate_origin_cminmax.tcl

### Results:
    You should have:
    1. start.pdb, start.psf ready for equilibration.
       hold.ref, hold_ca.ref
       Consider the Voth_Method

## Minimization & Equilibration
### Description: 
    Minimization and equilibration will remove internal potential energy and
    prepare systems for production simulations.
#### Vacuum: 
     minv.namd
#### Implicit: 
     mini.namd
#### Explicit: 
     mine.namd
#### Temperature Increases: 
     1. tempbyfor.namd: using a for loop
     2. tempbyreassign.namd: raising the temperature by reassign

## Voth Method / Equilibrating Explicitly Solvated Systems
### Description: 
    Follow the Voth methodology described in voth_method directory.
    1) downloaded 3BGM.pdb
    2) selected residues 37-42 residues, wrote 00.pdb (w/ 37-42 residues)
    3) mkdir prep
    4) cp 00.pdb prep
    5) cp ../../../000.NAMD_psfgen_package/* prep/
    6) follow README_psfgen_package
    7) mkdir ../equilibrate
    8) cp start.pdb start.psf center_minmax_start.dat ../equilibrate/
    8b)cp hold* par_all27* ../equilibrate/
    9) 