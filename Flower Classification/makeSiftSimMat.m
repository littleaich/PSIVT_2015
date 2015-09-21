% ======================================================================= %
% Name: makeSiftSimMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fifth file to extract SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It calculates the similarity
% matrices among the training samples and the training and test samples for
% multiple kernel learning. The similarity calculations are performed using
% pdist2_dollar.m function. The file hierarchy for SIFT features extraction
% and testing using multiple kernel learning 
% (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
% (1) extractSiftFeatures.m, (2) makeSiftDesMat.m, 
% (3) makeSiftVisualCodebook_LD.m, (4) makeSiftFeaMat.m, 
% (5) makeSiftSimMat.m, (6) classifyMKL_Sift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
tic;
echo on;

image_version = 'Images_Min_500';
%image_version = 'Images_Org_Min_500';
featName = 'sift';
radius = 10; % for internal sift
spacing = 10; % both internal and boundary sift
K = 3000;

dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];

load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);

% similarity matrix formation
tmp = double(pdist2_dollar(trainData,trainData,'chisq'));
tmp = tmp/max(tmp(:));
tmp = 1-tmp;
simMat{1} = tmp;
clear tmp;
tmp = double(pdist2_dollar(testData,trainData,'chisq'));
tmp = tmp/max(tmp(:));
tmp = 1-tmp;
simMat{2} = tmp;
clear tmp;

save([dataPath,'SimMat_',num2str(K),'_',featName,'.mat'],'simMat', ...
    'trainLabel','testLabel');

clear all; close all;
echo off;
toc;