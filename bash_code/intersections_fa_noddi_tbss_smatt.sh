#!/bin/bash

# This script creates binary masks of overlapping FA and NODDI voxels
# within each SMATT mask 
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 06/2020


maskpath=/maskdir/SMATT
source /scriptdir/SMATT_masks


for (( m = 1; m<=12; m++ )); do
echo $m
#1. ODI
tbssfile=/project/jgu-bestust/angela/Data_RTMS/tbss/stats/tbss_ODI_tfce_c2_thresh_0.95.nii.gz
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile_odi=${maskpath}/mask_tbss_odi.nii.gz
tmpfile_odi_bin=${maskpath}/mask_tbss_odi_bin.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile_odi}
# make binary mask
fslmaths ${tmpfile_odi} -bin ${tmpfile_odi_bin} 
rm ${tmpfile_odi}


#2. NDI
tbssfile=/project/jgu-bestust/angela/Data_RTMS/tbss/stats/tbss_NDI_tfce_c1_thresh_0.95.nii.gz
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile_ndi=${maskpath}/mask_tbss_ndi.nii.gz
tmpfile_ndi_bin=${maskpath}/mask_tbss_ndi_bin.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile_ndi}
# make binary mask
fslmaths ${tmpfile_ndi} -bin ${tmpfile_ndi_bin}
rm ${tmpfile_ndi}


#3. FA
tbssfile=/project/jgu-bestust/angela/Data_RTMS/tbss/stats/tbss_FA_tfce_c1_thresh_0.95.nii.gz
mask=${maskpath}/${smatt[m]}.nii.gz
tmpfile_fa=${maskpath}/mask_tbss_fa.nii.gz
tmpfile_fa_bin=${maskpath}/mask_tbss_fa_bin.nii.gz
fslmaths ${mask} -mul ${tbssfile} ${tmpfile_fa}
# make binary mask
fslmaths ${tmpfile_fa} -bin ${tmpfile_fa_bin}
rm ${tmpfile_fa}

# for fISO, TBSS was not significant for either contrast

# 1. add FA, ODI, NDI, threshold by 3
fslmaths ${tmpfile_fa_bin} -add ${tmpfile_odi_bin} -add ${tmpfile_ndi_bin} ${maskpath}/fa_odi_ndi_added.nii.gz  
fslmaths ${maskpath}/fa_odi_ndi_added.nii.gz -thr 3 ${maskpath}/fa_odi_ndi_added.nii.gz 
fslmaths ${maskpath}/fa_odi_ndi_added.nii.gz -bin ${maskpath}/fa_odi_ndi_added.nii.gz
# count voxels
fslstats ${maskpath}/fa_odi_ndi_added.nii.gz -V >> ${maskpath}/FA_ODI_NDI_added.txt


# 2. add FA, ODI, threshold by 2
fslmaths ${tmpfile_fa_bin} -add ${tmpfile_odi_bin} ${maskpath}/fa_odi_added.nii.gz
fslmaths ${maskpath}/fa_odi_added.nii.gz -thr 2 ${maskpath}/fa_odi_added.nii.gz
fslmaths ${maskpath}/fa_odi_added.nii.gz -bin ${maskpath}/fa_odi_added.nii.gz
# count voxels
fslstats ${maskpath}/fa_odi_added.nii.gz -V >> ${maskpath}/FA_ODI_added.txt


# 3. add FA, NDI, threshold by 2
fslmaths ${tmpfile_fa_bin} -add ${tmpfile_ndi_bin} ${maskpath}/fa_ndi_added.nii.gz
fslmaths ${maskpath}/fa_ndi_added.nii.gz -thr 2 ${maskpath}/fa_ndi_added.nii.gz
fslmaths ${maskpath}/fa_ndi_added.nii.gz -bin ${maskpath}/fa_ndi_added.nii.gz
# count voxels
fslstats ${maskpath}/fa_ndi_added.nii.gz -V >> ${maskpath}/FA_NDI_added.txt


# 4. add ODI, NDI, threshold by 2 
fslmaths ${tmpfile_odi_bin} -add ${tmpfile_ndi_bin} ${maskpath}/odi_ndi_added.nii.gz
fslmaths ${maskpath}/odi_ndi_added.nii.gz -thr 2 ${maskpath}/odi_ndi_added.nii.gz
fslmaths ${maskpath}/odi_ndi_added.nii.gz -bin ${maskpath}/odi_ndi_added.nii.gz
# count voxels
fslstats ${maskpath}/odi_ndi_added.nii.gz -V >> ${maskpath}/ODI_NDI_added.txt


# 5. FA, ODI only
fslmaths ${maskpath}/fa_odi_added.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/fa_odi_only.nii.gz 
# count voxels
fslstats ${maskpath}/fa_odi_only.nii.gz -V >> ${maskpath}/FA_ODI_only.txt


# 6. FA, NDI only
fslmaths ${maskpath}/fa_ndi_added.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/fa_ndi_only.nii.gz
# count voxels
fslstats ${maskpath}/fa_ndi_only.nii.gz -V >> ${maskpath}/FA_NDI_only.txt


# 7. ODI, NDI only
fslmaths ${maskpath}/odi_ndi_added.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/odi_ndi_only.nii.gz
# count voxels
fslstats ${maskpath}/odi_ndi_only.nii.gz -V >> ${maskpath}/ODI_NDI_only.txt


# 8. FA only
fslmaths ${tmpfile_fa_bin} -sub ${maskpath}/fa_odi_only.nii.gz -sub ${maskpath}/fa_ndi_only.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/fa_only.nii.gz
# count voxels
fslstats ${maskpath}/fa_only.nii.gz -V >> ${maskpath}/FA_only.txt


# 9. ODI only
fslmaths ${tmpfile_odi_bin} -sub ${maskpath}/fa_odi_only.nii.gz -sub ${maskpath}/odi_ndi_only.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/odi_only.nii.gz
# count voxels
fslstats ${maskpath}/odi_only.nii.gz -V >> ${maskpath}/ODI_only.txt


# 10. NDI only
fslmaths ${tmpfile_ndi_bin} -sub ${maskpath}/odi_ndi_only.nii.gz -sub ${maskpath}/fa_odi_only.nii.gz -sub ${maskpath}/fa_odi_ndi_added.nii.gz ${maskpath}/ndi_only.nii.gz
# count voxels
fslstats ${maskpath}/ndi_only.nii.gz -V >> ${maskpath}/NDI_only.txt





rm ${maskpath}/fa_odi_added.nii.gz
rm ${maskpath}/odi_ndi_added.nii.gz
rm ${maskpath}/fa_ndi_added.nii.gz
rm ${maskpath}/fa_odi_ndi_added.nii.gz
rm ${maskpath}/odi_ndi_only.nii.gz
rm ${maskpath}/fa_odi_only.nii.gz
rm ${maskpath}/fa_ndi_only.nii.gz
rm ${maskpath}/fa_only.nii.gz
rm ${maskpath}/ndi_only.nii.gz
rm ${maskpath}/odi_only.nii.gz
rm ${tmpfile_fa_bin}
rm ${tmpfile_odi_bin}
rm ${tmpfile_ndi_bin}



done


