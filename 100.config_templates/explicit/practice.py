#!/usr/bin/env python
import os,sys,time
from glob import *

my_dir = os.path.abspath(os.path.dirname(__file__))

for path in glob(os.path.join(my_dir,'center_minmax_*01.dat')):
    print path
    print os.path.abspath(path)
    print os.path.basename(path)
    print os.path.dirname(path)
    print os.path.join(os.path.dirname(path),os.path.basename(path))
    
