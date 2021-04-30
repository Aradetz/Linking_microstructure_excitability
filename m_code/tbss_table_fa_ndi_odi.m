% This script creates the content of Table 2 and S7 (Number and percentage 
% of voxels significantly differing between MS and HC in FA; NDI and ODI in
% SMATT and JHU regions
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 06/2020

%% SMATT
tbss_pth='\tbss_SMATT_dir\';
cd(tbss_pth)
load('NDI_SMATT.txt')
load('ODI_SMATT.txt')
load('mean_skeleton_size_SMATT.txt')
load('FA_SMATT.txt')
% values are from extract_tbss_masks_smatt.sh

fa_prct=100./mean_skeleton_size_SMATT(:,1).*FA_SMATT(:,1);
FA_ana=[FA_SMATT(:,1) mean_skeleton_size_SMATT(:,1) fa_prct]; 
odi_prct=100./mean_skeleton_size_SMATT(:,1).*ODI_SMATT(:,1);
ODI_ana=[ODI_SMATT(:,1) mean_skeleton_size_SMATT(:,1) odi_prct]; 
ndi_prct=100./mean_skeleton_size_SMATT(:,1).*NDI_SMATT(:,1);
NDI_ana=[NDI_SMATT(:,1) mean_skeleton_size_SMATT(:,1) ndi_prct]; 


%% JHU
tbss_pth='\tbss_JHU_dir\';
cd(tbss_pth)
load('NDI.txt')
load('ODI.txt')
load('mean_skeleton_size.txt')
load('FA.txt')
% values are from extract_tbss_masks_jhu.sh

fa_prct=100./mean_skeleton_size_SMATT(:,1).*FA_SMATT(:,1);
FA_ana=[FA_SMATT(:,1) mean_skeleton_size_SMATT(:,1) fa_prct]; 
odi_prct=100./mean_skeleton_size_SMATT(:,1).*ODI_SMATT(:,1);
ODI_ana=[ODI_SMATT(:,1) mean_skeleton_size_SMATT(:,1) odi_prct]; 
ndi_prct=100./mean_skeleton_size_SMATT(:,1).*NDI_SMATT(:,1);
NDI_ana=[NDI_SMATT(:,1) mean_skeleton_size_SMATT(:,1) ndi_prct]; 

