#!/bin/bash
# This script transforms FA and NODDI maps, as well as the left M1 HMAT
# mask into the individual FreeSurfer space. The intersection of the left
# M1 mask with the cortical ribbon is computed.
#
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 05/2020



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

#from desikan_extr_orig
echo 'dtifitdir=${sbj_dir}dtifit_noddi' >> $cmd
echo 'dtidir=${sbj_dir}DTI_long' >> $cmd
echo 'noddidir=/noddipath/all/Sbj${1}_${2}/AMICO/NODDI' >> $cmd

echo 'T1_mni=/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz' >> $cmd

echo 'dtifitdir=${sbj_dir}dtifit_noddi_fsspace' >> $cmd
echo 'mkdir -p ${dtifitdir}' >> $cmd

echo 'diff_metric[1]=FA' >> $cmd
echo 'diff_metric[2]=ficvf_amico' >> $cmd
echo 'diff_metric[3]=odi_amico' >> $cmd
echo 'diff_metric[4]=fiso_amico' >> $cmd


# 1. Transform DWI to Freesurfer space
echo 'cp ${fsfolder}/mri/brainmask.nii.gz ${dtifitdir}/.' >> $cmd
# Add left and right hemispheric cortical ribbon
echo 'fslmaths ${fsfolder}/mri/lh_gm.nii.gz -add ${fsfolder}/mri/rh_gm.nii.gz ${dtifitdir}/gm.nii.gz' >> $cmd

# Register eddy-corrected b0 to the FreeSurfer brainmask
echo 'flirt -in ${dtifitdir}/eddy_brain.nii -ref ${fsfolder}/mri/brainmask.nii.gz -omat ${dtifitdir}/dti2fs.mat -out ${dtifitdir}/eddy2fs.nii.gz' >> $cmd
# Use transformation matrix to transform FA (computed from inner shell) to FreeSurfer space
echo 'flirt -in ${dtifitdir}/dtifit_result_b900_FA.nii.gz -ref ${fsfolder}/mri/brainmask.nii.gz -applyxfm -init ${dtifitdir}/dti2fs.mat -out ${dtifitdir}/FA2fs2.nii.gz' >> $cmd
# Use transformation matrix to transform NODDI maps to FreeSurfer space
echo 'for (( d = 2; d <=4; d++)) ; do' >> $cmd
echo 'flirt -in ${noddidir}/${diffm[d]}.nii.gz -ref ${fsfolder}/mri/brainmask.nii.gz -applyxfm -init ${dtifitdir}/dti2fs.mat -out ${dtifitdir}/${diff_metric[d]}2fs.nii.gz' >> $cmd
echo 'done' >> $cmd

# 2. Transform left M1 mask to individual FreeSurfer space
# First coregister MNI-T1 to the FreeSurfer brainmask
echo 'flirt -in ${T1_mni} -ref ${fsfolder}/mri/brainmask.nii.gz -omat ${dtifitdir}/mni2fs.mat -out ${dtifitdir}/mni2fs.nii.gz' >> $cmd
# then apply the transformation matrix to the HMAT Left M1 mask
echo 'mask=/maskdir/HMAT_Left_M1.nii.gz' >> $cmd
echo 'flirt -in ${mask} -ref ${fsfolder}/mri/brainmask.nii.gz -applyxfm -init ${dtifitdir}/mni2fs.mat -out ${dtifitdir}/HMAT_Left_M1_fsspace.nii.gz' >> $cmd
# multiply cortical ribbon mask with Left M1 mask
echo 'mask_gm=${dtifitdir}/GM_HMAT_Left_M1_fsspace.nii.gz' >> $cmd
echo 'fslmaths {dtifitdir}/HMAT_Left_M1_fsspace.nii.gz -mul ${dtifitdir}/gm.nii.gz ${mask_gm}' >> $cmd

njobs=${#subjects[@]}

chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j ${njobs} $cmd ::: ${subjects[@]} ::: ${tp[@]} ::: ${group[@]} ::: ${freq[@]} 
wait


