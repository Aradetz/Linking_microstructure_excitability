% This script creates a sphere around a handknob MNI coordinate using
% marsbar
%
% Radetz et al. (2021): Linking microstructural integrity and motor 
% cortex
% excitability in multiple sclerosis
%
% Angela Radetz, 03/2021
% 

addpath('\scriptdir\')
addpath('\toolboxdir\spm12\toolbox\marsbar')
addpath('\toolboxdir\spm12\')

% Coordinate obtained from Rehme et al. (2012), NeuroImage
coord=[-32 -26 58];
roisize=12;
sphere = maroi_sphere(struct('centre', coord','radius', roisize));
save_as_image(sphere, '/roidir/handknob_rehme.nii' );
