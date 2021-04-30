#!/bin/bash

# This scripts performs tract-based spatial statistics
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 04/2020


#SBATCH parameters for queuing system

# go to folder with FA images
cd tbss_dir
# run TBSS
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2


# voxelwise statistics on skeletonized FA and NODDI data
randomise -i all_FA_skeletonised -o tbss_NDI -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V

randomise -i all_NDI_skeletonised -o tbss_NDI -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V

randomise -i all_ODI_skeletonised -o tbss_ODI -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V

randomise -i all_fISO_skeletonised -o tbss_fISO -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V




