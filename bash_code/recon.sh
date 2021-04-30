#!/bin/bash
# This script contains the preprocessing steps of T1-weighted images 
# (FreeSurfer)
#
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 03/2020



#SBATCH parameters for queuing system

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

# get information about subjects and group
# 1: subjects
# 2: group

source /scriptdir/get_sbjnr


# get a clean environment
echo 'module purge' >> $cmd
echo 'set -x ' >> $cmd

echo 'BASE=/datapath/' >> $cmd
echo 'FS_BASE=/freesurfer_datapath' >> $cmd
echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $cmd
echo 'export SUBJECTS_DIR=/freesurfer_datadir/' >> $cmd

echo 'T1_dir=${BASE}/${2}/Sbj${1}_${2}/T1_Dicom/' >> $cmd
echo 'sbjid=MSmicrostruct_${2}_Sbj${1}' >> $cmd


echo 'cd ${T1_dir}' >> $cmd

echo 'mrfile=$(ls | sort -n | head -1);' >> $cmd
echo 'recon-all -i ${mrfile} -subjid ${sbjid}' >> $cmd
echo 'recon-all -all -subjid ${sbjid}' >> $cmd


njobs=${#subjects[@]}


chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j ${njobs} $cmd ::: ${subjects[@]} ::: ${tp[@]} ::: ${group[@]} ::: ${freq[@]}
wait


