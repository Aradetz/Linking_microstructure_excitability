% This script creates Figures 6 and S5 (pie and barplot related to TBSS
% analysis)
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 06/2020

%% SMATT TBSS plots (Figure 6)

load('tbss_smatt_dir\tbss_vars.mat')
% tbss_vars.mat contains the files obtained from script intersections_fa_noddi_tbss_smatt.sh

% SMATT regions sorted decreasingly by the percentage of voxels showing
% sig. group differences of each region, summed over FA, NDI and ODI
clear barmat
barmat=zeros(12,7);
l=1;
for k=[12 7 11 1 9 8 10 6 5 4 3 2]
    barmat(l,:)=[FA_ODI_NDI_added(k) FA_NDI_only(k) FA_ODI_only(k) ODI_NDI_only(k) ...
        FA_only(k) NDI_only(k) ODI_only(k)];
    l=l+1;
end

% take percentage
clear barmat_prctg
barmat_prctg=zeros(12,7);
for k=1:length(barmat)
    p=100/sum(barmat(k,:));
   barmat_prctg(k,:)= barmat(k,:).*p;
end

sum_all=sum(barmat,1);
prctg_all=100/sum(sum_all).*sum_all;

%% pie plot for SMATT
c=[ 0.9290 0.6940 0.1250
    0 1 1
    1 1 0   
    1 0 1
    0 0 1
    0 1 0
    1 0 0];
labels={'FA, ODI, NDI', 'FA, NDI', 'FA, ODI', 'NDI, ODI', 'FA', 'NDI', ...
    'ODI'};
p=pie(prctg_all);
legend(labels)
colormap(c)
for a=2:2:14
    t=p(a);
    t.FontSize = 10;
    t.FontWeight='Bold';
end
set( gcf,'PaperSize',[29.7 21.0], 'PaperPosition',[0 0 29.7 21.0])
print(gcf,'\plotdir\pie_FA_NODDI_SMATT.pdf','-dpdf')

%% bar plot for SMATT
bar(barmat_prctg,'stacked')
legend('FA, ODI, NDI', 'FA, NDI', 'FA, ODI', 'NDI, ODI', 'FA', 'NDI', ...
    'ODI', 'location', 'bestoutside')
box off
xlim([0.5 12.5])
ylim([0 100])
colormap(c)
       
varnames = {'R SMA', 'R M1', 'R S1', 'L M1', 'R PMv', 'R PMd', 'R pre-SMA', 'L SMA', 'L S1',...
    'L pre-SMA', 'L PMv', 'L PMd'};
set(gca,'xtick',1:12)
set(gca,'xticklabel',varnames,'FontWeight','Bold','Fontname','Calibri','FontSize',12)
set(gca,'xticklabelrotation',45)
ylabel('Number of voxels','FontSize',14,'FontWeight','Bold', 'FontSize',12)
set(gcf, 'PaperPositionMode', 'auto')
print(gcf,'\plotdir\pie_fa_noddi_smatt.pdf','-dpdf','-bestfit')
print('-dtiff','-r500','\plotdir\pie_fa_noddi_smatt.tiff')

%% JHU TBSS plots (Figure S5)

load('\tbss_jhu_dir\tbss_vars.mat') 
% tbss_vars.mat contains the files obtained from script intersections_fa_noddi_tbss_jhu.sh

% only the JHU regions that showed an overlap are included; sorted
% decreasingly by the percentage of voxels showing sig. group differences
% of each region, summed over FA, NDI and ODI
l=1; clear barmat
barmat=zeros(45,7);
for k=[39 40 30 22 29 4 31 3 32 34 24 21 27 5 42 ...
        6 23 41 28 26 25 15 44 17 43 37 20 46 35 16 18 ...
        38 33 36 19 47 7 13 11 9 1 45 48 8 2]
    barmat(l,:)=[FA_ODI_NDI_added(k) FA_NDI_only(k) FA_ODI_only(k) ...
        ODI_NDI_only(k) FA_only(k) NDI_only(k) ODI_only(k)];
    l=l+1;
end

% take percentage
barmat_prctg=zeros(45,7);
for k=1:45
    p=100/sum(barmat(k,:));
   barmat_prctg(k,:)= barmat(k,:).*p;
end

sum_all=sum(barmat,1);
prctg_all=100/sum(sum_all).*sum_all;

c=[ 0.9290 0.6940 0.1250
    0 1 1
    1 1 0   
    1 0 1
    0 0 1
    0 1 0
    1 0 0];
labels={'FA, ODI, NDI', 'FA, NDI', 'FA, ODI', 'NDI, ODI', 'FA', 'NDI', ...
    'ODI'};
p=pie(prctg_all);
legend(labels)
colormap(c)
for a=2:2:14
    t=p(a);
    t.FontSize = 10;
    t.FontWeight='Bold';
end
set( gcf,'PaperSize',[29.7 21.0], 'PaperPosition',[0 0 29.7 21.0])
print(gcf,'\plotdir\pie_FA_NODDI_JHU.pdf','-dpdf')

%% Barplot JHU
bar(barmat_prctg,'stacked')
legend('FA, ODI, NDI', 'FA, NDI', 'FA, ODI', 'NDI, ODI', 'FA', 'NDI', ...
    'ODI', 'location', 'bestoutside')
box off
colormap(c)

varnames = {'L fornix / stria terminalis' 'R fornix / stria terminalis'...
    'L posterior thalamic radiation' 'L retrolenticular part of internal capsule'...
    'R posterior thalamic radiation' 'Body of corpus callosum' 'R sagittal stratum' ...
    'Genu of corpus callosum' 'L sagittal stratum' 'L external capsule' 'L anterior corona radiata' ...
    'R retrolenticular part of internal capsule' 'R posterior corona radiata' 'Splenium of corpus callosum'...
    'L superior longitudinal fasciculus' 'Fornix' 'R anterior corona radiata' 'R superior longitudinal fasciculus'...
    'L posterior corona radiata' 'Left superior corona radiata' 'R superior corona radiata' 'R cerebral peduncle'...
    'L superior fronto-occipital fasciculus' 'R anterior limb of internal capsule' 'R superior fronto-occipital fasciculus'...
    'R cingulum (hippocampus)' 'L posterior limb of internal capsule' 'L uncinate fasciculus' 'R cingulum (cingulate gyrus)'...
    'L cerebral peduncle' 'L anterior limb of internal capsule' 'L cingulum (hippocampus)' 'R external capsule'...
    'L cingulum (cingulate gyrus)' 'R posterior limb of internal capsule' 'R tapetum' 'R corticospinal tract' ...
    'R superior cerebellar peduncle' 'R inferior cerebellar peduncle' 'R medial lemniscus' 'Middle cerebellar peduncle'...
    'R uncinate fasiculus' 'L tapetum' 'L corticospinal tract' 'Pontine crossing tract',...
    'R SMA', 'R M1', 'R S1', 'L M1', 'R PMv', 'R PMd', 'R pre-SMA', 'L SMA', 'L S1', 'L pre-SMA', 'L PMv', 'L PMd'};
set(gca,'xtick',1:45)
set(gca,'xticklabel',varnames,'FontWeight','Bold','Fontname','Calibri','FontSize',12)
set(gca,'xticklabelrotation',45)
ylabel('Percentage','FontSize',14,'FontWeight','Bold', 'FontSize',12)

set(gca,'xlim',[0 46])
set(gca,'ylim',[0 100])
print(gcf,'\plotdir\bar_FA_NODDI_JHU.pdf','-dpdf','-bestfit')
print('-dtiff','-r500','\plotdir\bar_FA_NODDI_JHU.tiff')


