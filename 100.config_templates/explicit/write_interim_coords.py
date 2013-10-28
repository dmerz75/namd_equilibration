#!/usr/bin/env python
import os,sys,time
import numpy as np
import MDAnalysis
from glob import *

my_dir = os.path.abspath(os.path.dirname(__file__))
# stage  = sys.argv[1]
# ./write_interim_coords.py 03 (stage)

class MoleculeUniverse:
    """ Molecule's Universe for trajectory analysis
    """
    def __init__(self,workdir,psf,dcd,destdir,id):
        self.workdir = workdir
        self.psf = psf
        self.dcd = dcd
        self.destdir = destdir
        self.id = id
    def print_vals(self):
        print self.workdir
        print self.psf
        print self.dcd
        print self.destdir
        print self.id
    def gen_coords(self):
        # pdb = MDAnalysis.Writer("%s_interim.pdb" % self.id)
        u = MDAnalysis.Universe(self.psf,self.dcd)
        for ts in u.trajectory[-1:]:
            print "WRITING ..."
            system = u.selectAtoms("all")
            system.write("%s_interim.pdb" % self.id)
        # last_frame_id = len(u.trajectory)-1
        # for i,ts in enumerate(u.trajectory):
        #     print i,ts
        # last_frame = u.trajectory[-1]
        # pdb.write(last_frame)
        # print u.trajectory[last_frame_id]
        # for ts in u.trajectory[-1]:
        #     print ts
        # u.trajectory[-1]
        # pdb = PrimitivePDBWriter("%s_interim.pdb" % self.id, \
        #                          u.atoms.numberOfAtoms())
        # pdb.write_all_timesteps(u)
        # the_ans = u.trajectory[-1]
        # print the_ans
        # print type(the_ans)
        # sys.exit()
        # pdb = MDAnalysis.coordinates.PDB.PrimitivePDBWriter( \
        #              "%s_interim.pdb" % self.id, multiframe=False)
        # pdb.write_all_timesteps(the_ans)
        # print type(new_class)
        # new_class._write_timestep(the_ans)
        # new_class.write(the_ans)
    def gen_output(self):
        u = MDAnalysis.Universe(self.psf,self.dcd)
        residue_indices = [i for i in range(0,len(u.atoms))]
        first_last = [0,-1]

        # print u.atoms[i].resid,u.atoms[i].pos,u.atoms[first_last].bond(),u.atoms[i:i+4].dihedral()

        all_frames_atoms_ext_dihedral = []
        ext_correction = 0.0
        count = 0
        # out_file = os.path.join(self.destdir,'traj_%s.dat' % self.id)
        with open(os.path.join(self.destdir,'traj_%s.dat' % self.id),'w') as fp:
            for ts in u.trajectory[101::10]:
                print ts.frame
                atom_ext_dihedral = []
                for i in residue_indices[:-4]:
                    print u.atoms[i].resid,u.atoms[i].pos,u.atoms[first_last].bond(),\
                        u.atoms[i:i+4].dihedral()
                    if count == 0:
                        ext_correction = u.atoms[first_last].bond()
                        print ext_correction,'<--- Assigned'
                        count += 1
                    ext = u.atoms[first_last].bond()-ext_correction
                    print ext,u.atoms[first_last].bond(),ext_correction
                    atom_ext_dihedral.append((u.atoms[i].resid,\
                                u.atoms[i].pos[0],u.atoms[i].pos[1],u.atoms[i].pos[2],\
                                ext,# u.atoms[first_last].bond(),\
                                              u.atoms[i:i+4].dihedral()))
                n = np.array(atom_ext_dihedral)
                np.savetxt(fp,n,fmt=['%2d','%.8f','%.8f','%.8f','%.2f','%.2f'],\
                               header='frame %s' % ts.frame)

def eval_traj(p):
    '''
    '''
    # traj_id = p.split('/')[-3].split('__')[-2].split('_')[-1]
    traj_id = p.split('/')[-1].split('.')[0]
    print "TRAJ_ID:",traj_id
    # def __init__(self,workdir,psf,dcd,destdir,id):
    x = MoleculeUniverse(my_dir,os.path.join(my_dir,'%s.psf' % traj_id),\
                         p,my_dir,traj_id)
    x.print_vals()
    # x.gen_output()
    x.gen_coords()

for path in glob(os.path.join(my_dir,'%s_*.dcd' % sys.argv[1])):
    print path
    eval_traj(path)
