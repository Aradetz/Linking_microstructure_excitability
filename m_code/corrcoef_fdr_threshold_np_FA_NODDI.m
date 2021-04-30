% This script computes correlation coefficients between FA, NODDI values
% and motor threshold / neuropsychological scores and applies an FDR 
% correction to the resulting p-values. Significance based on these 
% corrections is indicated in the the Figures with an asterisk
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 06/2020 and 03/2021
% 


%% Correlation coefficients of 
% 1. FA and NODDI values in left M1 and motor threshold
% 2. FA and NODDI values in handknob and motor threshold
% 3. FA and NODDI values in left M1 SMATT tract and motor threshold
% 4. FA and NODDI values in left M1 and motor 9HPT
% 5. FA and NODDI values in left M1 and motor TMT-A
% 6. FA and NODDI values in left M1 and motor TMT-B

load('\datadir\threshold.mat')
% load either of these for the correlation with motor threshold:
% 1. 
load('\datadir\dti_vals_gm_leftm1.mat')
% 2.
% load('\datadir\dti_vals_smatt_lm1.mat')
% 3.
% load('\datadir\dti_vals_gm_rehme_fsspace.mat')


fa=dti_vals{1};
ndi=dti_vals{2};
odi=dti_vals{3};
fiso=dti_vals{4};
% HC
[r,p]=corrcoef([fa(1:49) ndi(1:49) odi(1:49) fiso(1:49) thresh(1:49)]);
p2=[p(1,2:5) p(2,3:5) p(3,4:5) p(4,5)]; % consider only one triangle
[~,~,~,fdrvec]=fdr_bh(p2)
clear r p p2 fdrvec
% MS
[r,p]=corrcoef([fa(50:99) ndi(50:99) odi(50:99) fiso(50:99) thresh(50:99)]);
p2=[p(1,2:5) p(2,3:5) p(3,4:5) p(4,5)];
[~,~,~,fdrvec]=fdr_bh(p2)
clear r p p2 fdrvec

% load either of these for the correlation of FA and NODDI values within 
% left M1 with neuropsychological scores:
% 4.
load('\npsych_pth\nhpt.mat')
np=nhpt;
% 5. 
% load('\npsych_pth\tmt_a.mat')
% np=tmt_a;
% 6.
% load('\npsych_pth\tmt_b.mat')
% np=tmt_b;
load('\datadir\dti_vals_gm_leftm1.mat')

fa=dti_vals{1};
ndi=dti_vals{2};
odi=dti_vals{3};
fiso=dti_vals{4};
% MS
[r,p]=corrcoef([fa(50:99) ndi(50:99) odi(50:99) fiso(50:99) np]);
p2=[p(1,2:5) p(2,3:5) p(3,4:5) p(4,5)];
[~,~,~,fdrvec]=fdr_bh(p2)
clear r p p2 fdrvec np

