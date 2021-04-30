% This script computes group differences, averages and standard deviations
% of MS and HC thresholds and FA and NODDI values within left M1
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 06/2020 
% 

% group comparison of threshold (MS vs. HC)
load('\datadir\threshold.mat')
[~,p_thresh,~,stats_thresh]=ttest2(threshold(1:49),threshold(50:99));
% average and std MS and HC
avg_thresh_ms=mean(thresh(50:99));
avg_thresh_hc=mean(thresh(1:49));
std_thresh_ms=std(thresh(50:99));
std_thresh_hc=std(thresh(1:49));

% group comparison FA and NODDI values in left M1
load('\datadir\dti_vals_gm_leftm1.mat')
for d=1:4
    [~,p(d),~,stats{d}]=ttest2(dti_vals{d}(50:99),dti_vals{d}(1:49));
    avg_val_ms(d)=mean(dti_vals{d}(50:99));
    avg_val_hc(d)=mean(dti_vals{d}(1:49));
    std_val_ms(d)=std(dti_vals{d}(50:99));
    std_val_hc(d)=std(dti_vals{d}(1:49));    
end



