% This script creates the content of Figures 3 and 4 (Scatterplot, 
% regression line and density estimates of the regressions of neurite 
% density index on motor threshold in MS/HC and on TMT-A and TMT-B in MS)
%
% Radetz et al. (2021): Linking microstructural integrity and motor cortex
% excitability in multiple sclerosis
%
% Muthuraman Muthuraman and Angela Radetz, 06/2020

addpath('\MATLABdir\altmany-export_fig-5b3965b\altmany-export_fig-5b3965b')

load('\datadir\dti_vals_gm_leftm1.mat')
ndi_hc=dti_vals{2}(1:49);
ndi_ms=dti_vals{2}(50:99);

load('\datadir\dti_vals_gm_leftm1_ms_for_tmt.mat')
ndi_ms_for_tmt=dti_vals{2};
load('\datadir\threshold.mat')



%% MS: motor threshold and NDI
% Create a regression plot with confidence intervals
xData=ndi_ms;
yData=threshold(50:99);
yDatName = 'Motor threshold';
xDatName = 'Neurite density index';
col1=[0/255 110/255 150/255]; %blueish

% regression statistics
stepsX = .005;
newROIdata = table(yData,xData,'VariableNames',{'MT','NDI'});
lmObj = fitlm(newROIdata,'ResponseVar','MT','PredictorVars','NDI');
Rsq = lmObj.Rsquared.Adjusted; RHO1 = Rsq;
pval = lmObj.Coefficients.pValue; PVAL1 = pval(2);
fprintf(2,'r^2 = %s \t p = %s \n', num2str(RHO1),num2str(PVAL1));

figure; hold on
ylim(yl)
xlim(xl);
ylim([30 90])
xlim([0.27 0.48])
gcol=[120/255 90/255 90/255];   
scatter(xData,yData,80,col1,'filled');
% define boundaries for CI:
n1 = length(yData);
STATS1 = regstats(yData,xData,'linear','beta');
GP1ind = xData; GP1dep = yData;
GP1xval = min(GP1ind)-stepsX:stepsX:max(GP1ind)+stepsX; 
beta1 = STATS1.beta;
Y1 = ones(size(GP1xval))*beta1(1) + beta1(2)*GP1xval;
SE_y_cond_x1 = sum((GP1dep - beta1(1)*ones(size(GP1dep))-beta1(2)*GP1ind).^2)/(n1-2);
SSX1 = (n1-1)*var(GP1ind);
SE_Y1 = SE_y_cond_x1*(ones(size(GP1xval))*(1/n1 + (mean(GP1ind)^2)/SSX1) + (GP1xval.^2 - 2*mean(GP1ind)*GP1xval)/SSX1);
Yoff1 = (2*finv(1-0.05,2,n1-2)*SE_Y1).^0.5;
top_int1 = Y1 + Yoff1;
bot_int1 = Y1 - Yoff1;
plot(GP1xval,Y1,'LineWidth',3,'Color',gcol);
% plot the CI as filled area
x_plot1 =[GP1xval, fliplr(GP1xval)];
y_plot2=[bot_int1, flipud(top_int1')'];
fill(x_plot1, y_plot2, 1,'facecolor', col1, 'edgecolor', col1, 'facealpha', 0.3); %[0 1 1]
ylabel(yDatName,'FontSize',14,'Interpreter','none')
xlabel(xDatName,'FontSize',14,'Interpreter','none');
scatter(xData,yData,80,col1,'filled');


set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Scatter_NDI_MT_MS.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1);hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Hist_NDI_MT_MS.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1,'Kernel', 'on');hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Histline_NDI_MT_MS.eps','-depsc','-r800')




%% HC: motor threshold and NDI
% Create a regression plot with confidence intervals
xData=ndi_hc;
yData=threshold(1:49);
yDatName = 'Motor threshold';
xDatName = 'Neurite density index';
col1=[0/255 110/255 150/255]; %blueish

