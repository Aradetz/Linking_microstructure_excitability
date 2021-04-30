#!/bin/bash

# This script overlays the transformed lesion maps (into FreeSurfer
# space) with the left M1 mask to compute the number of voxels depicting
# lesioned tissue
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 06/2020


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
echo 'sbjid=MSmicrostruct_${2}_Sbj${1}' >> $cmd
echo 'fsfolder=${FS_BASE}/${sbjid}' >> $cmd

echo 'dtifitdir=${sbj_dir}dtifit_noddi_fsspace' >> $cmd
echo 'dtidir=${sbj_dir}DTI_long' >> $cmd

echo 'T1_mni=/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz' >> $cmd
echo 'maskdir=${sbj_dir}dtifit_noddi_fsspace' >> $cmd


# watershed on T2 flair
echo 'mri_watershed ${sbj_dir}T2-flair_${2}_Sbj${1}.nii.gz ${sbj_dir}T2-flair_${2}_Sbj{1}_mask.nii.gz' >> $cmd

# transform T2 flair 2 fsspace
echo 'fs_brainmask=${fsfolder}/mri/brainmask.nii.gz' >> $cmd
echo 'flirt -in ${sbj_dir}T2-flair_${2}_Sbj{1}_mask.nii.gz -ref ${fs_brainmask} -omat ${sbj_dir}T2flair2fs.mat -out ${sbj_dir}T2flair2fs.nii.gz' >> $cmd

# apply transformation to lesion maps
echo 'flirt -in /lesiondir/Lesions_${2}_Sbj${1}.nii.gz -ref ${fs_brainmask} -applyxfm -init ${sbj_dir}T2flair2fs.mat -out /lesiondir/Lesions2fs_${2}_Sbj${1}.nii.gz' >> $cmd
# binarize
echo 'fslmaths /lesiondir/Lesions2fs_${2}_Sbj${1}.nii.gz -bin /lesiondir/Lesions2fs_${2}_Sbj${1}_bin.nii.gz' >> $cmd

# multiply lesion mask with left-M1 HMAT mask
echo 'lesions_m1=${sbj_dir}lesions_m1_fsspace' >> $cmd
echo 'lesions_m1_masksize=${sbj_dir}lesions_masksize_m1_fsspace' >> $cmd

echo 'fslmaths ${dtifitdir}/HMAT_Left_M1_fsspace.nii.gz -mul /lesiondir/Lesions2fs_${2}_Sbj${1}_bin.nii.gz ${dtifitdir}Lesions_Left_M1_fsspace.nii.gz' >> $cmd

# lesions (nonzero voxels)
echo 'fslstats ${dtifitdir}Lesions_Left_M1_fsspace.nii.gz -V >> ${lesions_m1}' >> $cmd
# also save mask size
echo 'fslstats ${dtifitdir}Lesions_Left_M1_fsspace.nii.gz -v >> ${lesions_m1_masksize}' >> $cmd


njobs=${#subjects[@]}


chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j ${njobs} $cmd ::: ${subjects[@]} ::: ${tp[@]} ::: ${group[@]} ::: ${freq[@]} 
wait


