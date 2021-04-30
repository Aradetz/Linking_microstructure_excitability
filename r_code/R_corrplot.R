% This script creates correlation plots (Figures 2, S1, S3 and S4)
%
% Radetz et al. (2021): Linking microstructural integrity and motor
% cortex excitability in multiple sclerosis
%
% Angela Radetz, 06/2020
%


library("corrplot")
source("http://www.sthda.com/upload/rquery_cormat.r")
https://rstudio-pubs-static.s3.amazonaws.com/240657_5157ff98e8204c358b2118fa69162e18.html
library("Hmisc")
library(R.matlab)


pathname <- file.path("/datadir_R/", "threshold.mat")
thresh_hc <- data.frame(readMat(pathname)$threshold[1:49])
thresh_ms <- data.frame(readMat(pathname)$threshold[50:99])


### left M1 variables
pathname <- file.path("/datadir_R/", "fa_gm_leftm1.mat")
fa_gm_leftm1_hc <- data.frame(readMat(pathname)$fa_gm_leftm1[1:49])
fa_gm_leftm1_ms <- data.frame(readMat(pathname)$fa_gm_leftm1[50:99])

pathname <- file.path("/datadir_R/", "ndi_gm_leftm1.mat")
ndi_gm_leftm1_hc <- data.frame(readMat(pathname)$ndi_gm_leftm1[1:49])
ndi_gm_leftm1_ms <- data.frame(readMat(pathname)$ndi_gm_leftm1[50:99])

pathname <- file.path("/datadir_R/", "odi_gm_leftm1.mat")
odi_gm_leftm1_hc <- data.frame(readMat(pathname)$odi_gm_leftm1[1:49])
odi_gm_leftm1_ms <- data.frame(readMat(pathname)$odi_gm_leftm1[50:99])

pathname <- file.path("/datadir_R", "fiso_gm_leftm1.mat")
fiso_gm_leftm1_hc <- data.frame(readMat(pathname)$fiso_gm_leftm1[1:49])
fiso_gm_leftm1_ms <- data.frame(readMat(pathname)$fiso_gm_leftm1[50:99])


### FA and NODDI variables for correlation with npsych (lower n)
# TMT
pathname <- file.path("/datadir_R/", "fa_gm_leftm1_ms4tmt.mat")
fa_gm_leftm1_ms4tmt <- data.frame(readMat(pathname)$fa_gm_leftm1_ms4tmt)

pathname <- file.path("/datadir_R/", "ndi_gm_leftm1_ms4tmt.mat")
ndi_gm_leftm1_ms4tmt <- data.frame(readMat(pathname)$ndi_gm_leftm1_ms4tmt)

pathname <- file.path("/datadir_R/", "odi_gm_leftm1_ms4tmt.mat")
odi_gm_leftm1_ms4tmt <- data.frame(readMat(pathname)$odi_gm_leftm1_ms4tmt)

pathname <- file.path("/datadir_R/", "fiso_gm_leftm1_ms4tmt.mat")
fiso_gm_leftm1_ms4tmt <- data.frame(readMat(pathname)$fiso_gm_leftm1_ms4tmt)

# 9HPT
pathname <- file.path("/datadir_R/", "fa_gm_leftm1_ms4nhpt.mat")
fa_gm_leftm1_ms4nhpt <- data.frame(readMat(pathname)$fa_gm_leftm1_ms4nhpt)

pathname <- file.path("/datadir_R/", "ndi_gm_leftm1_ms4nhpt.mat")
ndi_gm_leftm1_ms4nhpt <- data.frame(readMat(pathname)$ndi_gm_leftm1_ms4tmt)

pathname <- file.path("/datadir_R/", "odi_gm_leftm1_ms4nhpt.mat")
odi_gm_leftm1_ms4nhpt <- data.frame(readMat(pathname)$odi_gm_leftm1_ms4tmt)

pathname <- file.path("/datadir_R/", "fiso_gm_leftm1_ms4nhpt.mat")
fiso_gm_leftm1_ms4nhpt <- data.frame(readMat(pathname)$fiso_gm_leftm1_ms4nhpt)


# Npsych variables
pathname <- file.path("/datadir_R/ ", "tmt_a_z.mat")
tmt_a <- data.frame(readMat(pathname)$tmt.a.z)
pathname <- file.path("/datadir_R/ ", "tmt_b_z.mat")
tmt_b <- data.frame(readMat(pathname)$tmt.b.z)
pathname <- file.path("/datadir_R/ ", "nhpt_z.mat")
nhpt <- data.frame(readMat(pathname)$nhpt.z)



### Hand variables - intersection with cortical ribbon fsspace
pathname <- file.path("datadir_R/", "fa_gm_hand_fsspace.mat")
fa_hand_hc <- data.frame(readMat(pathname)$fa_handknob[1:49])
fa_hand_ms <- data.frame(readMat(pathname)$fa_handknob [50:99])