% regression statistics
stepsX = .005;
newROIdata = table(yData,xData,'VariableNames',{'MT','NDI'});
lmObj = fitlm(newROIdata,'ResponseVar','MT','PredictorVars','NDI');
Rsq = lmObj.Rsquared.Adjusted; RHO1 = Rsq;
pval = lmObj.Coefficients.pValue; PVAL1 = pval(2);
fprintf(2,'r^2 = %s \t p = %s \n', num2str(RHO1),num2str(PVAL1));

figure; hold on
ylim(yl)
xlim(xl);
ylim([35 80])
xlim([0.28 0.47])
gcol=[120/255 90/255 90/255];   
scatter(xData,yData,80,col1,'filled');
% define boundaries for CI:
n1 = length(yData);
STATS1 = regstats(yData,xData,'linear','beta');
GP1ind = xData; GP1dep = yData;
GP1xval = min(GP1ind)-stepsX:stepsX:max(GP1ind)+stepsX; 
beta1 = STATS1.beta;
Y1 = ones(size(GP1xval))*beta1(1) + beta1(2)*GP1xval;
SE_y_cond_x1 = sum((GP1dep - beta1(1)*ones(size(GP1dep))-beta1(2)*GP1ind).^2)/(n1-2);
SSX1 = (n1-1)*var(GP1ind);
SE_Y1 = SE_y_cond_x1*(ones(size(GP1xval))*(1/n1 + (mean(GP1ind)^2)/SSX1) + (GP1xval.^2 - 2*mean(GP1ind)*GP1xval)/SSX1);
Yoff1 = (2*finv(1-0.05,2,n1-2)*SE_Y1).^0.5;
top_int1 = Y1 + Yoff1;
bot_int1 = Y1 - Yoff1;
plot(GP1xval,Y1,'LineWidth',3,'Color',gcol);
% plot the CI as filled area
x_plot1 =[GP1xval, fliplr(GP1xval)];
y_plot2=[bot_int1, flipud(top_int1')'];
fill(x_plot1, y_plot2, 1,'facecolor', col1, 'edgecolor', col1, 'facealpha', 0.3); %[0 1 1]
ylabel(yDatName,'FontSize',14,'Interpreter','none')
xlabel(xDatName,'FontSize',14,'Interpreter','none');
scatter(xData,yData,80,col1,'filled');

set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Scatter_NDI_MT_HC.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1);hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Hist_NDI_MT_HC.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1,'Kernel', 'on');hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Histline_NDI_MT_HC.eps','-depsc','-r800')





%% MS: TMT-A and NDI
% Create a regression plot with confidence intervals
xData=ndi_ms_for_tmt; % contains only n=44
yData=tmt_a;
yDatName = 'TMT-A (z-score)';
xDatName = 'Neurite density index';
col1=[90/255 200/255 130/255]; %greenish

% regression statistics
stepsX = .005;
newROIdata = table(yData,xData,'VariableNames',{'MT','NDI'});
lmObj = fitlm(newROIdata,'ResponseVar','MT','PredictorVars','NDI');
Rsq = lmObj.Rsquared.Adjusted; RHO1 = Rsq;
pval = lmObj.Coefficients.pValue; PVAL1 = pval(2);
fprintf(2,'r^2 = %s \t p = %s \n', num2str(RHO1),num2str(PVAL1));

