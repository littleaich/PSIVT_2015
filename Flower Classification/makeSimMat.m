% ======================================================================= %
% Name: makeSimMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fifth file to extract HSV color descriptors 
% from Oxford-102 flower dataset (PSIVT_2015). It calculates the similarity
% matrices among the training samples and the training and test samples for
% multiple kernel learning. The similarity calculations are performed using
% pdist2_dollar.m function. The file hierarchy for HSV color features 
% extraction and testing using multiple kernel learning (Oxford-102 
% dataset, PSIVT_2015) is listed as follows: (1) extractColorDescriptors.m,
% (2) makeDesMat.m, (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, 
% (5) makeSimMat.m, (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
tic;
echo on;

image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
IGNORE_LOCATION = true;
K = 900; % change
featName = 'hsv'; % change
blockSize = 3;
featName = [featName,'_',num2str(blockSize),'x',num2str(blockSize)];

dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

if IGNORE_LOCATION
    load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);
else
    load([dataPath,'Data_',num2str(K),'_',featName,'_Loc.mat']);
end

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