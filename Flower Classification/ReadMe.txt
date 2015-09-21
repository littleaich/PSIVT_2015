The codes are written in 64 bit Ubuntu 14.04 platform.
Before executing the files listed here, the Oxford-102 class flower dataset 
should be placed in such a way that the dataset can be accessed from the code
directory using this path "../../Databases/Oxford/". Copy the dataset mat files "setid.mat" and "imagelabes.mat" in this directory. Also, all the images should be
copied into the "Images/" subdirectory inside this directory so that images can be 
accessed from the code directory using this path "../../Databases/Oxford/Images".

======================================================
Libraries Used:
(1) Multiple Kernel Learning http://leitang.net/code/mkl-multiple-label/README.txt
(2) LibSVM 
(3) MOSEK (License Needed !!!)
(4) GrabCut http://grabcut.weebly.com/code.html
=====================================
Image Preprocessing:
(1) Segmentation_GrabCut.m
(2) segmentGrabCut.m
(3) adjustSegImg.m
(4) bwNoiseReduction.m
(5) resize_min_500.m
=====================================
HSV Feature Extraction:
(1) extractColorDescriptors.m
(2) makeDesMat.m
(3) makeVisualCodebook_LD.m
(4) makeFeaMat.m
(5) makeSimMat.m
(6) classifyMKL.m
=====================================
SIFT Feature Extraction:
(1) extractSiftFeatures.m
(2) makeSiftDesMat.m
(3) makeSiftVisualCodebook_LD.m
(4) makeSiftFeaMat.m
(5) makeSiftSimMat.m
(6) classifyMKL_Sift.m
=====================================
MSD-SIFT Feature Extraction:
(1) extractMsdSiftFeatures.m
(2) makeMsdSiftDesMat.m
(3) makeMsdSiftVisualCodebook_LD.m
(4) makeMsdSiftFeaMat.m
(5) makeMsdSiftSimMat.m
(6) classifyMKL_MsdSift.m
=====================================
HOG Feature Extraction:
(1) extractHog2DFeatures.m
(2) makeHog2DDesMat.m
(3) makeHog2DVisualCodebook_LD.m
(4) makeHog2DFeaMat.m
(5) makeHog2DSimMat.m
(6) classifyMKL_Hog2D.m
=====================================
Combined Classification:
(1) classifyMKL_All.m
=====================================

N.B. The files not listed here, but present in this folder are used by the files
listed here for processing.
=========================================================