figure; hold on
xl=[0.33 0.48];
yl=[-3 2.5];
ylim(yl)
xlim(xl);
gcol=[120/255 90/255 90/255];   
scatter(xData,yData,80,col1,'filled');
% define boundaries for CI:
n1 = length(yData);
STATS1 = regstats(yData,xData,'linear','beta');
GP1ind = xData; GP1dep = yData;
GP1xval = min(GP1ind)-stepsX:stepsX:max(GP1ind)+stepsX; 
beta1 = STATS1.beta;
Y1 = ones(size(GP1xval))*beta1(1) + beta1(2)*GP1xval;
SE_y_cond_x1 = sum((GP1dep - beta1(1)*ones(size(GP1dep))-beta1(2)*GP1ind).^2)/(n1-2);
SSX1 = (n1-1)*var(GP1ind);
SE_Y1 = SE_y_cond_x1*(ones(size(GP1xval))*(1/n1 + (mean(GP1ind)^2)/SSX1) + (GP1xval.^2 - 2*mean(GP1ind)*GP1xval)/SSX1);
Yoff1 = (2*finv(1-0.05,2,n1-2)*SE_Y1).^0.5;
top_int1 = Y1 + Yoff1;
bot_int1 = Y1 - Yoff1;
plot(GP1xval,Y1,'LineWidth',3,'Color',gcol);
% plot the CI as filled area
x_plot1 =[GP1xval, fliplr(GP1xval)];
y_plot2=[bot_int1, flipud(top_int1')'];
fill(x_plot1, y_plot2, 1,'facecolor', col1, 'edgecolor', col1, 'facealpha', 0.3); %[0 1 1]
ylabel(yDatName,'FontSize',14,'Interpreter','none')
xlabel(xDatName,'FontSize',14,'Interpreter','none');
scatter(xData,yData,80,col1,'filled');


set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Scatter_NDI_TMT-A.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1);hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Hist_NDI_TMT-A.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1,'Kernel', 'on');hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Histline_NDI_TMT-A.eps','-depsc','-r800')




%% MS: TMT-B and NDI
% Create a regression plot with confidence intervals
xData=ndi_ms_for_tmt; % contains only n=44
yData=tmt_b;
yDatName = 'TMT-B (z-score)';
xDatName = 'Neurite density index';
col1=[240/255 200/255 80/255]; %orange

% regression statistics
stepsX = .005;
newROIdata = table(yData,xData,'VariableNames',{'MT','NDI'});
lmObj = fitlm(newROIdata,'ResponseVar','MT','PredictorVars','NDI');
Rsq = lmObj.Rsquared.Adjusted; RHO1 = Rsq;
pval = lmObj.Coefficients.pValue; PVAL1 = pval(2);
fprintf(2,'r^2 = %s \t p = %s \n', num2str(RHO1),num2str(PVAL1));

figure; hold on
% MS - TMT-B NDI
xl=[0.33 0.48];
yl=[-3.5 2];
ylim(yl)
xlim(xl);
gcol=[120/255 90/255 90/255];   
scatter(xData,yData,80,col1,'filled');
% define boundaries for CI:
n1 = length(yData);
STATS1 = regstats(yData,xData,'linear','beta');
GP1ind = xData; GP1dep = yData;
GP1xval = min(GP1ind)-stepsX:stepsX:max(GP1ind)+stepsX; 
beta1 = STATS1.beta;
Y1 = ones(size(GP1xval))*beta1(1) + beta1(2)*GP1xval;
SE_y_cond_x1 = sum((GP1dep - beta1(1)*ones(size(GP1dep))-beta1(2)*GP1ind).^2)/(n1-2);
SSX1 = (n1-1)*var(GP1ind);
SE_Y1 = SE_y_cond_x1*(ones(size(GP1xval))*(1/n1 + (mean(GP1ind)^2)/SSX1) + (GP1xval.^2 - 2*mean(GP1ind)*GP1xval)/SSX1);
Yoff1 = (2*finv(1-0.05,2,n1-2)*SE_Y1).^0.5;
top_int1 = Y1 + Yoff1;
bot_int1 = Y1 - Yoff1;
plot(GP1xval,Y1,'LineWidth',3,'Color',gcol);
% plot the CI as filled area
x_plot1 =[GP1xval, fliplr(GP1xval)];
y_plot2=[bot_int1, flipud(top_int1')'];
fill(x_plot1, y_plot2, 1,'facecolor', col1, 'edgecolor', col1, 'facealpha', 0.3); %[0 1 1]
ylabel(yDatName,'FontSize',14,'Interpreter','none')
xlabel(xDatName,'FontSize',14,'Interpreter','none');
scatter(xData,yData,80,col1,'filled');

set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Scatter_NDI_TMT-B.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1);hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Hist_NDI_TMT-B.eps','-depsc','-r800')

figure;
scatterhist(xData, yData,'NBins', [11,11],'Color',col1,'Kernel', 'on');hold on;
ylim(yl)
xlim(xl)
set(gcf,'Renderer','painters')
print(gcf,'\plotpth\Histline_NDI_TMT-B.eps','-depsc','-r800')

