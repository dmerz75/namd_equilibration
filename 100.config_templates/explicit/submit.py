#!/usr/bin/env python
import os,shutil,re,sys,datetime,string
import random,subprocess
from glob import glob

# ./submit.py 4 o17
idn = 'hsp70'

my_dir = os.path.abspath(os.path.dirname(__file__))
text = os.system('pbsnodes > temp_nodes')
node_file = os.path.join(my_dir,'temp_nodes')

seed = random.randint(1,300)

user = os.path.expanduser('~').split('/')[-1]
proj_name= my_dir.split('/')[-2]
job_name = my_dir.split('/')[-1]
job_sub  = proj_name+'__'+str(datetime.date.today())+'__'+job_name+'__'+str(seed)+'_'+idn
job_pbs  = os.path.join(my_dir,'job.pbs')
job_dir  = '/scratch/%s/%s' % (user,job_sub)
completed_dir = os.path.expanduser('~/completed/%s' % job_sub)

print user,'|',proj_name,'|',job_name
print '\n\t\t SUBMIT: \t',job_sub,'\n'
print completed_dir

count = 0
tup_nodeline_plusone = []
with open(node_file,'r') as nf:
    ''' parse temp_nodes file, identify lines with available nodes
        identify lines that start with a letter and end with a digit, i.e. o9
        save line number, count and plus one, (state = free) line 
    '''
    for line in nf:
        try:
            if line[0].isalpha()==True and line[-2].isdigit()==True:
                #print line
                #print line[0].isalpha(),line[-2].isdigit()
                line = line.rstrip()
                tup_nodeline_plusone.append((count,count+1))
            else:
                pass
        except:
            pass
        count += 1

o = open(node_file,'r')
text = o.readlines()
o.close()

available_nodes = []
for tup_lines in tup_nodeline_plusone:
    ''' get lines identified as free nodes
        establish node, i.e. o9 or dq2
        get np, number of processors, 2 lines below node o9
        create tuple, (node,int(np)), i.e. (o3,4) node o3 with 4 procs
    '''
    node = text[tup_lines[0]].rstrip()
    np   = text[tup_lines[0]+2].split('=')[-1].strip()
    if text[tup_lines[1]].split('=')[-1].strip() == 'free':
        available_nodes.append((node,int(np)))
if not available_nodes:
    available_nodes.append(('o2200',1))  # nprocs

def reg_ex(s_dir,script,subout,subin):
    ''' perform regular expressions on a text file
        i.e. (script_directory,script,'xx_sub_xx','regular expression')
    '''
    full_path_script = os.path.join(s_dir,script)
    o = open(full_path_script,'r+')
    text=o.read()
    text=re.sub(subout,subin,text)
    o.close()
    o = open(full_path_script,'w+')
    o.write(text)
    o.close()
def cp_file(f_dir,f,d_dir,d):
    ''' copy a file
        i.e. (file_dir,filename,destination_dir,as filename)
    '''
    shutil.copy(os.path.join(f_dir,f),os.path.join(d_dir,d))

def reg_ex_users_dirs():
    ''' perform regular expressions specific to user and current working directory
    '''
    print 'len_sys.argv:',len(sys.argv)
    # sys.exit()
    if len(sys.argv)==3:
	reg_ex(my_dir,'job.pbs','xxnodexx',sys.argv[2])
    else:
        reg_ex(my_dir,'job.pbs','xxnodexx',available_nodes[0])
    reg_ex(my_dir,'job.pbs','xxuserxx',user)
    reg_ex(my_dir,'job.pbs','xxjob_subxx',job_sub)
    reg_ex(my_dir,'job.pbs','xxmy_dirxx',my_dir)
    reg_ex(my_dir,'job.pbs','xxjob_dirxx',job_dir)
    reg_ex(my_dir,'job.pbs','xxcompleted_dirxx',completed_dir)

def reg_ex_run_command(type='sop',command_dct={}):
    ''' perform regular expressions specific to job type
        i.e. namd,sop
    '''
    if type=='sop':
        reg_ex(my_dir,'job.pbs','xxpdbxx',command_dct['pdb'])
        reg_ex(my_dir,'job.pbs','xxcontactxx',command_dct['con'])
        reg_ex(my_dir,'job.pbs','xxstructxx',command_dct['sec'])
        reg_ex(my_dir,'job.pbs','xxseedxx',str(seed))
        # reg_ex(my_dir,'job.pbs','xxrunxx',command_dct['run'])
	reg_ex(my_dir,'job.pbs','xxargv_onexx',sys.argv[1])
    elif type=='namd':
        reg_ex(my_dir,'job.pbs','xxnamdconfigxx',command_dct['namd'])
        if (len(sys.argv)==2) or (len(sys.argv)==3):
	    print '23232323'
            print 'command line argument, # of processors: %s' % command_dct['procs']
            reg_ex(my_dir,'job.pbs','xxprocsxx',command_dct['procs'])
        else:
            print 'Used 1 processor'
            reg_ex(my_dir,'job.pbs','xxprocsxx','1')
    else:
        print 'no job type, exiting script'
        sys.exit()

def build_run_dct(type='sop',dir_loc=my_dir):
    ''' returns dictionary of files in os.listdir
        with key equivalent to 3 letter code
        use: run_dct = build_run_dct(specific_directory)
    '''
    file_list = os.listdir(dir_loc)
    file_list.remove('submit.py')
    print file_list
    dct = {}
    if type =='sop':
        code3 = []
        for f in file_list:
            s = f.lower().strip()[0:3]
            code3.append(s)
            dct[s]=f
        print code3
        return dct
    elif type=='namd':
        codes = []
        for f in file_list:
            s = f.lower().strip().split('.')[-1]
            codes.append(s)
            dct[s]=f
        if (len(sys.argv)==2) or (len(sys.argv)==3):
            dct['procs']=sys.argv[1]
        return dct
    else:
        print 'no job type, exiting script from build_run_dct()'
        sys.exit()

def submit():
    pipe=subprocess.Popen(['qsub',job_pbs],stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    stdout,stderr = pipe.communicate()
    print stdout
    print 'stderr >> ',stderr

print available_nodes[0]
script = glob(os.path.join(my_dir,'template_*.pbs'))[0]
job_type = script.split('/')[-1].split('_')[-1].split('.')[0]
print os.path.expanduser('~/opt')
if job_type == 'namd':
    cp_file(os.path.expanduser('~/opt/NAMD_2.9_Linux-x86_64-multicore'),'namd2',my_dir,'namd2')
cp_file(my_dir,script,my_dir,'job.pbs')
os.remove(node_file)
reg_ex_users_dirs()
run_dct = build_run_dct(job_type)
reg_ex_run_command(job_type,run_dct)
submit()

import pprint
pprint.pprint(run_dct)

