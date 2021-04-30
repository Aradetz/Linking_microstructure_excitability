#!/bin/env python


# This script computes NODDI values using AMICO
# 
# Radetz et al. (2021): Linking microstructural integrity and motor 
# cortex excitability in multiple sclerosis
#
# Angela Radetz, 03/2020


import sys
import datetime

print(datetime.datetime.now())


sbjnr=sys.argv[1]
tp=sys.argv[2]
group=sys.argv[3]
freq=sys.argv[4]
base="/datapath/noddi/all"+"/"
folder_sbj='Sbj'+sbjnr+'_'+group+'/'

print(folder_sbj)

import spams

print("import amico")

import amico

print("core setup amico")

amico.core.setup()

print("amico eval")

ae=amico.Evaluation(base,folder_sbj)
amico.util.fsl2scheme(base+folder_sbj+"bvals_for_noddi", base+folder_sbj+"bvecs_for_noddi")

ae.load_data(dwi_filename = "eddy.nii", scheme_filename = "bvals_for_noddi.scheme", mask_filename = "eddy_brain_mask.nii", b0_thr=0)

ae.set_model("NODDI")
ae.generate_kernels()
ae.load_kernels()

ae.fit()

ae.save_results()

print(datetime.datetime.now())


sys.exit(0)

