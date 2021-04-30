#!/bin/bash

# This script overlays the results of tract-based spatial statistics with
# each S-MATT mask and computes the number of overlapping voxels
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 06/2020



# extract the number of voxels that exhibit an overlap between significant FA/NODDI tbss skeleton voxels and each S-MATT mask

source /maskdir/names_SMATT_masks
maskpath=/maskdir/SMATT_masks

# for FA: contrast c1 HC > MS
tbssfile=/tbss_path/tbss/stats/tbss_FA_tfce_c1_thresh_0.95.nii.gz

rm FA_SMATT.txt
rm FA_size_SMATT.txt
for (( m = 1; m<=12; m++ )); do
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> FA_SMATT.txt
fslstats ${mask} -V >> FA_size_SMATT.txt
rm ${tmpfile}
done

# for NDI: contrast c1 HC > MS
tbssfile=/tbss_path/tbss/stats/tbss_NDI_tfce_c1_thresh_0.95.nii.gz

rm NDI_SMATT.txt
rm NDI_size_SMATT.txt
for (( m = 1; m<=12; m++ )); do
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> NDI_SMATT.txt
fslstats ${mask} -V >> NDI_size_SMATT.txt
rm ${tmpfile}
done

# for ODI: contrast c2: MS > HC
tbssfile=/tbss_path/stats/tbss_ODI_tfce_c2_thresh_0.95.nii.gz

rm ODI_SMATT.txt
rm ODI_size_SMATT.txt
for (( m = 1; m<=12; m++ )); do
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${tmpfile} -V >> ODI_SMATT.txt
fslstats ${mask} -V >> ODI_size_SMATT.txt
rm ${tmpfile}
done

# for fISO, the tbss analysis was not significant for either contrast

# extract the total number of voxels of overlapping mean FA skeleton and each S-MATT mask
tbssfile=/tbss_path/tbss/stats/mean_FA_skeleton_mask.nii.gz

rm mean_skeleton_size_SMATT.txt
for (( m = 1; m<=12; m++ )); do
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile=${maskpath}/mask_tbss.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile}
fslstats ${mask} -V >> mean_skeleton_size_SMATT.txt
rm ${tmpfile}
done


