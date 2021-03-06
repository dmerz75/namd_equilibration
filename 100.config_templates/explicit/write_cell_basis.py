#!/usr/bin/env python
import os,sys,time,random
from glob import *

my_dir = os.path.abspath(os.path.dirname(__file__))

completed = {}
completed['00']='00_start'
for path in glob(os.path.join(my_dir,"[0-9][0-9]_*.coor")):
    if path.split('.')[1].split('.')[0] == 'restart':
        pass
    else:
        prefix = path.split('/')[-1].split('.')[0]
        num = prefix.split('_')[0]
        completed[num]=prefix

dot_namd = {}
for path in glob(os.path.join(my_dir,"[0-9][0-9]_*.namd")):
    num = path.split('/')[-1].split('_')[0]
    dot_namd[num]=path

# print completed
# print dot_namd
stage = max(completed.keys())
next_stage = str(int(stage)+1).zfill(2)
stage_08 = max(dot_namd.keys())

# print max(completed.keys())
# print stage,next_stage

# fp = "center_minmax_%s.dat" % completed[stage]
# print fp
with open("center_minmax_%s.dat" % completed[stage]) as f:
# with open(fp) as f:
    print f
    # print f.readlines()[7]
    all_lines = f.readlines()
    center    = all_lines[3] # str
    cellbasis = all_lines[7] # str

my_library = os.path.expanduser('~/.pylib')
sys.path.append(my_library)

# imports from my_library
from mylib.cp import *
from mylib.regex import *

the_eight_list = {}
for path in glob(os.path.join(my_dir,'08_*.namd')):
    # print path
    type_8 = path.split('.')[0].split('_')[-1]
    try:
        the_eight_list[int(type_8)] = path
    except:
        the_eight_list[00] = path

try:
    print "\nthe_eight_list\n\t",the_eight_list
    print "\nmaximum\n\t",max(the_eight_list.keys())
    print "\nnext_stage\n\t",next_stage
except:
    pass

if stage_08 == '08':
    if max(the_eight_list.keys())=='continue':
        cp_file(my_dir,'08_prod_continue.namd',my_dir,'08_prod_01.namd')
        dot_namd[next_stage] = os.path.join(my_dir,'08_prod_01.namd')
    else:
        next_8 = str(int(max(the_eight_list.keys())) + 1).zfill(2)
        cp_file(my_dir,'08_prod_continue.namd',my_dir,'08_prod_%s.namd' \
                % next_8)
        dot_namd[next_stage] = os.path.join(my_dir,'08_prod_%s.namd' \
                % next_8)
print "\nmodified:\n",dot_namd[next_stage]

cbx = round(float(cellbasis.split(' ')[0]),2) + 0.37
cby = round(float(cellbasis.split(' ')[1]),2) + 0.37
cbz = round(float(cellbasis.split(' ')[2]),2) + 0.37
xx  = round(float(center.split(' ')[0]),2)
yy  = round(float(center.split(' ')[1]),2)
zz  = round(float(center.split(' ')[2]),2)
# print xx,yy,zz,cbx,cby,cbz
reg_ex(my_dir,dot_namd[next_stage],'xx_cbx_xx',str(cbx))
reg_ex(my_dir,dot_namd[next_stage],'xx_xx_xx',str(xx))
reg_ex(my_dir,dot_namd[next_stage],'xx_cby_xx',str(cby))
reg_ex(my_dir,dot_namd[next_stage],'xx_yy_xx',str(yy))
reg_ex(my_dir,dot_namd[next_stage],'xx_cbz_xx',str(cbz))
reg_ex(my_dir,dot_namd[next_stage],'xx_zz_xx',str(zz))
reg_ex(my_dir,dot_namd[next_stage],'xxxxx',str(random.randint(100000,999999)))
