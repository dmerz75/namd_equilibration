from sys import argv
from os.path import exists
import os
howmany = 3
for i in range(0, howmany):
    os.system("namd2 accelx.namd > iter-x-%d.log"  % i)
    os.system("python rgyr.py %d" % i)
