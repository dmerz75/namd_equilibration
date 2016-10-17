# NAMD Equilibrated Systems
Our test case is with amino acid residues 37-42 in protein 3bgm.

## Structure Preparations
Find it on the protein data bank.
Download PDB File (Text).
Next, alter the coordinate file and select the segments you want to simulate.
Finally, proceed to psfgen section.

### PSFGEN: protein structure file generation
Using the 000.NAMD_psfgen_package directory, let's create the psf file.
Let us start with a generic name, 00.pdb, for our starting protein coordinates,
in an empty directory called prep. (namd_equilibration/molecules_repo/3bgm/prep)

        cd molecules_repo

        mkdir 3bgm

        cd 3bgm

        mkdir prep

        cp ~/Downloads/3bgm.pdb prep/00.pdb

        cd prep

We need the pgn (tcl) scripts from 000.NAMD_psfgen_package directory.

        cp ../../../000.NAMD_psfgen_package/* .

Now, we use 1.noh.pgn to remove the hydrogens from your protein. You'll need to edit 1.noh.pgn to contain
a valid molecule selection. (i.e. For a single chain molecule, try uncommenting the "set noh1 [atomselect 0 noh]" line)

        vmd -dispdev text -e 1.noh.pgn > noh.log

Check noh.log to see if everything ran correctly. You should see something similar to the following:

        Info) Finished with coordinate file 00.pdb.
        Info) Opened coordinate file p1noh.pdb for writing.
        Info) Finished with coordinate file p1noh.pdb.
        psfplugin) WARNING: PSF file is incomplete, no angles, dihedrals,
        psfplugin)          impropers, or cross-terms will be written.
        Info) Opened coordinate file p1noh.psf for writing.
        Info) Finished with coordinate file p1noh.psf.
        Info) VMD for LINUXAMD64, version 1.9.2 (December 29, 2014)
        Info) Exiting normally.

*View source, [noh.pgn](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/noh.pgn).*

Generate the psf (protein structure file) using psf.pgn. First, insert the first and last resid's before calling the `orient_on_z $idn 397 603`:
Change the '397' and '603' to the first and last resids from p1noh.pdb, written in the last step.

        vmd -dispdev text -e 2.psf.pgn > psf.log

Alternatives:
* if Waters or residues Histidine or Isoleucine are in your protein coordinates, consider altering psf.pgn after the `topology top_all27_prot_lipid.rtf` and before `segment PTN {`:

        topology top_all27_prot_lipid.rtf

        pdbalias residue HIS HSE
        pdbalias residue HOH TIP3
        pdbalias atom ILE CD1 CD
        pdbalias atom HOH O OH2

        segment PTN {
          pdb noh.pdb
          }

* if capping alternatives for your protein or peptide are required, consider capping your protein by inserting the following snippets between the `segment PTN{}`:

        # build protein segment
        segment PTN {
          pdb noh.pdb
          first ACE
          # last CT3
          # last none
          last CT2
          }

Check psf.log to see if everything ran correctly. You should see something similar to the following:

        psfplugin) Writing angles/dihedrals/impropers...
        Info) Opened coordinate file vac.psf for writing.
        Info) Finished with coordinate file vac.psf.
        Info) Opened coordinate file vac.pdb for writing.
        Info) Finished with coordinate file vac.pdb.
        Info) Exiting normally.

*View source, [psf.pgn](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/psf.pgn).*

Solvate your protein and balance your charge using solvate.pgn and ionize.pgn.

        vmd -dispdev text -e 3.solvate.pgn > solvate.log

Check that your molecule is adequately solvated from all sides:

        vmd -psf wbox.psf -pdb wbox.pdb

If satisfied:

`VMD Main` -> `Extensions` -> `Tk Console`:

        % source 4.vmd.ionize.pgn

Alternatives for solvate.pgn:
* Proper solvation is needed here:

        proc solvation { molec } {
            mol load psf vac.psf pdb vac.pdb
            package require solvate
            # solvate vac.psf vac.pdb -t 7 -o wbox
            solvate vac.psf vac.pdb -x 6 -y 5 -z 5 +x 6 +y 5 +z 22 -o wbox
            }

*View source, [solvate.pgn](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/solvate.pgn).*

Alternatives for ionize.pgn:
* *See [alternate ionization options](www.ks.uiuc.edu/Research/vmd/plugins/autoionize).*

* *View source, [ionize.pgn](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/ionize.pgn).*


Next, use load_rotate_origin_cminmax.tcl to rotate your protein, place the alpha-carbon
of your choice near the origin (slightly shifted, 0.05,-0.1,0.02), obtain the minimum and
maximum dimensions of your solvated system and its center. These will be written to an outfile
titled, center_minmax_start.dat.
Note: Necessary adjustments to load_rotate_origin_cminmax.tcl include identifying the
alpha-carbon residue positions that are to be aligned on the z-axis and the shift from the
origin you may desire.

* Identify the first and last residues, edit load_rotate_origin_cminmax.tcl

* View source, [load_rotate_origin_cminmax.tcl](https://github.com/dmerz75/namd_equilibration/blob/master/000.NAMD_psfgen_package/load_rotate_origin_cminmax.tcl).

        vmd -dispdev text -e load_rotate_origin_cminmax.tcl

Additionally, write out the correct XSC file.

        vmd -dispdev text -e 5.writebox



You should have the following ready for equilibration

        mkdir ../equilibrate

        cp 00_start.p* hold* par_all27_prot_lipid.prm center_minmax_00_start.dat ../equilibrate

        cd ../equilibrate

## Minimization & Equilibration
Minimization and equilibration will remove internal potential energy and
prepare your system for production simulations.

### Voth Method Equilibration
For equilibrating explicitly solvated systems.
To preequilibrate and equilibrate explicitly solvated chemical systems
using NAMD in the NVT and NPT ensembles.

* See the supporting materials, page 3. Chu, J.-W. & Voth, G. A. Allostery of actin filaments: molecular dynamics simulations and coarse-grained analysis. Proc. Natl. Acad. Sci. U. S. A. 102, 13111–6 (2005).

Copy over the .namd configuration files.

        cp ../../../100.config_templates/explicit/* .

        mkdir config

Next, complete all 5 stages of minimization/equilibration. Use the previous stage's xsc file to restart the following stage's simulation.

        mv *.namd config/ && mv config/01_min.namd .

        ./write_cell_basis.py

        vi 01_min.namd        #  ...  adjust the PME Gridsize ...

        namd2 +p2 01_min.namd > 01_min.log

        ./cp_psf.py

        vmd -psf 01_min.psf -pdb 01_min.coor -dispdev text -e minmax_density.tcl

repeat ... OR ... run the next 2 commands instead of the previous one.

        vmd -psf 01_min.psf -pdb 01_min.coor

        % source minmax_density.tcl

Repeat, for all 7 stages.

* *In the event of a simulation failure, follow NAMD's advice, i.e. increase margin, extend minimization, or try ./__write_interim_coords.py__.  __write_interim_coords.py__ employs [MDAnalysis](http://code.google.com/p/mdanalysis) to write out the final step in the trajectory to coordinates(pdb). Resubmit the same step of the simulation with the interim coordinates.*


To continue with stage 8:


        ./cp_psf.py

        vmd -psf 01_min.psf -pdb 01_min.coor -dispdev text -e minmax_density.tcl

	(optional): cp 07_prod.vel 07_prod.coor 07_prod.psf ~/namd_equilibration

	# have 08_prod_continue.namd ready, keep 08_prod_01.namd around to
    # proceed to 08_prod_02.namd

	./write_cell_basis.py    # to write 08_prod_01.namd

	./write_8.py             # to substitute variables from 08_prod_01.namd

	vi 08_prod_01.namd       # ... adjust the PME Gridsize ...

    namd2 +p2 08_prod_01.namd > 08_prod_01.log

Submit. Repeat for step 08_prod_02.