pathname <- file.path("/datadir_R/", "ndi_gm_hand_fsspace.mat")
ndi_hand_hc <- data.frame(readMat(pathname)$ndi_handknob[1:49])
ndi_hand_ms <- data.frame(readMat(pathname)$ndi_handknob[50:99])

pathname <- file.path("/datadir_R/", "odi_gm_hand_fsspace.mat")
odi_hand_hc <- data.frame(readMat(pathname)$odi_handknob[1:49])
odi_hand_ms <- data.frame(readMat(pathname)$odi_handknob[50:99])

pathname <- file.path("/datadir_R/", "fiso_gm_hand_fsspace.mat")
fiso_hand_hc <- data.frame(readMat(pathname)$fiso_handknob[1:49])
fiso_hand_ms <- data.frame(readMat(pathname)$fiso_handknob[50:99])



### SMATT variables
pathname <- file.path("/datadir_R/", "fa_smatt_m1.mat")
fa_smatt_hc <- data.frame(readMat(pathname)$fa_smatt_lm1[1:49])
fa_smatt_ms <- data.frame(readMat(pathname)$fa_smatt_lm1[50:99])

pathname <- file.path("/datadir_R/", "ndi_smatt_m1.mat")
ndi_smatt_hc <- data.frame(readMat(pathname)$ndi_smatt_lm1[1:49])
ndi_smatt_ms <- data.frame(readMat(pathname)$ndi_smatt_lm1[50:99])

pathname <- file.path("/datadir_R/", "odi_smatt_m1.mat")
odi_smatt_hc <- data.frame(readMat(pathname)$odi_smatt_lm1[1:49])
odi_smatt_ms <- data.frame(readMat(pathname)$odi_smatt_lm1[50:99])

pathname <- file.path("/datadir_R/", "fiso_smatt_m1.mat")
fiso_smatt_hc <- data.frame(readMat(pathname)$fiso_smatt_lm1[1:49])
fiso_smatt_ms <- data.frame(readMat(pathname)$fiso_smatt_lm1[50:99])



### Correlation plots threshold

# MS correlations left M1
tmp <- cbind(fa_gm_leftm1_ms,ndi_gm_leftm1_ms,odi_gm_leftm1_ms,fiso_gm_leftm1_ms,thresh_ms)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_leftm1_MS.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()

# HC correlations left M1
tmp <- cbind(fa_gm_leftm1_hc,ndi_gm_leftm1_hc,odi_gm_leftm1_hc,fiso_gm_leftm1_hc,thresh_hc)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_leftm1_HC.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()



# MS correlations SMATT
tmp <- cbind(fa_smatt_ms,ndi_smatt_ms,odi_smatt_ms,fiso_smatt_ms,thresh_ms)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_smatt_MS.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()

# HC correlations SMATT 
tmp <- cbind(fa_smatt_hc,ndi_smatt_hc,odi_smatt_hc,fiso_smatt_hc,thresh_hc)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_smatt_HC.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()



# MS correlations Hand
tmp <- cbind(fa_hand_ms,ndi_hand_ms,odi_hand_ms,fiso_hand_ms,thresh_ms)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_Hand_ribbon_MS.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()

# HC correlations Hand
tmp <- cbind(fa_hand_hc,ndi_hand_hc,odi_hand_hc,fiso_hand_hc,thresh_hc)
colnames(tmp) <- list("FA","NDI","ODI","IVF","Threshold")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_Hand_ribbon_HC.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()


### Correlation plots npsych
# TMT-A
tmp <- cbind(fa_gm_leftm1_ms4tmt,ndi_gm_leftm1_ms4tmt,odi_gm_leftm1_ms4tmt,fiso_gm_leftm1_ms4tmt,tmt_a)
colnames(tmp) <- list("FA","NDI","ODI","IVF","TMT-A")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_tmt_a.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()

# TMT-B
tmp <- cbind(fa_gm_leftm1_ms4tmt,ndi_gm_leftm1_ms4tmt,odi_gm_leftm1_ms4tmt,fiso_gm_leftm1_ms4tmt,tmt_b)
colnames(tmp) <- list("FA","NDI","ODI","IVF","TMT-B")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_tmt_b.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()


# 9HPT
tmp <- cbind(fa_gm_leftm1_ms4nhpt,ndi_gm_leftm1_ms4nhpt,odi_gm_leftm1_ms4nhpt,fiso_gm_leftm1_ms4mhpt,nhpt)
colnames(tmp) <- list("FA","NDI","ODI","IVF","9HPT")
cormat=cor(tmp,use="complete.obs")
res2 <- rcorr(as.matrix(tmp))
res2
b<-simplify2array(res2[3])

pdf(file="/plotdir/corrplot_nhpt.pdf")
corrplot(cormat,method="ellipse",addCoef.col="black",tl.col="black")
dev.off()


