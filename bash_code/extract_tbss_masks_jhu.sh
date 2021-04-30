#!/bin/bash

# This script overlays the results of tract-based spatial statistics with 
# each JHU mask and computes the number of overlapping voxels
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 06/2020


# overlay results of tbss for FA with each S-MATT template and compute the number of overlapping voxels (contrast c1: HC > MS)

maskpath=/fslpath/fsl/data/atlases/JHU
tbssfile=/tbsspath/tbss/stats/tbss_FA_tfce_c1_thresh_0.95.nii.gz

rm FA.txt
rm FA_size.txt
for (( m = 1; m<=48; m++ )); do
mask=${maskpath}/JHU_mask${m}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> FA.txt
fslstats ${mask} -V >> FA_size.txt
rm ${tmpfile}
done


# overlay results of tbss for FA with each S-MATT template and compute the number of overlapping voxels (contrast c1: HC > MS)

maskpath=/fslpath/fsl/data/atlases/JHU
tbssfile=/tbsspath/tbss/stats/tbss_NDI_tfce_c1_thresh_0.95.nii.gz

rm NDI.txt
rm NDI_size.txt
for (( m = 1; m<=48; m++ )); do
mask=${maskpath}/JHU_mask${m}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> NDI.txt
fslstats ${mask} -V >> NDI_size.txt
rm ${tmpfile}
done



# overlay results of tbss for FA with each S-MATT template and compute the number of overlapping voxels (contrast c2: MS > HC)

maskpath=/fslpath/fsl/data/atlases/JHU
tbssfile=/tbsspath/tbss/stats/tbss_FA_tfce_c1_thresh_0.95.nii.gz

rm ODI.txt
rm ODI_size.txt
for (( m = 1; m<=48; m++ )); do
mask=${maskpath}/JHU_mask${m}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> ODI.txt
fslstats ${mask} -V >> ODI_size.txt
rm ${tmpfile}
done


# compute the total number of voxels in the overlapping area of each JHU mask and the mean skeleton

tbssfile=/tbsspath/tbss/stats/mean_FA_skeleton_mask.nii.gz

rm mean_skeleton_size.txt
for (( m = 1; m<=48; m++ )); do
mask=${maskpath}/JHU_mask${m}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${mask} -V >> mean_skeleton_size.txt
rm ${tmpfile}
done


