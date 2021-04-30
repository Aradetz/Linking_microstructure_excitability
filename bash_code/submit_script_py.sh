#!/bin/bash
# This script calls the script written in python for computation of NODDI
# values with AMICO
#
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 03/2020



# SBATCH parameters for queuing system

# get a clean environment
module purge

# load GNU parallel module
module load tools/parallel

set -x
set -e
PS4='Line ${LINENO}: '

# a job specific & temporary command file
PWD=${pwd}
cmd=$PWD/cmd_$SLURM_JOB_ID.sh

JOBDIR=/localscratch/$SLURM_JOB_ID

# load text files that contain information about subject number and group
source /datapath/group.txt
source /datapath/subjects.txt


# 1: subjects
# 2: group

#pth to DWI data
echo 'BASE=/datapath/' >> $cmd
echo "sbj_dir=${BASE}/"'${2}/Sbj${1}_${2}/' >> $cmd
echo 'dwi=${sbj_dir}/DTI_long/eddy.nii.gz' >> $cmd


echo 'module purge' >> $cmd
echo 'set -x ' >> $cmd
echo 'module load lang/Python/3.6.6-foss-2018b' >> $cmd

#copy data to get the preferred folder structure
echo 'mkdir -p ${base}/noddi/all/Sbj${1}_${3}_${4}_t${2}' >> $cmd
echo 'cp ${sbj_dir}/DTI_long/eddy_brain.nii ${base}/noddi/all/Sbj${1}_${2}/.' >> $cmd
echo 'cp ${sbj_dir}/DTI_long/bvals_for_noddi ${base}/noddi/all/Sbj${1}_${2}/.' >> $cmd
echo 'cp ${sbj_dir}/DTI_long/bvecs_for_noddi ${base}/noddi/all/Sbj${1}_${2}/.' >> $cmd
echo 'cp ${sbj_dir}/DTI_long/eddy_brain_mask.nii ${base}/noddi/all/Sbj${1}_${2}/.' >> $cmd

echo 'python /scriptdir/py/noddiscript_p.py ${1} ${2}' >> $cmd

njobs=${#subjects[@]}
chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j $njobs  $cmd ::: ${subjects[@]} :::  ${tp[@]} ::: ${group[@]} ::: ${freq[@]}
wait


