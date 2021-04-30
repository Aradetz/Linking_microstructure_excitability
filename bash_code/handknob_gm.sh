#!/bin/bash

# This script computes average FA and NODDI values within the handknob 
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 03/2021


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

# load FSL
echo 'FSLDIR=/project/jgu-bestust/fsl' >> $cmd
echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> $cmd
echo 'PATH=${FSLDIR}/bin:${PATH}' >> $cmd
echo 'export FSLDIR PATH' >> $cmd

echo "sbj_dir=${BASE}/"'${2}/Sbj${1}_${2}/' >> $cmd
echo 'FS_dir=${FS_BASE}' >> $cmd
echo 'sbjid=MSmicrostruct_${2}_Sbj${1}' >> $cmd
echo 'fsfolder=${FS_BASE}/${sbjid}' >> $cmd


echo 'dtifitdir=${sbj_dir}dtifit_noddi_fsspace' >> $cmd

echo 'diff_metric[1]=FA' >> $cmd
echo 'diff_metric[2]=ficvf_amico' >> $cmd
echo 'diff_metric[3]=odi_amico' >> $cmd
echo 'diff_metric[4]=fiso_amico' >> $cmd

## Result: mask of handknob in overlap with cortical ribbon
echo 'hand_gm_fsspace=${dtifitdir}/hand_gm_fsspace.nii.gz' >> $cmd

# Cortical ribbon mask
echo 'mask_gm=${dtifitdir}/gm.nii.gz' >> $cmd

# use mni2fs and apply to handknob mask
echo 'handknob=/maskdir/handknob.nii.gz' >> $cmd

# use MNI to freesurfer space transformation matrix to get handknob to freesurfer space (prepared in script dti2fs_mask.sh))
echo 'hand_fsspace=${dtifitdir}/handknob_fsspace.nii.gz' >> $cmd
echo 'flirt -in ${handknob} -ref ${dtifitdir}/brainmask.nii.gz -out ${hand_fsspace} -applyxfm -init ${dtifitdir}/mni2fs.mat' >> $cmd

# Actual computation: mask of handknob in overlap with cortical ribbon
echo 'fslmaths ${hand_fsspace} -mul ${mask_gm} ${hand_gm_fsspace}' >> $cmd

## Compute average FA/NODDI values within mask of handknob in overlap with cortical ribbon
echo 'result_dir=/resultdir/handknob_gm_fsspace' >> $cmd
echo 'for (( d = 1 ; d <=4; d++ )); do' >> $cmd
echo 'mkdir -p ${result_dir}/${diff_metric[d]}' >> $cmd
echo 'result_file=${result_dir}/${diff_metric[d]}/${sbjid}_${diff_metric[d]}' >> $cmd
echo 'if [ -e ${result_file} ]; then' >> $cmd
echo 'rm ${result_file}' >> $cmd
echo 'fi' >> $cmd

echo 'dtiimg=${dtifitdir}/${diff_metric[d]}2fs.nii.gz' >> $cmd
echo 'fslmeants -i ${dtiimg} -o ${result_file} -m ${hand_gm_fsspace}' >> $cmd
echo 'done' >> $cmd


njobs=${#subjects[@]}


chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j ${njobs} $cmd ::: ${subjects[@]} ::: ${tp[@]} ::: ${group[@]} ::: ${freq[@]} 
wait


