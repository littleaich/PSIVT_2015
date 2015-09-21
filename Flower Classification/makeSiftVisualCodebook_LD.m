% ======================================================================= %
% Name: makeSiftVisualCodebook_LD.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the third file to extract SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It calculates the visual
% codebook from the SIFT descriptor set using "vlfeat" library downloaded 
% from the link http://www.vlfeat.org/. For codebook calculation in this 
% large dimension, "Approximate Nearest Neighbor" (ANN) option of vlfeat 
% library is used. The file hierarchy for SIFT features extraction and 
% testing using multiple kernel learning (Oxford-102 dataset, PSIVT_2015) 
% is listed as follows: (1) extractSiftFeatures.m, (2) makeSiftDesMat.m, 
% (3) makeSiftVisualCodebook_LD.m, (4) makeSiftFeaMat.m, 
% (5) makeSiftSimMat.m, (6) classifyMKL_Sift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
echo on;
tic;
image_version = 'Images_Min_500';
%image_version = 'Images_Org_Min_500';
featName = 'sift';
radius = 5; % for internal sift
spacing = 5; % both internal and boundary sift
K = 3000;

featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];

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

toc;
clear all; close all;

echo off;
