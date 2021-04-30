% This script loads and saves FA and NODDI values obtained as single
% files
% subsequently to FSL and FreeSurfer operations
%
% Radetz et al. (2021): Linking microstructural integrity and motor
% cortex excitability in multiple sclerosis
%
% Angela Radetz, 04/2020 and 03/2021
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

%% FA and NODDI within left M1 mask
mainpth='\datadir\left_m1_gm_fsspace\';

clear dti_vals_gm_leftm1
dti_vals_gm_leftm1=cell(1,4);
for d=1:4
    for s=1:length(group)
        file=strcat(mainpth,params{d},'\MSmicrostruct_',group{s},'_Sbj',subjects{s},'_',params{d});
        dti_vals_gm_leftm1{d}(s,1)=load(file{1});           
        clear file      
    end
end
save('\datadir\dti_vals_gm_leftm1.mat','dti_vals_gm_leftm1')
fa_gm_leftm1=dti_vals_gm_leftm1{1};
ndi_gm_leftm1=dti_vals_gm_leftm1{2};
odi_gm_leftm1=dti_vals_gm_leftm1{3};
fiso_gm_leftm1=dti_vals_gm_leftm1{4};
% save vectors for R plot
save('\datadir_R\fa_gm_leftm1.mat','fa_gm_leftm1')
save('\datadir_R\ndi_gm_leftm1.mat','ndi_gm_leftm1')
save('\datadir_R\odi_gm_leftm1.mat','odi_gm_leftm1')
save('\datadir_R\fiso_gm_leftm1.mat','fiso_gm_leftm1')

%% FA and NODDI within left M1 SMATT mask
mainpth='\datadir\SMATT_LM1_fsspace\';

clear dti_vals_smatt_lm1
dti_vals_smatt_lm1=cell(1,4);
for d=1:4
    for s=1:length(group)
        file=strcat(mainpth,params{d},'\MSmicrostruct_',group{s},'_Sbj',subjects{s},'_',params{d});
        dti_vals_smatt_lm1{d}(s,1)=load(file{1});           
        clear file
    end
end
save('\datadir\dti_vals_smatt_lm1.mat','dti_vals_smatt_lm1')
fa_smatt_lm1=dti_vals_smatt_lm1{1};
ndi_smatt_lm1=dti_vals_smatt_lm1{2};
odi_smatt_lm1=dti_vals_smatt_lm1{3};
fiso_smatt_lm1=dti_vals_smatt_lm1{4};
% save vectors for R plot
save('\datadir_R\fa_smatt_lm1.mat','fa_smatt_lm1')
save('\datadir_R\ndi_smatt_lm1.mat','ndi_smatt_lm1')
save('\datadir_R\odi_smatt_lm1.mat','odi_smatt_lm1')
save('\datadir_R\fiso_smatt_lm1.mat','fiso_smatt_lm1')

%% FA and NODDI within handknob
clear dti_vals_gm_handknob
mainpth='\datadir\handknob_gm_rehme_fsspace\';

clear dti_vals_gm_handknob
dti_vals_gm_handknob=cell(1,4);
for d=1:4
    for s=1:length(group)
        file=strcat(mainpth,params{d},'\MSmicrostruct_',group{s},'_Sbj',subjects{s},'_',params{d});
        dti_vals_gm_handknob{d}(s,1)=load(file{1});           
        clear file      
    end
end
save('\datadir\dti_vals_gm_handknob.mat','dti_vals_gm_handknob')
fa_handknob=dti_vals_gm_handknob{1};
ndi_handknob=dti_vals_gm_handknob{2};
odi_handknob=dti_vals_gm_handknob{3};
fiso_handknob=dti_vals_gm_handknob{4};
% save vectors for R plot
save('\datadir_R\fa_handknob_rehme.mat','fa_handknob')
save('\datadir_R\ndi_handknob_rehme.mat','ndi_handknob')
save('\datadir_R\odi_handknob_rehme.mat','odi_handknob')
save('\datadir_R\fiso_handknob_rehme.mat','fiso_handknob')


