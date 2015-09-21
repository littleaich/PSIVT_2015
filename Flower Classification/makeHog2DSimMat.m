% ======================================================================= %
% Name: makeHog2DSimMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fifth file to extract HOG features from 
% Oxford-102 flower dataset (PSIVT_2015). It calculates the similarity
% matrices among the training samples and the training and test samples for
% multiple kernel learning. The similarity calculations are performed using
% pdist2_dollar.m function. The file hierarchy for HOG features extraction
% and testing using multiple kernel learning 
% (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
% (1) extractHog2DFeatures.m, (2) makeHog2DDesMat.m, 
% (3) makeHog2DVisualCodebook_LD.m, (4) makeHog2DFeaMat.m, 
% (5) makeHog2DSimMat.m, (6) classifyMKL_Hog2D.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
tic;
echo on;

image_version = 'Images_Min_500';
featName = 'hog2D';
cellSize = 8; % default
blockSize = 2; % default
numBins = 9; % default
blockLap = 0;
K = 1500;

dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

featName = [featName,'_',num2str(cellSize),'x',num2str(cellSize),'_', ...
    num2str(blockSize),'x',num2str(blockSize),'_bin_',num2str(numBins)];

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