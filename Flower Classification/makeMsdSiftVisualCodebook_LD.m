% ======================================================================= %
% Name: makeMsdSiftVisualCodebook_LD.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the third file to extract MSD-SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It calculates the visual
% codebook from MSD-SIFT descriptor set using "vlfeat" library downloaded 
% from the link http://www.vlfeat.org/. For codebook calculation in this 
% large dimension, "Approximate Nearest Neighbor" (ANN) option of vlfeat 
% library is used. The file hierarchy for MSD-SIFT features extraction and 
% testing using multiple kernel learning (Oxford-102 dataset, PSIVT_2015) 
% is listed as follows: (1) extractMsdSiftFeatures.m, 
% (2) makeMsdSiftDesMat.m, (3) makeMsdSiftVisualCodebook_LD.m, 
% (4) makeMsdSiftFeaMat.m, (5) makeMsdSiftSimMat.m, 
% (6) classifyMKL_MsdSift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;
echo on;

image_version = 'Images_Min_500';
% image_version = 'Images_Org_Min_500';
featName = 'msdsift';
stepSize = 5; 
mag = 6;
K = 3000;

featName = [featName,'_step_',num2str(stepSize),'_mag_',num2str(mag)];

dbPath = ['../../Databases/Oxford/Features/',image_version,'/'];

run('vlfeat-0.9.20/toolbox/vl_setup.m');

load([dbPath,'TrainDesc_',featName,'.mat']);
trainDesc = trainDesc';

tic; 
[VC,~] = vl_kmeans(trainDesc,K,'verbose','distance','l2',...
    'algorithm','ann'); 
toc;
VC = VC';

save([dbPath,'VC_',num2str(K),'_',featName,'.mat'],'VC');

clear all; close all; 

echo off;
