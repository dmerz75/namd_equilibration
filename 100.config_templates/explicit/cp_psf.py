#!/usr/bin/env python
import os,sys,time
from glob import *

my_dir = os.path.abspath(os.path.dirname(__file__))

for path in glob(os.path.join(my_dir,"[0-9][0-9]_*.coor")):
    if path.split('.')[1].split('.')[0] == 'restart':
        pass
    else:
        prefix = path.split('/')[-1].split('.')[0]
        psf_file = prefix + '.psf'
        print psf_file
        os.system('cp 00_start.psf %s' % psf_file)
