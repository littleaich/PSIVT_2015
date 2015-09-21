% ======================================================================= %
% Name: makeMsdSiftSimMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fifth file to extract MSD-SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It calculates the similarity
% matrices among the training samples and the training and test samples for
% multiple kernel learning. The similarity calculations are performed using
% pdist2_dollar.m function. The file hierarchy for MSD-SIFT features 
% extraction and testing using multiple kernel learning 
% (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
% (1) extractMsdSiftFeatures.m, (2) makeMsdSiftDesMat.m, 
% (3) makeMsdSiftVisualCodebook_LD.m, (4) makeMsdSiftFeaMat.m, 
% (5) makeMsdSiftSimMat.m, (6) classifyMKL_MsdSift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
tic;
echo on;

image_version = 'Images_Min_500';
%image_version = 'Images_Org_Min_500';
featName = 'msdsift';
stepSize = 5; 
mag = 6;
K = 3000;

dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

featName = [featName,'_step_',num2str(stepSize),'_mag_',num2str(mag)];

load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);

% similarity matrix formation
trainData(isnan(trainData)) = 0;
testData(isnan(testData)) = 0;
tmp = double(pdist2_dollar(trainData,trainData,'chisq'));
tmp = tmp/max(tmp(:));
%tmp = tmp-mean(tmp(:));
%tmp = tmp/std(tmp(:));
tmp = 1-tmp;
simMat{1} = tmp;
clear tmp;
tmp = double(pdist2_dollar(testData,trainData,'chisq'));
tmp = tmp/max(tmp(:));
%tmp = tmp-mean(tmp(:));
%tmp = tmp/std(tmp(:));
tmp = 1-tmp;
simMat{2} = tmp;
clear tmp;

save([dataPath,'SimMat_',num2str(K),'_',featName,'.mat'],'simMat', ...
    'trainLabel','testLabel');

clear all; close all;
echo off;
toc;