% This script loads and saves lesion information (lesions in left M1) 
% obtained as single files subsequently to FSL and FreeSurfer operations
%
% Radetz et al. (2021): Linking microstructural integrity and motor
% cortex excitability in multiple sclerosis
%
% Angela Radetz, 06/2020
% 

addpath('\scriptdir\')
params={'FA','ficvf_amico','odi_amico','fiso_amico'};

l=1;
for k=1:49
    group{l}='HC';
    subjects{l}=num2str(k, '%.3i');
    l=l+1;
end
for k=1:50
    group{l}='MS';
    subjects{l}=num2str(k, '%.3i');
    l=l+1;
end

mainpth='\datadir\lvol_leftm1\';
clear lvol_leftm1 lvol_leftm1_prct
lvol_leftm1=zeros(99,1);
lvol_leftm1_prct=zeros(99,1);
for s=1:length(group)
    file=strcat(mainpth,'\lesions_m1_fsspace_',group{s},'_Sbj',subjects{s});
    a=load(file{1});
    file2=strcat(mainpth,'\lesions_masksize_m1_fsspace_',group{s},'_Sbj',subjects{s});
    b=load(file2{1});    
    lvol_leftm1(s,:)=a(:,1);
    lvol_leftm1_prct(s,:)=100./b.*a(:,1);
    clear file a b
end
save('\datadir\lvol_leftm1.mat','lvol_leftm1','lvol_leftm1_prct')
