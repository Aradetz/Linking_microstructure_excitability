% This script performs lesion segmentation and estimation of lesion volume % using the Lesion Segmentation Toolbox (LST) in SPM
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 02/2020



addpath('\scriptdir\')

l=1;
for k=1:49
    gr{l}='HC';
    sb{l}=num2str(k, '%.3i');
    l=l+1;
end
for k=1:50
    gr{l}='MS';
    sb{l}=num2str(k, '%.3i');
    l=l+1;
end

for k=1:99
    lesion_segmentation(sb{k}, gr{k});
end



function lesion_segmentation(sbj, group)
addpath('\spm_path\')
clear matlabbatch


disp(['Working on Sbj' sbj , group])
 
mainpth=['\datadir\' group];
t1_inpath=dir([mainpth '\Sbj' sbjnr  '_' group '\t1_mpr_*']);
t1_inpath=[mainpth '\Sbj' sbjnr  '_' group '\' t1_inpath.name];
t1_outpath=[mainpth '\Sbj' sbjnr '_' group '\t1_lesion_out\'];
t2_inpath=dir([mainpth '\Sbj' sbjnr '_' group '\t2_spc*']);
t2_inpath=[mainpth '\Sbj' sbjnr  '_' group '\' t2_inpath.name];
t2_outpath=[mainpth '\Sbj' sbjnr '_' group '\t2_lesion_out\'];
 
mkdir(t1_outpath)
mkdir(t2_outpath)
 
% Convert, move and rename T1 image
cd(t1_inpath)
files = spm_select('list', t1_inpath,'MR*');
 
hdr = spm_dicom_headers(files);
out=spm_dicom_convert(hdr);
 
movefile(char(out.files),t1_outpath)
pause(5)
file = spm_select('list', t1_outpath,'.*.nii');
oldname = [t1_outpath file];
newname = 'T1.nii';
dos(['rename "' oldname '" "' newname '"']);

% Convert, move and rename T2 image
clear files file oldname newname 
cd(t2_inpath)
files = spm_select('list', t2_inpath,'MR*');
 
hdr = spm_dicom_headers(files);
out=spm_dicom_convert(hdr);

movefile(char(out.files),t2_outpath)
pause(5)
file = spm_select('list', t2_outpath,'.*.nii');
newname = 'T2.nii';oldname = [t2_outpath file];
dos(['rename "' oldname '" "' newname '"']);

disp('LGA...')
 
t1_file=[t1_outpath 'T1.nii'];
t2_file=[t2_outpath 'T2.nii'];
cd(t1_outpath)
clear matlabbatch
matlabbatch{1}.spm.tools.LST.lga.data_T1 = {t1_file};
matlabbatch{1}.spm.tools.LST.lga.data_F2 = {t2_file};
matlabbatch{1}.spm.tools.LST.lga.opts_lga.initial = 0.2;
matlabbatch{1}.spm.tools.LST.lga.opts_lga.mrf = 1;
matlabbatch{1}.spm.tools.LST.lga.opts_lga.maxiter = 50;
matlabbatch{1}.spm.tools.LST.lga.html_report = 1;
spm_jobman('run', matlabbatch,'any');
 
disp('Lesion filling...')

clear matlabbatch
matlabbatch{1}.spm.tools.LST.filling.data = {t1_file};
matlabbatch{1}.spm.tools.LST.filling.data_plm = {[t1_outpath 'ples_lga_0.2_rmT2.nii']};
matlabbatch{1}.spm.tools.LST.filling.html_report = 1;
spm_jobman('run', matlabbatch,'any');
 
 
disp('Compute lesion volume...')
clear matlabbatch
matlabbatch{1}.spm.tools.LST.tlv.data_lm = {[t1_outpath 'ples_lga_0.2_rmT2.nii']};
matlabbatch{1}.spm.tools.LST.tlv.bin_thresh = 0.5;
spm_jobman('run', matlabbatch,'any');
 
disp('Finished!')
end