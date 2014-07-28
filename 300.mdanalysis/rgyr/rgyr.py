import MDAnalysis 
from sys import argv
from MDAnalysis import Universe
from MDAnalysis.tests.datafiles import PSF,DCD   # test trajectory
import numpy.linalg
import MDAnalysis.analysis.distances
import sys
import os
script, str = argv
print str

# always start with a universe
u = MDAnalysis.Universe('../ee_wb.psf','iter367.dcd') 
ca1 = u.selectAtoms("resid 1 and name CA")      # resid (PEP) and atom name
ca10 = u.selectAtoms("resid 10 and name CA")
ca2 = u.selectAtoms("resid 2 and name CA")
ca9 = u.selectAtoms("resid 9 and name CA")
ca3 = u.selectAtoms("resid 3 and name CA")
ca8 = u.selectAtoms("resid 8 and name CA")
ca4 = u.selectAtoms("resid 4 and name CA")
ca7 = u.selectAtoms("resid 7 and name CA")
bb = u.selectAtoms('protein and backbone')      # a selection (a AtomGroup)

out = open("pyEND%s.dat" % str, 'w')

for ts in u.trajectory:                      # iterate through all frames
  r1 = ca10.coordinates() - ca1.coordinates()
  r2 = ca9.coordinates() - ca2.coordinates()
  r3 = ca8.coordinates() - ca3.coordinates()
  r4 = ca7.coordinates() - ca4.coordinates()
  d1 = numpy.linalg.norm(r1)                   # end-to-end distance
  d2 = numpy.linalg.norm(r2)
  d3 = numpy.linalg.norm(r3)
  d4 = numpy.linalg.norm(r4)
  rgyr = bb.radiusOfGyration()      # method of a AtomGroup; updates with each frame
  print "%d %f" % (ts.frame, d1)
  out.write("%d %f %f %f %f %f\n" % (ts.frame, d1, d2, d3, d4, rgyr))

out.close()
