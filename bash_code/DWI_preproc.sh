#!/bin/bash
# This script contains the preprocessing steps of diffusion-weighted
# images (FSL) 
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

#JOBDIR=/localscratch/$SLURM_JOB_ID

# get information about subjects and group 
# 1: subjects
# 2: group

source /scriptdir/get_sbjnr

# get a clean environment
echo 'module purge' >> $cmd
echo 'set -x ' >> $cmd

# load FSL
echo 'FSLDIR=/projectdir/fsl' >> $cmd
echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> $cmd
echo 'PATH=${FSLDIR}/bin:${PATH}' >> $cmd
echo 'export FSLDIR PATH' >> $cmd

echo 'BASE=/datapath/' >> $cmd
echo 'FS_BASE=/freesurfer_datapath' >> $cmd


echo 'pth=${BASE}${2}/Sbj${1}_${2}/' >> $cmd
echo 'dataset=( "${pth}"DTI_long/20*.nii.gz )' >> $cmd
echo 'bvec_name=( "${pth}"DTI_long/*.bvec )' >> $cmd
echo 'bval_name=( "${pth}"DTI_long/*.bval )' >> $cmd
echo 'b0_1=( "${pth}"DTI_b01/*.nii.gz )' >> $cmd
echo 'b0_2=( "${pth}"DTI_b02/*.nii.gz )' >> $cmd
echo 'cd ${pth}DTI_long/' >> $cmd

# split data set, then merge all b-zeros for topup 
echo 'fslsplit ${dataset}' >> $cmd
echo 'fslmerge -t b_zeros vol0000* vol0001* vol0002* vol0003* vol0004* vol0005* vol0006* vol0037* vol0038* vol0039* vol0040* vol0041* vol0042* vol0073* vol0074* vol0075* vol0076* vol0077* vol0078* ${b0_1} ${b0_2}' >> $cmd
# copy the acqp and index files to the individual subject folders
echo 'cp /scriptdir/acqp.txt ${pth}DTI_long' >> $cmd
echo 'cp /scriptdir/index.txt ${pth}DTI_long' >> $cmd


# adapt the bvecs files for eddy, where two b-zeros (one A-P, one P-A) were acquired subsequently to the long diffusion sequence
# the bvals file can be copied directly as it is the same for all subjects
echo 'cp /scriptdir/bvals_for_eddy ${pth}DTI_long/"bvals"' >> $cmd
echo 'cp ${bvec_name} ${pth}DTI_long/bvecs2' >> $cmd
echo 'dos2unix bvecs2' >> $cmd
echo 'if [ -f bvecs ]; rm bvecs; fi' >> $cmd
echo 'sed "s/$/0 0/" bvecs2 >bvecs' >> $cmd
echo 'rm bvecs2' >> $cmd

# run topup
echo 'topup --imain=${pth}DTI_long/b_zeros.nii.gz --datain=${pth}DTI_long/acqp.txt --config=b02b0.cnf --out=${pth}DTI_long/topup_out --iout=${pth}DTI_long/DTI_longtopup_hifi_b0' >> $cmd

echo 'cd ${pth}DTI_long/' >> $cmd
# compute the average image of the corrected b-zero volumes
echo 'fslmaths DTI_longtopup_hifi_b0 -Tmean topup_hifi_b0' >> $cmd
# apply BET on the averaged b-zero
echo 'bet topup_hifi_b0 topup_hifi_b0_brain -f 0.1 -R' >> $cmd



# run eddy on the whole data set, including the two b-zeros acquired right after the long diffusion sequence 
echo 'fslmerge -t dtidata ${dataset} ${b0_1} ${b0_2}' >> $cmd

echo 'OMP_NUM_THREADS=4' >> $cmd
echo 'eddy_openmp --imain=dtidata --mask=topup_hifi_b0_brain --topup=topup_out --acqp=acqp.txt --index=index.txt --bvals=bvals_for_eddy --bvecs=bvecs_for_eddy --out=eddy --interp=trilinear --slm=linear' >> $cmd

# apply BET on eddy-corrected brain
echo 'bet eddy eddy_brain -f 0.1 -R -m' >> $cmd



# it is suggested to run dtifit only on the inner shell (b=900), so according preparation of the dataset:
echo 'fslmerge -t data_for_dtifit vol000* vol001* vol002* vol0030* vol0031* vol0032* vol0033* vol0034* vol0035* vol0036*' >> $cmd


echo 'dtifit --data=data_for_dtifit.nii --mask=eddy_brain.nii --bvecs=bvecs_for_dtifit --bvals=bvals_for_dtifit --out=dtifit_result_b900' >> $cmd


njobs=${#subjects[@]}
chmod +x $cmd

HOSTLIST=$(scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s )

parallel --link --workdir $PWD --sshdelay 0.2 -S $HOSTLIST -j $njobs  $cmd ::: ${subjects[@]} :::  ${tp[@]} ::: ${group[@]} ::: ${freq[@]}
wait



